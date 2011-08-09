//
//  LoginViewController.m
//  MyEyesAreHungry
//
//  Created by bobby on 7/30/11.
//  Copyright 2011 self. All rights reserved.
//

#import "LoginViewController.h"
#import "TextCell.h"
#import "WebViewController.h"
#import "UserPass.h"
#import "MyEyesAreHungryAppDelegate.h"
#import "Login.h"
#import "RootViewController.h"

@implementation LoginViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Login";
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
        return 2;
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
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
    if (indexPath.section == 0)
        cell = [tableView dequeueReusableCellWithIdentifier:TextCellID];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // cell does not exist so create it
    if (cell == nil) {
        if (indexPath.section == 0) {
            TextCell *textCell = [TextCell cellFromNib];
            cell = textCell;
        } else if (indexPath.section == 1) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        } else {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
    }
    
    // configure cell
    if (indexPath.section == 0) {
        TextCell *textCell = (TextCell *) cell;
        if (indexPath.row == 0) {
            textCell.textField.placeholder = @"Email";
            textCell.textField.returnKeyType = UIReturnKeyNext;
            textCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            textCell.textField.secureTextEntry = NO;
            textCell.tag = 0;
        } else {
            textCell.textField.placeholder = @"Password";
            textCell.textField.returnKeyType = UIReturnKeyDone;
            textCell.textField.keyboardType = UIKeyboardTypeDefault;
            textCell.textField.secureTextEntry = YES;
            textCell.tag = 1;
        }
        textCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textCell.textField.delegate = self;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"Login";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    } else {
        cell.textLabel.text = @"Create New account";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2)
        return @"Need a Login?";
    return @"";
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
    if (indexPath.section == 0) {
            TextCell *cell = (TextCell *) [tableView cellForRowAtIndexPath:indexPath];
            [cell.textField becomeFirstResponder];
    } else if (indexPath.section == 1) {
        NSIndexPath *emailIP = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *passIP = [NSIndexPath indexPathForRow:1 inSection:0];
        TextCell *emailCell = (TextCell *) [self.tableView cellForRowAtIndexPath:emailIP];
        TextCell *passCell = (TextCell *) [self.tableView cellForRowAtIndexPath:passIP];
        NSString *email = emailCell.textField.text;
        NSString *password = passCell.textField.text;

        if (![email isEqualToString:@""] && ![password isEqualToString:@""]) {
            
            if ([Login loginWithUsername:email andPassword:password]) {
                [[UserPass sharedUserPass] setUser:email Pass:password];
                RootViewController *root = [self.navigationController.viewControllers objectAtIndex:0];
                root.loginSuccess = YES;
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed"
                                                                message:@""
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
                [alert release];
                
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid username or password"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }

    } else if (indexPath.section == 2) {
        WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        webViewController.urlString = @"http://www.myeyesarehungry.com/join.php";
        [self.navigationController pushViewController:webViewController animated:YES];
        [webViewController release];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    TextCell *cell= (TextCell *) textField.superview.superview;

    if (cell.tag == 0) {
        TextCell *next = (TextCell *) [cell.superview viewWithTag:cell.tag + 1];
        [textField resignFirstResponder];
        [next.textField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }

    return NO;
}

@end
