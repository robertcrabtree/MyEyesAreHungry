//
//  TextImageButton.m
//  TextImageButton
//
//  Created by bobby on 8/23/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "TextImageButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextImageButton

- (id)init
{
    if ((self = [super init]))
    {
        UIImage *image = [UIImage imageNamed:@"button"];
        
        float buttonWidth = image.size.width;
        float buttonHeight = image.size.height;
        CGRect buttonFrame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonFrame;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];

        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
//        view.backgroundColor = [UIColor greenColor];

        [view addSubview:button];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    [button setTitle:text forState:UIControlStateNormal];
}

- (UIView *) getButtonView
{
    return [view autorelease];
}

- (void) setOrigin:(float)x y:(float)y
{
    button.frame = CGRectMake(x, y, button.frame.size.width, button.frame.size.height);
    view.frame = CGRectMake(0, 0, button.frame.size.width, button.frame.size.height + y * 2);
}

- (void)addTarget:(id)target action:(SEL)action
{
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)dealloc
{
    [view release];
    [super dealloc];
}

@end
