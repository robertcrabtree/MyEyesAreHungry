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
    MagickWand *magickWand;
}

// user must make a copy of the data if data will be ImageReference obj
// will be destroyed before data is used
-(void *)getBytes:(NSInteger *)dataLen;

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
