//
//  UploadViewController.h
//  MyEyesAreHungry
//
//  Created by bobby on 7/28/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEST_UPLOAD 1  /// @todo remove


@interface UploadViewController : UITableViewController {
    UIImage *image;
    NSArray *restaurantArray;
    NSArray *mealArray;
    UIAlertView *progressAlert;
    UIProgressView *progressView;
#ifdef TEST_UPLOAD
    int cnt;
    float fcnt;
    NSTimer *timer;
#endif
}

#ifdef TEST_UPLOAD

@property (retain, nonatomic) NSTimer *timer;

- (void)timerFired:(NSTimer*)theTimer;
#endif

@property (retain, nonatomic) UIImage *image;

@end
