//
//  UploadViewController.h
//  MyEyesAreHungry
//
//  Created by bobby on 7/28/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UploadArrays;
@class ActionSheetPicker;

@interface UploadViewController : UITableViewController <UITextFieldDelegate> {
    UIImage *image;
    UploadArrays *arrays;
    ActionSheetPicker *picker;
}

@property (retain, nonatomic) UIImage *image;

@end
