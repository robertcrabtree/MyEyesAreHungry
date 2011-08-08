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
#ifdef TEST_MEAH
    cheatArray = [[NSArray alloc] initWithObjects:@"rest_name", @"rest_country", @"rest_city", @"rest_state",
                  @"dish_type", @"dish_name", @"dish_price", @"dish_taste", nil];
#endif
    postVarArray = [[NSArray alloc] initWithObjects:@"rest_name", @"rest_country", @"rest_city", @"rest_state",
                    @"dish_type", @"dish_name", @"dish_price", @"dish_taste", nil];
    restaurantArray = [[NSArray alloc] initWithObjects:@"Restaurant Name", @"Restaurant Country", 
                       @"Restaurant City", @"Restaurant State", nil];
    mealArray = [[NSArray alloc] initWithObjects:@"Meal Type", @"Meal Name", @"Meal Price", @"Meal Taste", nil];
}

- (void)viewDidUnload
{
#ifdef TEST_MEAH
    [cheatArray release];
#endif
    [restaurantArray release];
    [mealArray release];
    [postVarArray release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [restaurantArray release];
    [mealArray release];
}

- (void)viewWillAppear:(BOOL)animated
{
    MyEyesAreHungryAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.navImage = [UIImage imageNamed: @"header_bar_small.png"];
    self.navigationItem.title = @"Upload";
    //[self.navigationController.navigationBar setNeedsDisplay];
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
        return restaurantArray.count;
    else if (section == 1)
        return mealArray.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath.section == 0 || indexPath.section == 1) {
            TextCell *textCell = [TextCell cellFromNib];
            
            if (indexPath.section == 0) {
#ifdef TEST_MEAH
                textCell.textField.text = [cheatArray objectAtIndex:indexPath.row];
#else
                textCell.textField.placeholder = [restaurantArray objectAtIndex:indexPath.row];
#endif
                textCell.tag = indexPath.row;
            } else {
#ifdef TEST_MEAH
                textCell.textField.text = [cheatArray objectAtIndex:indexPath.row + restaurantArray.count];
#else
                textCell.textField.placeholder = [mealArray objectAtIndex:indexPath.row];
#endif
                textCell.tag = indexPath.row + restaurantArray.count;
            }

            if (indexPath.section == 1 && indexPath.row == mealArray.count - 1) {
                textCell.textField.returnKeyType = UIReturnKeyDone;
                textCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            } else {
                textCell.textField.returnKeyType = UIReturnKeyNext;
                textCell.textField.keyboardType = UIKeyboardTypeDefault;
            }
            textCell.textField.delegate = self;
            cell = textCell;
        } else {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

            cell.textLabel.text = @"Upload";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.backgroundColor = [UIColor brownColor];
        }
    }
    
    // Configure the cell...
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TextCell *cell = (TextCell *) [tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
        return;
    } else {
        NSURL *url = [NSURL URLWithString:@"http://www.myeyesarehungry.com/upload.php"];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        
        for (int i = 0; i < cheatArray.count; i++) {
            NSString *key = [postVarArray objectAtIndex:i];
            NSString *value = [cheatArray objectAtIndex:i];
            [request setPostValue:value forKey:key];
            NSLog(@"value=%@ key=%@", value, key);
        }
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        [request addData:imageData withFileName:@"meal.jpeg" andContentType:@"image/jpeg" forKey:@"image"];
        [request startSynchronous];
        
        /// @todo need status codes from neil
        if ((![request error]) && ([request responseStatusCode] < 400))
            NSLog(@"upload success");
        else
            NSLog(@"upload failure");
        
        [request release];
    }

    /// @todo release this when uploading is finished
    /*
    progressAlert = [[UIAlertView alloc] initWithTitle:@"Uploading" message:@"Please wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    // Create the progress bar and add it to the alert
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
    [progressAlert addSubview:progressView];
    [progressView setProgressViewStyle:UIProgressViewStyleBar];
    [progressAlert show];
    [progressView release];
     */
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

@end
