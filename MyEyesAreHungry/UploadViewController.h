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
@class ASIFormDataRequest;

@interface UploadViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate> {

    NSMutableArray *cellText;
    UIImage *image;
    NSData *imageData;
    UploadArrays *arrays;
    UIView *pickerView;
    NSInteger currPickerTextFieldTag;
    NSArray *currPickerArray;
    NSMutableArray *followsNames;
    NSMutableArray *followsIds;
    BOOL isUsa;
    UserImage *userImage;
    TextImageButton *uploadButton;
    
    ASIFormDataRequest *request;
    UIAlertView *uploadCancelAlert;
    UIActivityIndicatorView *uploadCancelSpinner;
    
    UIAlertView *uploadDoneAlert;
    UIAlertView *imageProcessFailAlert;
    UIAlertView *imageProcessAlert;
    UIActivityIndicatorView *imageProcessSpinner;
}

@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) UploadArrays *arrays;
@property (retain, nonatomic) UIView *pickerView;
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
