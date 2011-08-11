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
#import "MyEyesAreHungryAppDelegate.h"
#import "Login.h"
#import "ASIHTTPRequest.h"

@implementation RootViewController

@synthesize loginAction, loginSuccess;

- (void)viewDidLoad
{
    userPass = [UserPass sharedUserPass];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES]; // have ASI update network status when active
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    MyEyesAreHungryAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.navImage = [UIImage imageNamed: @"header_bar_logo_small.png"];
    self.navigationItem.title = @"";
    [self.navigationController.navigationBar setNeedsDisplay];
    
    /*
    enum LoginAction actionSave = loginAction;
    BOOL successSave = loginSuccess;
     */
    
    loginAction = LOGIN_NO_ACTION;
    loginSuccess = NO;
    
    /*
    if (actionSave == LOGIN_ADD_DISH) {
        if (successSave) {
            [self processAddDish];
        }
    } else if (actionSave != LOGIN_NO_ACTION) {
        if (successSave) {
            [self processMyStuff:loginRow];
        }
    }
     */

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    MyEyesAreHungryAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.navImage = [UIImage imageNamed: @"header_bar_small.png"];
    [self.navigationController.navigationBar setNeedsDisplay];
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
#ifdef MEAH_TESTING
    return 6;
#else
    return 3;
#endif
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
#ifdef MEAH_TESTING
        case 3:
        case 4:
        case 5:
            return 1;
#endif
    }
    return 0;
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

 // Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    /// @todo set keyboard done and next button handlers

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Recent Meals";
        } else {
            cell.textLabel.text = @"Recent Restaurants";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = UITextAlignmentLeft;
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
        cell.textLabel.textAlignment = UITextAlignmentLeft;
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"Add a Dish";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
#ifdef MEAH_TESTING
    else if (indexPath.section == 3) {
        cell.textLabel.text = [NSString stringWithFormat:@"Clear user: %@", [userPass username]];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (indexPath.section == 4) {
        cell.textLabel.text = @"Login";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (indexPath.section == 5) {
        cell.textLabel.text = @"Fast upload";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
#endif

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


- (void)showWebPage:(NSString *) urlString
{
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = urlString;
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
}

- (void)showUploadPage:(UIImage *)image
{
    UploadViewController *uploadViewController = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
    uploadViewController.image = image;
    [self.navigationController pushViewController:uploadViewController animated:YES];
    [uploadViewController release];
}

- (void)showLoginPage
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
    [loginViewController release];
}

- (BOOL)login
{
    NSString *username = [userPass username];
    NSString *password = [userPass password];
    
    BOOL status = [Login loginWithUsername:username andPassword:password];
    
    if (!status) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        [alert release];
    }
    
    return status;
}

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

        if (image)
            [self showUploadPage:image];
    }

    // Remove the picker interface and release the picker object.
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void) processRecents:(NSInteger) row
{
    NSString *urlString;
    
    if (row == 0)
        urlString = @"http://www.myeyesarehungry.com";
    else
        urlString = @"http://www.myeyesarehungry.com/new.php";

    [self showWebPage:urlString];
}

- (void) processMyStuff:(NSInteger) row
{
    // if user/pass is stored in keychain
    //    login
    //    show selected web page
    // else
    //    save the deferred login task
    //    show login page
    //    (web page will be loaded after user logs in)
    
    if ([userPass isValid]) {
        
        if ([self login]) {
            NSString *urlString;
            switch (row) {
                case 0:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 @"test"];
                    break;
                case 1:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 @"test", @"&list=restaurants"];
                    break;
                case 2:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 @"test", @"&list=favorites"];
                    break;
                case 3:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 @"test", @"&list=follows"];
                    break;
            } // switch
            [self showWebPage:urlString];
            [urlString release];
        }
        
    } else {
        
        switch (row) {
            case 0:
                loginAction = LOGIN_SHOW_MY_MEALS;
                break;
            case 1:
                loginAction = LOGIN_SHOW_MY_RESTAURANTS;
                break;
            case 2:
                loginAction = LOGIN_SHOW_MY_FAVS;
                break;
            case 3:
                loginAction = LOGIN_SHOW_MY_FOLLOWS;
                break;
        } // switch
        loginRow = row;
        [self showLoginPage];
    }
}

- (void) processAddDish
{
    // if user/pass is stored in keychain
    //    login
    //    show image picker
    //    show upload page
    // else
    //    save the defferred login task
    //    show login page
    //    (image picker will be loaded after user logs in)
    
    if ([userPass isValid]) {
        if ([self login]) {
            [self selectPicture];
        }
    } else {
        loginAction = LOGIN_ADD_DISH;
        [self showLoginPage];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show the selected web page
    if (indexPath.section == 0) {
        [self processRecents:indexPath.row];
    } else if (indexPath.section == 1) {
        [self processMyStuff:indexPath.row];
    } else if (indexPath.section == 2) {
        [self processAddDish];
    }
    
#ifdef MEAH_TESTING
    else if (indexPath.section == 3) {
        if ([userPass deleteUser])
            NSLog(@"Delete keychain success!\n");
        else
            NSLog(@"Delete keychain fail\n");
        
    } else if (indexPath.section == 4) {
        BOOL status = [Login loginWithUsername:@"test@test.com" andPassword:@"test"];
        if (status) {
            if ([userPass setUser:@"test@test.com" Pass:@"test"])
                NSLog(@"Save user pass in keychain success!\n");
            else
                NSLog(@"Failed to save user pass in keychain\n");
                
        } else {
            NSLog(@"Login failed\n");
        }
    } else if (indexPath.section == 5) {
        [Login loginWithUsername:@"test@test.com" andPassword:@"test"];
        [self showUploadPage:[UIImage imageNamed: @"frank.jpeg"]];
    }
#endif
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
