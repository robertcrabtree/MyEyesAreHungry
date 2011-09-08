//
//  ImageReference.m
//  Inspect
//
//  Created by jason adams on 2/23/10.
//  Copyright 2010 Outrider Software Inc.. All rights reserved.
//

#import "ImageReference.h"
//#import "plist_key_strings.h"
//#import "ImageImportThread.h"
#include <math.h>

#define MAX_WIDTH    520.0
#define MAX_HEIGHT   390.0

#define ThrowWandException(wand) { \
char * description; \
ExceptionType severity; \
\
description = MagickGetException(wand,&severity); \
(void) fprintf(stderr, "%s %s %lu %s\n", GetMagickModule(), description); \
description = (char *) MagickRelinquishMemory(description); \
}


CGImageRef createStandardImage(CGImageRef image, UIImageOrientation orient) {
	const size_t width = CGImageGetWidth(image);
	const size_t height = CGImageGetHeight(image);
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGContextRef ctx = CGBitmapContextCreate(NULL, width, height, 8, 4*width, space,
											 kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedFirst);
	CGColorSpaceRelease(space);
	CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), image);
	CGImageRef dstImage = CGBitmapContextCreateImage(ctx);
	CGContextRelease(ctx);
	return dstImage;
}


@implementation ImageReference

- (id)init {
    if ((self = [super init]))
    {
    	// set the path so that IM can find the configuration files (*.xml files)
    	NSString * path = [[NSBundle mainBundle] resourcePath];
    	setenv("MAGICK_CONFIGURE_PATH", [path UTF8String], 1);

    	// printout ImageMagick version
    	//NSLog(@"%s", GetMagickVersion(nil));
    }
    
    return self;
}


- (void)dealloc {
    [image release];
    if (imageData) {
        NSLog(@"imagedata count=%d", imageData.retainCount);
        [imageData release];
    }
    magickWand = DestroyMagickWand(magickWand);
    MagickWandTerminus();
    [super dealloc];
}


- (id)initWithNewImage:(UIImage*)newImage {
    if (newImage == nil)
    {
        [self release];
        return nil;
    }
    
    if ((self = [self init]))
    {            
        image = newImage;
        [image retain];
        MagickWandGenesis();
        magickWand = NewMagickWand();
    }
    
    return self;
}

-(NSData *)getData
{
    if (imageData)
        return imageData;
    
    size_t len;
    unsigned char *blob = MagickGetImageBlob(magickWand, &len);
    imageData = [NSData dataWithBytes:blob length:len];
    [imageData retain];
    NSLog(@"imageData.length end=%d", (int) len);
    return [imageData autorelease];
}

- (BOOL)processImage
{
    BOOL status = NO;
    
    if (image)
    {
	    const char *fileFormat = "JPEG"; // hard coded
    	const char *map = "ARGB"; // hard coded
    	const StorageType inputStorage = CharPixel;
    	const void *bytes = nil;
    	NSData *srcData = nil;
        CGImageRef imageRef = [image CGImage];
    	CGImageRef standardized = createStandardImage(imageRef, image.imageOrientation);

    	if (standardized)
    	{
            int width = CGImageGetWidth(standardized);
            int height = CGImageGetHeight(standardized);
            
            NSLog(@"Importing image: orig dimensions: %f x %f -- standard dimensions: %d x %d", (image.size.width), (image.size.height), width, height);
        	srcData = (NSData *) CGDataProviderCopyData(CGImageGetDataProvider(standardized));
        	CGImageRelease(standardized);
        	bytes = [srcData bytes];
            
            NSLog(@"imageData.length start=%d", srcData.length);

            if (bytes)
            {
            	MagickBooleanType magick_status = MagickConstituteImage(magickWand, width, height, map, inputStorage, bytes);

            	if (magick_status != MagickFalse)
                {
                    magick_status = MagickSetImageFormat(magickWand, fileFormat);
                    
                    if (magick_status != MagickFalse)
                    {
                        // rotate the image
                        [self rotateIfNecessary:image.imageOrientation];
                        
                        // scale the image
                        if (![ImageReference scaleImage:magickWand])
                        {
                            NSLog(@"ImageReference:processImage: Error creating full uiimage");
                        }
                        else
                        {
                            status = YES;

                        }
                    }
                    else
                    {
                        NSLog(@"ImageReference:processImage: MagickSetImageFormat failed");
                		ThrowWandException(magickWand);
                	}
                }
                else
                {
                    NSLog(@"ImageReference:processImage: MagickConstituteImage failed");
            		ThrowWandException(magickWand);
            	}

            }
            else
            {
                NSLog(@"ImageReference:processImage: Can't get sourceImage bytes");
            }

            if (srcData)
            {
                [srcData release];
            }

        }
        else
        {
            NSLog(@"ImageReference:processImage: Can't get sourceImage bytes");
        }
                
    }
    
    return status;
}


