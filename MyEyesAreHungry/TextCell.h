//
//  TextCell.h
//  MyEyesAreHungry
//
//  Created by bobby on 7/30/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *TextCellID;

@interface TextCell : UITableViewCell {
    UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

+ (TextCell *) cellFromNib;

@end
