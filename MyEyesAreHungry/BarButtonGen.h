//
//  BarButtonGen.h
//  MyEyesAreHungry
//
//  Created by bobby on 8/24/11.
//  Copyright 2011 self. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BarButtonGen : NSObject {
    UIButton *button;
}
-(UIBarButtonItem *)generateWithImage:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action;
-(void)setTitle:(NSString *)title;
@end
