//
//  MyEyesAreHungryAppDelegate.h
//  MyEyesAreHungry
//
//  Created by Jason Adams on 7/20/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyEyesAreHungryAppDelegate : NSObject <UIApplicationDelegate> {
    UIImage *navImage;
}

@property (nonatomic, retain) UIImage *navImage;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
