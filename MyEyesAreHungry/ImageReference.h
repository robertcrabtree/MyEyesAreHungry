//
//  ImageReference.h
//  Inspect
//
//  Created by jason adams on 2/23/10.
//  Copyright 2010 Outrider Software Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MagickWand.h"


@interface ImageReference : NSObject {
    UIImage *image;
    NSData *imageData;
    MagickWand *magickWand;
}

@property (nonatomic, retain) NSData *imageData;

// init function
- (id)initWithNewImage:(UIImage*)newImage;

// worker function....
//   rotateIfNecessary
//     rotate image
//   imageWithImage
//     scale image
- (BOOL)processImage;

// rotates image
- (void)rotateIfNecessary:(UIImageOrientation)orient;

// scale image
+ (BOOL)scaleImage:(MagickWand*)magickWand;

@end
