//
//  RootViewController.h
//  MyEyesAreHungry
//
//  Created by Jason Adams on 7/20/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserPass;
@class TextImageButton;

enum LoginAction {
    LOGIN_NO_ACTION,
    LOGIN_SHOW_MY_MEALS,
    LOGIN_SHOW_MY_RESTAURANTS,
    LOGIN_SHOW_MY_FAVS,
    LOGIN_SHOW_MY_FOLLOWS,
    LOGIN_ADD_DISH
};

@interface RootViewController : UITableViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    enum LoginAction loginAction;
    NSInteger loginRow;
    UserPass *userPass;
    TextImageButton *addButton;
}

- (void) processMyStuff:(NSInteger)row;
- (void) processRecents:(NSInteger)row;
- (void) processAddDish;

@property (nonatomic) enum LoginAction loginAction;

@end
