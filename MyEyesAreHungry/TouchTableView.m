//
//  TouchTableView.m
//  MyEyesAreHungry
//
//  Created by bobby on 8/21/11.
//  Copyright 2011 self. All rights reserved.
//

#import "TouchTableView.h"


@implementation TouchTableView

- (BOOL)findAndResignFirstResonder:(UIView*)view
{
    if (view.isFirstResponder) {
        [view resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in view.subviews) {
        if ([self findAndResignFirstResonder: subView])
            return YES;
    }
    return NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self findAndResignFirstResonder:self];
}

@end
