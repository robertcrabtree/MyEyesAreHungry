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
    IBOutlet UITextField *textField; /// @todo make sure all IBOutlet members get released in dealloc
}

@property (nonatomic, retain) IBOutlet UITextField *textField;

+ (TextCell *) cellFromNib;

@end
