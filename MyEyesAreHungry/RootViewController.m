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
#import "TextImageButton.h"
#import "NavDeli.h"
#import "BarButtonGen.h"
#import "Reachability.h"

@implementation RootViewController

@synthesize loginAction;

-(void)setLoginButtonText:(NSString *)text
{
    [buttonGen setTitle:text];
}

- (void)viewDidLoad
{
    UIView *buttonView;
    addButton = [[TextImageButton alloc] init];
    [addButton setText:@"Add a Dish"];
    buttonView = [addButton getButtonView];
    [addButton setOrigin:(320 - buttonView.frame.size.width) / 2 y:20];
    [addButton addTarget:self action:@selector(addDishHandler:)];
    self.tableView.tableFooterView = buttonView;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    self.navigationController.delegate = [NavDeli sharedNavDeli];

    userPass = [UserPass sharedUserPass];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES]; // have ASI update network status when active
    
    buttonGen = [[BarButtonGen alloc] init];
    self.navigationItem.rightBarButtonItem = [buttonGen generateWithImage:@"nav_rect" title:@"" target:self action:@selector(loginButtonHandler:)];
    
    Reachability *network = [Reachability reachabilityForLocalWiFi];
    if ([network currentReachabilityStatus] == kNotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This application requires an internet connection. Please connect to a network and try again"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *buttonText = @"Login";
    if ([userPass isValid]) {
        buttonText = @"Logout";
    }
    
    [self setLoginButtonText:buttonText];

    MyEyesAreHungryAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.navImage = [UIImage imageNamed: @"header_bar_logo"];
    self.navigationItem.title = @"";
    [self.navigationController.navigationBar setNeedsDisplay];

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    MyEyesAreHungryAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.navImage = [UIImage imageNamed: @"header_bar"];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 4;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

 // Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

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
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [[self navigationController] presentModalViewController:navController animated:YES];
    [loginViewController release];
    [navController release];
}

- (NSString *)login
{
    NSString *username = [userPass username];
    NSString *password = [userPass password];
    NSString *userToken = [Login loginWithUsername:username andPassword:password];
    
    if (!userToken) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        [alert release];
    }
    
    return userToken;
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

        if (image) {
            int w = (int) image.size.width * image.scale;
            int h = (int) image.size.height * image.scale;
            
            if (w < 3000 && h < 3000) {
                [self showUploadPage:image];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image too big"
                                                                message:@"Must be smaller than 3000x3000"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
                [alert release];
            }
        }
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
        
        NSString *userToken = [self login];
        if (userToken) {
            NSString *urlString = @"";
            switch (row) {
                case 0:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 userToken];
                    break;
                case 1:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 userToken, @"&list=restaurants"];
                    break;
                case 2:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 userToken, @"&list=favorites"];
                    break;
                case 3:
                    urlString = [[NSString alloc ]initWithFormat: @"%@%@%@", @"http://www.myeyesarehungry.com/member.php?name=",
                                 userToken, @"&list=follows"];
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
    // remove the blue color
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

    // show the selected web page
    if (indexPath.section == 0) {
        [self processRecents:indexPath.row];
    } else if (indexPath.section == 1) {
        [self processMyStuff:indexPath.row];
    }
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
    [buttonGen release];
    [addButton release];
    [super dealloc];
}

-(void)loginButtonHandler:(id)sender
{
    if ([userPass isValid]) {
        [userPass deleteUser]; 
        [Login logout];
        [self setLoginButtonText:@"Login"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You have been logged out"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];

    } else {
        [self showLoginPage];
    }
}

-(void)addDishHandler:(id)sender
{
    [self processAddDish];
}

@end
