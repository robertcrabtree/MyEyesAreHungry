//
//  UploadViewController.h
//  MyEyesAreHungry
//
//  Created by bobby on 7/28/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UploadArrays;

@interface UploadViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {

    NSMutableArray *cellText;
    UIImage *image;
    UploadArrays *arrays;
    UIPickerView *picker;
    NSInteger currPickerTextFieldTag;
    NSArray *currPickerArray;
}

@property (retain, nonatomic) UIImage *image;

@end
