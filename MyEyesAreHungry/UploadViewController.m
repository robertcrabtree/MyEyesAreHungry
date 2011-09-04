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
#import "FollowsViewController.h"
#import "User.h"
#import "UserImage.h"
#import "TextImageButton.h"
#import "Reachability.h"

#define INDEX_TO_TAG(x) ((x) + 1000)
#define TAG_TO_INDEX(x) ((x) - 1000)

#define CELL_INDEX_REST_NAME        0
#define CELL_INDEX_REST_COUNTRY     1
#define CELL_INDEX_REST_CITY        2
#define CELL_INDEX_REST_STATE       3
#define CELL_INDEX_MEAL_TYPE        4
#define CELL_INDEX_MEAL_NAME        5
#define CELL_INDEX_MEAL_PRICE       6
#define CELL_INDEX_MEAL_TASTE       7

#define CELL_SECTION_REST           0
#define CELL_SECTION_MEAL           1
#define CELL_SECTION_FOLLOWS        2

#define NUM_REST_FIELDS             4
#define NUM_MEAL_FIELDS             4

@implementation UploadViewController

@synthesize cellText;
@synthesize imageData;
@synthesize arrays;
@synthesize pickerView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [followsNames release];
    [followsIds release];
    [userImage release];
    [uploadButton release];

    self.imageData = nil;
    self.arrays = nil;
    self.pickerView = nil;
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
    UIView *buttonView;
    uploadButton = [[TextImageButton alloc] init];
    [uploadButton setText:@"Upload"];
    buttonView = uploadButton.view;
    [uploadButton setOrigin:(320 - buttonView.frame.size.width) / 2 y:20];
    [uploadButton addTarget:self action:@selector(uploadHandler:)];
    self.tableView.tableFooterView = buttonView;

    userImage = [[UserImage alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [userImage loadUserImage:self];

    isUsa = YES;
    self.arrays = [[UploadArrays alloc] init];
    self.cellText = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", nil];
    [self.arrays release];
    [self.cellText release];
    followsNames = [[NSMutableArray alloc] init];
    followsIds = [[NSMutableArray alloc] init];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    
    // Release any retained subviews of the main view.
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Upload";
    
    UITableViewCell *cell = (UITableViewCell *) [self.tableView viewWithTag:INDEX_TO_TAG(arrays.placeholders.count)];

    if (followsNames.count == 0)
        cell.detailTextLabel.text = @"None";
    else
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d selected", followsNames.count];

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
    switch (section) {
        case 0:
            if (isUsa)
                return NUM_REST_FIELDS;
            return NUM_REST_FIELDS - 1; // state has been removed
        case 1:
            return NUM_MEAL_FIELDS;
        default:
            return 1;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FollowsCellID = @"FollowsCellID";
    
    UITableViewCell *cell;
    
    // see if cell already exists
    if (indexPath.section == 0 || indexPath.section == 1)
        cell = [tableView dequeueReusableCellWithIdentifier:TextCellID];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:FollowsCellID];
    
    // create cell
    if (cell == nil) {
        if (indexPath.section == 0 || indexPath.section == 1)
            cell = [TextCell cellFromNib];
        else if (indexPath.section == 2)
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FollowsCellID] autorelease];
    }
    
    // configure cell
    if (indexPath.section == CELL_SECTION_REST) {
        TextCell *textCell = (TextCell *) cell;
        textCell.tag = INDEX_TO_TAG(indexPath.row);
        textCell.textField.placeholder = [arrays.placeholders objectAtIndex:indexPath.row];
        textCell.textField.delegate = self;
        textCell.textField.returnKeyType = UIReturnKeyNext;
        textCell.textField.keyboardType = UIKeyboardTypeDefault;
        textCell.textField.text = [cellText objectAtIndex:indexPath.row];
        [textCell.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        textCell.textField.tag = indexPath.row;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (indexPath.section == 1) {
        TextCell *textCell = (TextCell *) cell;
        textCell.tag = INDEX_TO_TAG(indexPath.row + NUM_REST_FIELDS);
        textCell.textField.placeholder = [arrays.placeholders objectAtIndex:indexPath.row + NUM_REST_FIELDS];
        textCell.textField.delegate = self;
        textCell.textField.text = [cellText objectAtIndex:indexPath.row + NUM_REST_FIELDS];
        if (indexPath.row == arrays.placeholders.count - 1) {
            textCell.textField.returnKeyType = UIReturnKeyDone;
            textCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        } else {
            textCell.textField.returnKeyType = UIReturnKeyNext;
            textCell.textField.keyboardType = UIKeyboardTypeDefault;
        }
        [textCell.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        textCell.textField.tag = indexPath.row + NUM_REST_FIELDS;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (indexPath.section == CELL_SECTION_FOLLOWS) {
        cell.tag = INDEX_TO_TAG(arrays.placeholders.count);
        if (followsNames.count == 0)
            cell.detailTextLabel.text = @"None";
        else
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d selected", followsNames.count];
        cell.textLabel.text = @"Eaten with";
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        if (isUsa == NO && i == CELL_INDEX_REST_STATE)
            continue;
        
        NSString *text = [cellText objectAtIndex:i];
        if ([@"" isEqualToString:text]) {
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
        NSString *restName = [cellText objectAtIndex:CELL_INDEX_REST_NAME];
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
        NSString *restCity = [cellText objectAtIndex:CELL_INDEX_REST_CITY];
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
        NSString *mealName = [cellText objectAtIndex:CELL_INDEX_MEAL_NAME];
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
    
    // validate currency
    {
        if (isUsa == NO) {
            NSString *currency = [cellText objectAtIndex:CELL_INDEX_MEAL_PRICE];
            for (int i = 0; i < arrays.mealPriceWorldText.count; i++) {
                if ([currency isEqualToString:[arrays.mealPriceWorldText objectAtIndex:i]]) {
                    if ([@"-" isEqualToString:[arrays.mealPriceWorldVals objectAtIndex:i]]) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid meal price"
                                                                        message:@"Select a valid meal price"
                                                                       delegate:nil
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"OK", nil];
                        [alert show];
                        [alert release];
                        
                        return NO;
                    }
                }
            }
        }
    }
    
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
        case CELL_INDEX_REST_COUNTRY:
            textArray = arrays.countryText;
            valArray = arrays.countryVals;
            break;
        case CELL_INDEX_REST_STATE:
            textArray = arrays.stateText;
            valArray = arrays.stateVals;
            break;
        case CELL_INDEX_MEAL_TYPE:
            textArray = arrays.mealTypeText;
            valArray = arrays.mealTypeVals;
            break;
        case CELL_INDEX_MEAL_PRICE:
            if (isUsa) {
                textArray = arrays.mealPriceUsaText;
                valArray = arrays.mealPriceUsaVals;
            } else {
                textArray = arrays.mealPriceWorldText;
                valArray = arrays.mealPriceWorldVals;
            }
            break;
        case CELL_INDEX_MEAL_TASTE:
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
    NSURL *url = [NSURL URLWithString:@"http://www.myeyesarehungry.com/api/upload.php"];
    request = [[ASIFormDataRequest  alloc]  initWithURL:url];
    [request setDelegate:self];
    BOOL success = YES;
    int cnt = arrays.postKeys.count;
    NSString *key;
    NSString *val;

    // get all the data from the text fields and stuff in HTML POST request
    for (int i = 0; i < cnt; i++) {
        if (isUsa == NO && i == CELL_INDEX_REST_STATE) {
            continue;
        }
        [self getPostStrings:i key:&key val:&val];
        [request setPostValue:val forKey:key];
    }
    
    // set friend post data
    if (followsIds.count > 0) {
        NSString *chosenFriends = [followsIds componentsJoinedByString:@","];
        [request setPostValue:chosenFriends forKey:@"chosen_friends"];
    }
    
    // set misc post keys required on the server end
    [request setPostValue:@"submit" forKey:@"submit"];
    [request setPostValue:@"agree" forKey:@"tos"];
    [request setPostValue:[User sharedUser].user forKey:@"my_name"];
    [request setPostValue:[User sharedUser].ident forKey:@"my_id"];
    
    // post the image data
    [request addData:imageData withFileName:@"meal.jpeg" andContentType:@"image/jpeg" forKey:@"image"];
    [request startAsynchronous];
    
    return success;

}

- (void)requestFinished:(ASIHTTPRequest *)requestObj
{
    self.tableView.userInteractionEnabled = YES;

    if (request) {
        [request release];
        request = nil;
    }
    
    if (uploadCancelAlert)
        [uploadCancelAlert dismissWithClickedButtonIndex:-1 animated:YES];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)requestObj
{
    self.tableView.userInteractionEnabled = YES;
    
    // if the user cancelled the upload we don't need to display an error
    //     or dismiss the alert view
    if (request && [request error].code != ASIRequestCancelledErrorType) {
        [uploadCancelAlert dismissWithClickedButtonIndex:-1 animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload failed"
                                                        message:@"Network error"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    
    if (request) {
        [request release];
        request = nil;
    }
}

-(TextCell *) cellInSection:(NSInteger)section AndRow:(NSInteger)row
{
    NSInteger index = row;
    
    if (section == CELL_SECTION_MEAL)
        index += NUM_REST_FIELDS;

    return [self cellWithTag:INDEX_TO_TAG(index)];
}

-(TextCell *) cellWithTag:(NSInteger)tag
{
    TextCell *cell = (TextCell *) [self.tableView viewWithTag:tag];
    
    if (!cell) {
        int row = TAG_TO_INDEX(tag);
        int section = CELL_SECTION_REST;
        if (row > NUM_REST_FIELDS) {
            row -= NUM_REST_FIELDS;
            section = CELL_SECTION_MEAL;
        }
        cell = (TextCell *) [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CELL_SECTION_REST || indexPath.section == CELL_SECTION_MEAL) {
        TextCell *cell = [self cellInSection:indexPath.section AndRow:indexPath.row];
        [cell.textField becomeFirstResponder];
    } else if (indexPath.section == CELL_SECTION_FOLLOWS) {
        
        // remove the blue color
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        
        FollowsViewController *followsViewController = [[FollowsViewController alloc] initWithNibName:@"FollowsViewController" bundle:nil];
        followsViewController.followsNames = followsNames;
        followsViewController.followsIds = followsIds;
        [self.navigationController pushViewController:followsViewController animated:YES];
        [followsViewController release];
    }
}

-(UIView *)createPickerView:(NSInteger)pickerRow cellIndex:(NSInteger)cellIndex array:(NSArray *)array
{
	CGRect pickerFrame = CGRectMake(0, 40, self.tableView.frame.size.width, 216);
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
	picker.delegate = self;
	picker.dataSource = self;
	picker.showsSelectionIndicator = YES;
    [picker selectRow:pickerRow inComponent:0 animated:NO];
    
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 260)];
    [view addSubview:picker];
    view.backgroundColor = [UIColor redColor];
    [picker release];
	
	CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44);
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:frame];
    toolbar.barStyle = UIBarStyleBlack;
    
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
    // flex space
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	[barItems addObject:flexSpace];
    [flexSpace release];
	
    NSString *title = (cellIndex == CELL_INDEX_MEAL_TASTE) ? @"Done" : @"Next";
    
    // next/done button
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(pickerDone:)];
	[barItems addObject:barButton];
	[barButton release];
	
	[toolbar setItems:barItems animated:YES];
	[barItems release];
	
	[view addSubview:toolbar];
	[toolbar release];
    view.frame = CGRectMake(0, 200, picker.frame.size.width, picker.frame.size.height);
    
    self.pickerView = view;
    [view release];
    
    return view;
}

- (void)pickerDone:(id)sender
{
    TextCell *cell = (TextCell *) [self cellWithTag:currPickerTextFieldTag];
    [self textFieldShouldReturn:cell.textField];
}

- (void)textChange:(id)sender
{
    UITextField *textField = (UITextField *) sender;
    [cellText replaceObjectAtIndex:textField.tag withObject:textField.text];
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
    int nextTag = cell.tag + ((TAG_TO_INDEX(cell.tag) == CELL_INDEX_REST_CITY && isUsa == NO) ? 2 : 1);
    TextCell *next = (TextCell *) [self cellWithTag:nextTag];

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
    NSArray *array = nil;
    int row = 0;
    
    switch (TAG_TO_INDEX(cell.tag)) {
        case CELL_INDEX_REST_NAME:
        case CELL_INDEX_REST_CITY:
        case CELL_INDEX_MEAL_NAME:
            cell.textField.inputView = nil;
            return YES;
        case CELL_INDEX_REST_COUNTRY:
            array = arrays.countryText;
            break;
        case CELL_INDEX_REST_STATE:
            array = arrays.stateText;
            break;
        case CELL_INDEX_MEAL_TYPE:
            array = arrays.mealTypeText;
            break;
        case CELL_INDEX_MEAL_PRICE:
            if (isUsa)
                array = arrays.mealPriceUsaText;
            else
                array = arrays.mealPriceWorldText;
            break;
        case CELL_INDEX_MEAL_TASTE:
            array = arrays.mealTasteText;
            break;
    }
    
    for (int i = 1; i < array.count; i++) {
        if ([textField.text isEqualToString:[array objectAtIndex:i]]) {
            row = i;
            break;
        }
    }

    currPickerArray = array;
    currPickerTextFieldTag = cell.tag;

    textField.text = [array objectAtIndex:row];
    textField.inputView = [self createPickerView:row cellIndex:TAG_TO_INDEX(cell.tag) array:array];

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
    
    // see if the country changed
    if (cell.tag == INDEX_TO_TAG(CELL_INDEX_REST_COUNTRY)) {
        TextCell *currency = [self cellWithTag:INDEX_TO_TAG(CELL_INDEX_MEAL_PRICE)];
        
        // reset currency
        [cellText replaceObjectAtIndex:CELL_INDEX_REST_COUNTRY withObject:@""];
        currency.textField.text = @"";
        
        if ([[cell.textField.text lowercaseString] isEqualToString:@"usa"]) {
            if (isUsa == NO) {
                isUsa = YES;
                [arrays.postKeys replaceObjectAtIndex:CELL_INDEX_MEAL_PRICE withObject:@"dish_price_usa"];
                NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:CELL_INDEX_REST_STATE inSection:CELL_SECTION_REST]];
                [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            }
        } else {
            if (isUsa) {
                // only delete row if we are switching from usa to non-usa
                isUsa = NO;
                [arrays.postKeys replaceObjectAtIndex:CELL_INDEX_MEAL_PRICE withObject:@"dish_price"];
                [cellText replaceObjectAtIndex:CELL_INDEX_REST_STATE withObject:@""];
                NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:CELL_INDEX_REST_STATE inSection:CELL_SECTION_REST]];
                [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

-(void)uploadHandler:(id)sender
{
    // disable cell selection until upload complete
    self.tableView.userInteractionEnabled = NO;

    if ([self isValidData]) {
        
        uploadCancelAlert = [[UIAlertView alloc]
                             initWithTitle:@"Uploading..."
                             message:@"\n"
                             delegate:self cancelButtonTitle:@"Cancel"
                             otherButtonTitles:nil];
        
        uploadCancelSpinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 42, 30, 30)];
        uploadCancelSpinner.hidesWhenStopped = YES;
        uploadCancelSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [uploadCancelAlert setDelegate:self];
        [uploadCancelAlert addSubview:uploadCancelSpinner];
        [uploadCancelAlert show];
        [uploadCancelSpinner startAnimating];

        [self upload];
    } else {
        // re-enable cell selection
        self.tableView.userInteractionEnabled = YES;
    }
}

- (void)alertView:(UIAlertView *)alert didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.tableView.userInteractionEnabled = YES;
    
    // make sure we don't do this twice
    if (uploadCancelSpinner) {
        [uploadCancelSpinner stopAnimating];
        [uploadCancelSpinner release];
        uploadCancelSpinner = nil;
    }
    
    // make sure we don't do this twice
    if (uploadCancelAlert) {
        [uploadCancelAlert release];
        uploadCancelAlert = nil;
    }

    // if buttonIndex == 0 then the user clicked "cancel"
    // if buttonIndex == -1, then this method was called when the upload request
    //   failed or finished and we have no need to cancel
    if (buttonIndex == 0 && request != nil)
        [request cancel];

}

@end
