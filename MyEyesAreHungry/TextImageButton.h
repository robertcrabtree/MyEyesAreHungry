//
//  TextImageButton.h
//  TextImageButton
//
//  Created by bobby on 8/23/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TextImageButton : NSObject {
    UIView *view;
    UIButton *button;
}

@property (nonatomic, retain) UIView *view;
- (id)init;
- (void)setText:(NSString *)text;
- (void)setOrigin:(float)x y:(float)y;
- (void) addTarget:(id)target action:(SEL)action;

@end
