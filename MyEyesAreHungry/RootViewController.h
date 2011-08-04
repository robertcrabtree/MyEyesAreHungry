//
//  RootViewController.h
//  MyEyesAreHungry
//
//  Created by Jason Adams on 7/20/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserPass;

@interface RootViewController : UITableViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
}

- (void)takePicture;
- (void)chooseFromLibrary;

@end
