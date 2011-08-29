//
//  BarButtonGen.m
//  MyEyesAreHungry
//
//  Created by bobby on 8/24/11.
//  Copyright 2011 self. All rights reserved.
//

#import "BarButtonGen.h"


@implementation BarButtonGen

-(UIBarButtonItem *)generateWithImage:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action
{
    UIImage *image = [UIImage imageNamed:imageName];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 70, 35)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    [buttonView addSubview:button];
    //        buttonView.backgroundColor = [UIColor blueColor];
    
    UIBarButtonItem* barButton = [[[UIBarButtonItem alloc] initWithCustomView:buttonView] autorelease];
    
    [buttonView release];
    
    return barButton;
}

-(void)setTitle:(NSString *)title
{
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)dealloc {
    [super dealloc];
}

@end
