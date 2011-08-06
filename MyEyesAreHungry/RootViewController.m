//
//  RootViewController.m
//  MyEyesAreHungry
//
//  Created by Jason Adams on 7/20/11.
//  Copyright 2011 self. All rights reserved.
//

#import "RootViewController.h"
#import "WebViewController.h"
#import "UploadViewController.h"
#import "LoginViewController.h"
#import "UserPass.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"My Eyes Are Hungry";
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

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 4;
        case 2:
            return 1;
    }
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    /// @todo set keyboard done and next button handlers

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Recent Meals";
            } else {
                cell.textLabel.text = @"Recent Restaurants";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"My Meals";
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"My Restaurants";
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"My Favorites";
            } else {
                cell.textLabel.text = @"My Follows";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"Add a Dish";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.backgroundColor = [UIColor brownColor];
        }
    }

    // Configure the cell.
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
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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


- (void)takePicture
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        return;
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}

- (void)chooseFromLibrary
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        return;
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}


- (void)selectPicture
{
    UIActionSheet *methodAlert;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        methodAlert = [[UIActionSheet alloc] initWithTitle:@""
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"Choose from library", @"Take picture", nil];
    } else {
        methodAlert = [[UIActionSheet alloc] initWithTitle:@""
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:	@"Choose from library", nil];
    }
    [methodAlert showInView:self.view];
	[methodAlert release];
}


- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
            [self chooseFromLibrary];
            break;
            
		case 1:
            [self takePicture];
            break;
	}
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;

    if (info) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];

        if (image) {
            UploadViewController *uploadViewController = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
            [self.navigationController pushViewController:uploadViewController animated:YES];
            uploadViewController.image = image;
            [uploadViewController release];
        }
    }

    // Remove the picker interface and release the picker object.
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlString;
    UserPass *userPass = [UserPass sharedUserPass];
    
    /// @todo clean up this function. pending apis from neil

    if (indexPath.section == 2) {
        //if ([userPass isValid]) {
        if (NO) { /// @todo remove
            [self selectPicture];
            return;
        } else {
            /*
            LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:loginViewController animated:YES];
            [loginViewController release];
            return;
             */
            /// @todo uncomment above and remove below
            UploadViewController *uploadViewController = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
            [self.navigationController pushViewController:uploadViewController animated:YES];
            [uploadViewController release];
            return;
        }
    }

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            urlString = [[NSString alloc ]initWithString:@"http://www.myeyesarehungry.com"];
        } else {
            urlString = [[NSString alloc ]initWithString:@"http://www.myeyesarehungry.com/new.php"];
        }
    } else if (indexPath.section == 1) {
        if ([userPass isValid]) {
            NSString *userName = [userPass username];
            switch (indexPath.row) {
                case 0:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 userName];
                    break;
                case 1:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 userName, @"&list=restaurants"];
                    break;
                case 2:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 userName, @"&list=favorites"];
                    break;
                case 3:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 userName, @"&list=follows"];
                    break;
            }
        } else {
            LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:loginViewController animated:YES];
            [loginViewController release];
            return;
        }
    }

    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = urlString;
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
    [urlString release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}

@end
