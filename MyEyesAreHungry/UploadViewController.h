//
//  UploadViewController.h
//  MyEyesAreHungry
//
//  Created by bobby on 7/28/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UploadArrays;
@class TextCell;
@class UserImage;
@class TextImageButton;

@interface UploadViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {

    NSMutableArray *cellText;
    UIImage *image;
    UploadArrays *arrays;
    UIPickerView *picker;
    NSInteger currPickerTextFieldTag;
    NSArray *currPickerArray;
    NSMutableArray *followsNames;
    NSMutableArray *followsIds;
    BOOL isUsa;
    UserImage *userImage;
    TextImageButton *uploadButton;
}

@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) UploadArrays *arrays;
@property (retain, nonatomic) UIPickerView *picker;
@property (retain, nonatomic) NSMutableArray *cellText;

-(TextCell *) cellWithTag:(NSInteger)tag;
-(TextCell *) cellInSection:(NSInteger)section AndRow:(NSInteger)row;
-(BOOL)isValidData;
-(void)getPostStrings:(NSInteger)row key:(NSString **)key val:(NSString **)val;
-(BOOL)upload;
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;


@end
