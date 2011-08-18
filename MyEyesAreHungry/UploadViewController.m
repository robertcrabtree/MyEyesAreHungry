//
//  UploadViewController.m
//  MyEyesAreHungry
//
//  Created by bobby on 7/28/11.
//  Copyright 2011 self. All rights reserved.
//

#import "UploadViewController.h"
#import "TextCell.h"
#import "MyEyesAreHungryAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "UploadArrays.h"

#define INDEX_TO_TAG(x) ((x) + 1000)
#define TAG_TO_INDEX(x) ((x) - 1000)

@implementation UploadViewController

@synthesize cellText;
@synthesize image;
@synthesize arrays;
@synthesize picker;

NSInteger numRestFields = 4;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    self.image = nil;
    self.arrays = nil;
    self.picker = nil;
    self.cellText = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{    
    [super viewDidLoad];
    self.arrays = [[UploadArrays alloc] init];
    self.cellText = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", nil];
    [self.arrays release];
    [self.cellText release];
}

- (void)viewDidUnload
{
    
    // Release any retained subviews of the main view.
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Upload";
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0 || section == 1)
        return numRestFields;
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        case 1:
            cell.backgroundColor = [UIColor whiteColor];
            break;
            
        default:
            cell.backgroundColor = [UIColor brownColor];
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    
    // see if cell already exists
    if (indexPath.section == 0 || indexPath.section == 1)
        cell = [tableView dequeueReusableCellWithIdentifier:TextCellID];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // create cell
    if (cell == nil) {
        if (indexPath.section == 0 || indexPath.section == 1)
            cell = [TextCell cellFromNib];
        else
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // configure cell
    if (indexPath.section == 0) {
        TextCell *textCell = (TextCell *) cell;
        textCell.tag = INDEX_TO_TAG(indexPath.row);
        textCell.textField.placeholder = [arrays.placeholders objectAtIndex:indexPath.row];
        textCell.textField.delegate = self;
        textCell.textField.returnKeyType = UIReturnKeyNext;
        textCell.textField.keyboardType = UIKeyboardTypeDefault;
        textCell.textField.text = [cellText objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        TextCell *textCell = (TextCell *) cell;
        textCell.tag = INDEX_TO_TAG(indexPath.row + numRestFields);
        textCell.textField.placeholder = [arrays.placeholders objectAtIndex:indexPath.row + numRestFields];
        textCell.textField.delegate = self;
        textCell.textField.text = [cellText objectAtIndex:indexPath.row + numRestFields];
        if (indexPath.row == arrays.placeholders.count - 1) {
            textCell.textField.returnKeyType = UIReturnKeyDone;
            textCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        } else {
            textCell.textField.returnKeyType = UIReturnKeyNext;
            textCell.textField.keyboardType = UIKeyboardTypeDefault;
        }
    } else {
        cell.tag = INDEX_TO_TAG(arrays.placeholders.count);
        cell.textLabel.text = @"Upload";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

-(BOOL)isValidData
{
    int cnt = arrays.placeholders.count;

    // make sure _all_ text fields are filled in
    for (int i = 0; i < cnt; i++) {
        UITextField *textField = [self cellWithTag:INDEX_TO_TAG(i)].textField;
        if (textField.text == nil || [@"" isEqualToString:textField.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All fields required"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            return NO;
        }
    }
    
    // validate restaurant name
    {
        NSString *restName = [self cellWithTag:INDEX_TO_TAG(0)].textField.text;
        NSString *chars = @"abcdefghijklmnopqrstuvwxyz1234567890_ -";
        NSRange range = {0, 1};
        NSRange charsRange = {0, 1};
        
        int matched = 0;
        for (int i = 0; i < restName.length; i++) {
            range.location = i;
            NSString *restNameChar = [[restName substringWithRange:range] lowercaseString];
            for (int j = 0; j < chars.length; j++) {
                charsRange.location = j;
                NSString *charsChar = [chars substringWithRange:charsRange];
                if ([charsChar isEqualToString:restNameChar]) {
                    matched++;
                }
            }
        }
        
        if (restName.length != matched) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid restaurant name"
                                                            message:@"Can only contain chars A-Z, a-z, 0-9, space, -, and _"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            
            return NO;
        }
    }
    
    // validate restaurant city
    {
        NSString *restCity = [self cellWithTag:INDEX_TO_TAG(2)].textField.text;
        NSString *chars = @"abcdefghijklmnopqrstuvwxyz -";
        NSRange range = {0, 1};
        NSRange charsRange = {0, 1};

        int matched = 0;
        for (int i = 0; i < restCity.length; i++) {
            range.location = i;
            NSString *restCityChar = [[restCity substringWithRange:range] lowercaseString];
            for (int j = 0; j < chars.length; j++) {
                charsRange.location = j;
                NSString *charsChar = [chars substringWithRange:charsRange];
                if ([charsChar isEqualToString:restCityChar]) {
                    matched++;
                }
            }
        }
        
        if (restCity.length != matched || restCity.length < 2) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid city"
                                                            message:@"Must be at least 2 characters and can only contain characters A-Z, a-z, space, and -"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            
            return NO;
        }
    }
    
    // validate meal name
    {
        NSString *mealName = [self cellWithTag:INDEX_TO_TAG(5)].textField.text;
        NSString *chars = @"abcdefghijklmnopqrstuvwxyz1234567890_ ,-";
        NSRange range = {0, 1};
        NSRange charsRange = {0, 1};
        
        int matched = 0;
        for (int i = 0; i < mealName.length; i++) {
            range.location = i;
            NSString *mealChar = [[mealName substringWithRange:range] lowercaseString];
            for (int j = 0; j < chars.length; j++) {
                charsRange.location = j;
                NSString *charsChar = [chars substringWithRange:charsRange];
                if ([charsChar isEqualToString:mealChar]) {
                    matched++;
                }
            }
        }

        if (mealName.length != matched || mealName.length < 3) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid meal name"
                                                            message:@"Must be at least 2 characters and can only contain characters A-Z, a-z, 0-9, space, -, _, and comma"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            
            return NO;
        }
    }

    /// @todo validate friends. max 4 friends
    
    return YES;
}

-(void)getPostStrings:(NSInteger)index key:(NSString **)key val:(NSString **)val
{
    NSArray *textArray;
    NSArray *valArray;
    NSString *text = [self cellWithTag:INDEX_TO_TAG(index)].textField.text;
    
    *key = [arrays.postKeys objectAtIndex:index];
    
    switch (index) {

            // picker filled textfields
        case 1:
            textArray = arrays.countryText;
            valArray = arrays.countryVals;
            break;
        case 3:
            textArray = arrays.stateText;
            valArray = arrays.stateVals;
            break;
        case 4:
            textArray = arrays.mealTypeText;
            valArray = arrays.mealTypeVals;
            break;
        case 6:
            textArray = arrays.mealPriceText;
            valArray = arrays.mealPriceVals;
            break;
        case 7:
            textArray = arrays.mealTasteText;
            valArray = arrays.mealTasteVals;
            break;
            
            // keyboard filled textfields
        default:
            *val = text;
            return;
    }
    
    for (int i = 0; i < textArray.count; i++) {
        if ([text isEqualToString:[textArray objectAtIndex:i]]) {
            *val = [valArray objectAtIndex:i];
            break;
        }
    }
}

-(BOOL)upload
{
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 1468006; // 1.4 MB
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while (imageData.length > maxFileSize && compression > maxCompression) {
        compression -= 0.1f;
        imageData = UIImageJPEGRepresentation(image, compression);
    }

    NSURL *url = [NSURL URLWithString:@"http://www.myeyesarehungry.com/api/upload.php"];
    ASIFormDataRequest *request = [[ASIFormDataRequest  alloc]  initWithURL:url];
    BOOL success = YES;
    int cnt = arrays.postKeys.count;
    NSString *key;
    NSString *val;

    // get all the data from the text fields and stuff in HTML POST request
    for (int i = 0; i < cnt; i++) {
        [self getPostStrings:i key:&key val:&val];
        [request setPostValue:val forKey:key];
    }
    
    // set misc post keys required on the server end
    [request setPostValue:@"submit" forKey:@"submit"];
    [request setPostValue:@"user_friends" forKey:@"user_friends"];
    [request setPostValue:@"agree" forKey:@"tos"];
    
    // post the image data
    [request addData:imageData withFileName:@"meal.jpeg" andContentType:@"image/jpeg" forKey:@"image"];
    [request startSynchronous];
    
    [request release];
    
    return success;

}

-(TextCell *) cellInSection:(NSInteger)section AndRow:(NSInteger)row
{
    NSInteger index = row;
    
    if (section > 0)
        index += numRestFields;

    return [self cellWithTag:INDEX_TO_TAG(index)];
}

-(TextCell *) cellWithTag:(NSInteger)tag
{
    TextCell *cell = (TextCell *) [self.tableView viewWithTag:tag];
    
    if (!cell) {
        int row = TAG_TO_INDEX(tag);
        int section = 0;
        if (row > numRestFields) {
            row -= numRestFields;
            section = 1;
        }
        cell = (TextCell *) [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        TextCell *cell = [self cellInSection:indexPath.section AndRow:indexPath.row];
        [cell.textField becomeFirstResponder];
    } else {
       
        /// @todo make sure to disable buttons while logging in

        if ([self isValidData]) {
            if ([self upload]) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload failed"
                                                                message:@""
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
                [alert release];
            }
            
        }
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    TextCell *cell= (TextCell *) textField.superview.superview;
    [cellText replaceObjectAtIndex:TAG_TO_INDEX(cell.tag) withObject:textField.text];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    TextCell *cell= (TextCell *) textField.superview.superview;
    TextCell *next = (TextCell *) [self cellWithTag:cell.tag + 1];

    if (next && [next isKindOfClass:[TextCell class]]) {
        [textField resignFirstResponder];
        [next.textField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    TextCell *cell = (TextCell *) textField.superview.superview;
    NSArray *array;
    int row;
    
    switch (TAG_TO_INDEX(cell.tag)) {
        case 0:
        case 2:
        case 5:
            cell.textField.inputView = nil;
            return YES;
        case 1:
            array = arrays.countryText;
            break;
        case 3:
            array = arrays.stateText;
            break;
        case 4:
            array = arrays.mealTypeText;
            break;
        case 6:
            array = arrays.mealPriceText;
            break;
        case 7:
            array = arrays.mealTasteText;
            break;
    }

    row = 0;
    
    for (int i = 1; i < array.count; i++) {
        if ([textField.text isEqualToString:[array objectAtIndex:i]]) {
            row = i;
            break;
        }
    }

    currPickerArray = array;
    currPickerTextFieldTag = cell.tag;

    self.picker = [[UIPickerView alloc] initWithFrame:self.tableView.bounds];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    picker.dataSource = self;
    [picker selectRow:row inComponent:0 animated:NO];
    textField.text = [array objectAtIndex:row];
    textField.inputView = picker;
    
    [picker release];
    
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (currPickerArray)
        return currPickerArray.count;
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return (NSString *) [currPickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    TextCell* cell = [self cellWithTag:currPickerTextFieldTag];
    cell.textField.text = [currPickerArray objectAtIndex:row];
}

@end
