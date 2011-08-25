//
//  NavDeli.m
//  MyEyesAreHungry
//
//  Created by bobby on 8/24/11.
//  Copyright 2011 self. All rights reserved.
//

#import "NavDeli.h"
#import "BarButtonGen.h"

@implementation NavDeli

static NavDeli *sharedInstance = nil;

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    int count = [navigationController.viewControllers count];
    
    if (count > 1) {
        NSString *title = ((UIViewController *) [navigationController.viewControllers objectAtIndex:count - 2]).navigationItem.title;
        
        if (title == nil || [title isEqualToString:@""])
            title = @"Back";
        
        BarButtonGen *gen = [[BarButtonGen alloc] init];
        
        UIBarButtonItem *barButton = [gen generateWithImage:@"nav_back" title:title
                                                     target:viewController.navigationController
                                                     action:@selector(popViewControllerAnimated:)];
        viewController.navigationItem.leftBarButtonItem = barButton;
        
        [gen release];
    }
}

+ (NavDeli *)sharedNavDeli
{
    @synchronized (self) {
        if (sharedInstance == nil) {
            [[self alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}


- (id)init
{
    @synchronized(self) {
        if (!(self = [super init])) {
            return nil;
        }
        return self;
    }
}

- (void)release
{
    // do nothing
}

@end
