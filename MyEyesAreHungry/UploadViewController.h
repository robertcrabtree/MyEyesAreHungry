//
//  UploadViewController.h
//  MyEyesAreHungry
//
//  Created by bobby on 7/28/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEST_MEAH 1

@interface UploadViewController : UITableViewController <UITextFieldDelegate> {
    UIImage *image;
    NSArray *postVarArray;
    NSArray *restaurantArray;
    NSArray *mealArray;
    UIAlertView *progressAlert;
    UIProgressView *progressView;
    
#ifdef TEST_MEAH
    NSArray *cheatArray;
#endif
}

@property (retain, nonatomic) UIImage *image;

@end
