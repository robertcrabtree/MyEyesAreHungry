//
//  UploadViewController.h
//  MyEyesAreHungry
//
//  Created by bobby on 7/28/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UITableViewController <UITextFieldDelegate> {
    UIImage *image;
    NSArray *postVarArray;
    NSArray *restaurantArray;
    NSArray *mealArray;
    UIAlertView *progressAlert;
    UIProgressView *progressView;
    
#ifdef MEAH_TESTING
    NSArray *cheatArray;
#endif
}

@property (retain, nonatomic) UIImage *image;

@end
