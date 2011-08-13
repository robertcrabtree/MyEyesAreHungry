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

@implementation UploadViewController

@synthesize image;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    if (self.image) {
        [image release];
        image = nil;
    }
    if (arrays) {
        [arrays release];
        arrays = nil;
    }
    if (picker) {
        [picker release];
        picker = nil;
    }
    if (cellText) {
        [cellText release];
        cellText = nil;
    }
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
    self.tableView.tag = 100;
    arrays = [[UploadArrays alloc] init];
    cellText = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", nil];
}

- (void)viewDidUnload
{
    
    /// @todo find out what should be released in viewDidUnload for all views
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
    if (self.image) {
        [image release];
        image = nil;
    }
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
    if (section == 0)
        return arrays.restPlaceholders.count;
    else if (section == 1)
        return arrays.mealPlaceholders.count;
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
        textCell.tag = indexPath.row;
        textCell.textField.placeholder = [arrays.restPlaceholders objectAtIndex:indexPath.row];
        textCell.textField.delegate = self;
        textCell.textField.returnKeyType = UIReturnKeyNext;
        textCell.textField.keyboardType = UIKeyboardTypeDefault;
        textCell.textField.text = [cellText objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        TextCell *textCell = (TextCell *) cell;
        textCell.tag = indexPath.row + arrays.restPlaceholders.count;
        textCell.textField.placeholder = [arrays.mealPlaceholders objectAtIndex:indexPath.row];
        textCell.textField.delegate = self;
        textCell.textField.text = [cellText objectAtIndex:indexPath.row + arrays.restPlaceholders.count];
        if (indexPath.row == arrays.mealPlaceholders.count - 1) {
            textCell.textField.returnKeyType = UIReturnKeyDone;
            textCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        } else {
            textCell.textField.returnKeyType = UIReturnKeyNext;
            textCell.textField.keyboardType = UIKeyboardTypeDefault;
        }
    } else {
        cell.tag = arrays.restPlaceholders.count + arrays.mealPlaceholders.count;
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

-(BOOL)isValidData:(UIView *)cellParent
{
    int cnt = arrays.restPlaceholders.count + arrays.mealPlaceholders.count;
    
    for (int i = 0; i < cnt; i++) {
        UITextField *textField = ((TextCell *)[cellParent viewWithTag:i]).textField;
        if (textField.text == nil || [@"" isEqualToString:textField.text]) {
            return NO;
        }
    }

    return YES;
}

-(void)getPostStrings:(UIView *)cellParent row:(NSInteger)row key:(NSString **)key val:(NSString **)val
{
    NSArray *textArray;
    NSArray *valArray;
    NSString *text = ((TextCell *) [cellParent viewWithTag:row]).textField.text;
    
    *key = [arrays.postKeys objectAtIndex:row];
    
    switch (row) {

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

-(BOOL)upload:(UIView *)cellParent
{
    
    /// @todo resize the image
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSURL *url = [NSURL URLWithString:@"http://www.myeyesarehungry.com/upload.php"];
    ASIFormDataRequest *request = [[ASIFormDataRequest  alloc]  initWithURL:url];
    BOOL success = YES;
    int cnt = arrays.postKeys.count;
    NSString *key;
    NSString *val;

    // get all the data from the text fields and stuff in HTML POST request
    for (int i = 0; i < cnt; i++) {
        [self getPostStrings:cellParent row:i key:&key val:&val];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        TextCell *cell = (TextCell *) [tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    } else {
        UIView *cellParent = [tableView cellForRowAtIndexPath:indexPath].superview;
        
        /// @todo make sure to disable buttons while logging in

        if ([self isValidData:cellParent]) {
            if ([self upload:cellParent]) {
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
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All fields required"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    TextCell *cell= (TextCell *) textField.superview.superview;
    [cellText replaceObjectAtIndex:cell.tag withObject:textField.text];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    TextCell *cell= (TextCell *) textField.superview.superview;
    TextCell *next = (TextCell *) [cell.superview viewWithTag:cell.tag + 1];

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
    
    switch (cell.tag) {
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

    if (picker)
        [picker release];
    picker = [[UIPickerView alloc] initWithFrame:self.view.bounds];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    picker.dataSource = self;
    [picker selectRow:row inComponent:0 animated:NO];
    textField.text = [array objectAtIndex:row];
    textField.inputView = picker;
    
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
    UITextField *textField = ((TextCell *) [self.view viewWithTag:currPickerTextFieldTag]).textField;
    textField.text = [currPickerArray objectAtIndex:row];
}

@end