- (void)rotateIfNecessary:(UIImageOrientation)orient
{
    double angle = 0;
    
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            NSLog(@"ImageReference:rotateIfNecessary: orientation: Up");
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            NSLog(@"ImageReference:rotateIfNecessary: orientation: Up Mirrored");
            break;

        case UIImageOrientationDown: //EXIF = 3
            NSLog(@"ImageReference:rotateIfNecessary: orientation: Down");
            angle = 180;
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            NSLog(@"ImageReference:rotateIfNecessary: orientation: Down Mirrored");
            angle = 180;
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            NSLog(@"ImageReference:rotateIfNecessary: orientation: Left Mirrored");
            angle = 270;
            break;

        case UIImageOrientationLeft: //EXIF = 6
            NSLog(@"ImageReference:rotateIfNecessary: orientation: Left");
            angle = 270;
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            NSLog(@"ImageReference:rotateIfNecessary: orientation: Right Mirrored");
            angle = 90;
            break;

        case UIImageOrientationRight: //EXIF = 8
            NSLog(@"ImageReference:rotateIfNecessary: orientation: Right");
            angle = 90;
            break;

        default:
            NSLog(@"ImageReference:rotateIfNecessary: Invalid image orientation");

    }
    
    if (angle != 0)
    {
    	MagickBooleanType magickStatus = MagickRotateImage (magickWand, NewPixelWand(), angle);

    	if (magickStatus != MagickFalse)
    	{
        }
        else
        {
            NSLog(@"MagickRotateImage failed for angle %f", angle);
        }
    }
}


+ (BOOL)scaleImage:(MagickWand*)magickWand
{
    CGFloat width = MagickGetImageWidth(magickWand);
    CGFloat height = MagickGetImageHeight(magickWand);
    CGFloat targetWidth = MAX_WIDTH;
    CGFloat targetHeight = MAX_HEIGHT;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth;
    CGFloat scaledHeight;
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
    BOOL status = NO;
    
    if (width <= MAX_WIDTH && height <= MAX_HEIGHT)
        return YES;

    if (widthFactor < heightFactor)
    {
        NSLog(@"ImageReference:scaleImage scale to fit height");
        scaleFactor = widthFactor; // scale to fit height
    }
    else
    {
        NSLog(@"ImageReference:scaleImage scale to fit width");
        scaleFactor = heightFactor; // scale to fit width
    }

    scaledWidth  = width * scaleFactor;
    scaledHeight = height * scaleFactor;
    
    NSLog(@"ImageReference:scaleImage: width=%f, height=%f, scaledWidth=%f, scaledHeight=%f",
          width, height, floor(scaledWidth), floor(scaledHeight));

	if (magickWand)
	{
    	MagickBooleanType magickStatus = MagickScaleImage (magickWand, floor(scaledWidth), floor(scaledHeight));

    	if (magickStatus != MagickFalse)
    	{
            status = YES;
        }
        else
        {
            NSLog(@"ImageReference:scaleImage: MagickScaleImage failed");
    		ThrowWandException(magickWand);
    	}
    }
    else
    {
        NSLog(@"ImageReference:scaleImage: bad sourceImage");
    }
    
    return status;
}


@end
    