//
//  TextCell.m
//  MyEyesAreHungry
//
//  Created by bobby on 7/30/11.
//  Copyright 2011 self. All rights reserved.
//

#import "TextCell.h"


@implementation TextCell

@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [textField release];
    [super dealloc];
}

+ (TextCell *) cellFromNib
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TextCell" owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    TextCell *cell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[TextCell class]]) {
            cell = (TextCell *)nibItem;
            break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField = [[UITextField alloc] initWithFrame:CGRectZero];
    cell.textField.clearsOnBeginEditing = NO;
    cell.textField.returnKeyType = UIReturnKeyDone;
    cell.textField.placeholder = @"enter text...";
    //cell.textField.backgroundColor = [UIColor orangeColor]; // for debugging size
    [cell.contentView addSubview:cell.textField];

    return cell;
}


- (void)layoutSubviews
{
    [textField setFrame:CGRectInset(self.contentView.bounds, 11.0, 10.0)];
}

@end
