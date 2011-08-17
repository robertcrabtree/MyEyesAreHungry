//
//  TextCell.m
//  MyEyesAreHungry
//
//  Created by bobby on 7/30/11.
//  Copyright 2011 self. All rights reserved.
//

#import "TextCell.h"

@interface RestrictedTextField : UITextField {
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender;
-(CGRect)textRectForBounds:(CGRect)bounds;
-(CGRect)editingRectForBounds:(CGRect)bounds;
@end
    

@implementation RestrictedTextField

-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 8, bounds.origin.y,
                      bounds.size.width - 16, bounds.size.height);
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.inputView == nil) {
        return [super canPerformAction:action withSender:sender];
    }
    
    if ([UIMenuController sharedMenuController]) {
        // disable cut/copy/paste for textfields with UIPickerView as input
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end



// text cell implementation
@implementation TextCell

@synthesize textField;

NSString *TextCellID = @"TextCell";

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
    self.textField = nil;
    [super dealloc];
}

+ (TextCell *) cellFromNib
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:TextCellID owner:self options:NULL];
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
    cell.textField = [[RestrictedTextField alloc] initWithFrame:CGRectZero];
    cell.textField.clearsOnBeginEditing = NO;
    cell.textField.returnKeyType = UIReturnKeyDone;
    cell.textField.placeholder = @"enter text...";
    //cell.textField.backgroundColor = [UIColor orangeColor]; // for debugging size
    [cell.contentView addSubview:cell.textField];

    [cell.textField release];
    
    return cell;
}


- (void)layoutSubviews
{
    [textField setFrame:CGRectInset(self.contentView.bounds, 11.0, 10.0)];
}

@end
