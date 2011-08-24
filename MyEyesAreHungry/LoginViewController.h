//
//  LoginViewController.h
//  MyEyesAreHungry
//
//  Created by bobby on 7/30/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextImageButton;

@interface LoginViewController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate> {
    TextImageButton* loginButton;
}

@end
