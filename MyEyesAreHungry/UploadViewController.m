//
//  UploadViewController.m
//  MyEyesAreHungry
//
//  Created by bobby on 7/28/11.
//  Copyright 2011 self. All rights reserved.
//

#import "UploadViewController.h"
#import "TextCell.h"


@implementation UploadViewController

@synthesize image;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        restaurantArray = [[NSArray alloc] initWithObjects:@"Restaurant Name", @"Restaurant Country", 
                           @"Restaurant City", @"Restaurant State", nil];
        mealArray = [[NSArray alloc] initWithObjects:@"Meal Type", @"Meal Name", @"Meal Price", nil];
    }
    return self;
}

- (void)dealloc
{
    [restaurantArray release];
    [mealArray release];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [restaurantArray release];
    [mealArray release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
                textCell.textField.placeholder = [restaurantArray objectAtIndex:indexPath.row];
            } else {
                textCell.textField.placeholder = [mealArray objectAtIndex:indexPath.row];
            }

            if (indexPath.section == 1 && indexPath.row == mealArray.count - 1) {
                textCell.textField.returnKeyType = UIReturnKeyDone;
                textCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            } else {
                textCell.textField.returnKeyType = UIReturnKeyNext;
                textCell.textField.keyboardType = UIKeyboardTypeDefault;
            }
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    if (indexPath.section != 2)
        return;
    
    /// @todo release this when uploading is finished
    progressAlert = [[UIAlertView alloc] initWithTitle:@"Uploading" message:@"Please wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    // Create the progress bar and add it to the alert
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
    [progressAlert addSubview:progressView];
    [progressView setProgressViewStyle:UIProgressViewStyleBar];
    [progressAlert show];
    [progressView release];
}

@end
