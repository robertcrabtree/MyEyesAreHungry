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
#import "User.h"
#import "MyEyesAreHungryAppDelegate.h"
#import "TextImageButton.h"
#import "NavDeli.h"
#import "BarButtonGen.h"
#import "Reachability.h"

#define INDEX_TO_TAG(x) ((x) + 1000)
#define TAG_TO_INDEX(x) ((x) - 1000)

/********************************************************/
@interface ClickableLabel : UILabel {
    UITableViewController *tableViewController;
    NSString *urlString;
}

@property (nonatomic, assign) UITableViewController *tableViewController;
@property (nonatomic, retain) NSString *urlString;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
/********************************************************/
@implementation ClickableLabel

@synthesize tableViewController;
@synthesize urlString;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"label touch begin");
    self.textColor = [UIColor blueColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"label touch end");
    self.textColor = [UIColor blackColor];
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = urlString;
    [tableViewController.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
}

@end
/********************************************************/

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
    [loginButton release];
    [cellText release];
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
    
    // *** HACK: All the positioning here is a major hack due to a last minute
    // customer request. I don't have time to re-design most of the positioning
    // so I'm leaving it as a mess. At some point it may be worth it to redesign
    // some of this stuff so that both clickable labels and the button are 
    // positioned in a clean fashion.
    
    self.navigationController.delegate = [NavDeli sharedNavDeli];
    loginButton = [[TextImageButton alloc] init];
    [loginButton setText:@"Login"];
    buttonView = loginButton.view;
    [loginButton setOrigin:(320 - buttonView.frame.size.width) / 2 y:49];
    [loginButton addTarget:self action:@selector(loginHandler:)];
    self.tableView.tableFooterView = buttonView;
    
    CGSize labelSize;
    float labelX;
    
    // Create an account label
    // Place it below the button
    ClickableLabel *label = [[ClickableLabel alloc] init];
    label.text = @"Create an Account";
    labelSize = [label.text sizeWithFont:label.font];
    labelX = self.tableView.frame.size.width / 2 - labelSize.width / 2;
    label.frame = CGRectMake(labelX, 110, labelSize.width, labelSize.height);
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.tableViewController = self;
    label.urlString = @"http://www.myeyesarehungry.com/api/join.php";
    label.userInteractionEnabled = YES;
    
    CGRect frame = buttonView.frame;
    frame.size.height += 110;
    buttonView.frame = frame;
    [buttonView addSubview:label];
    [label release];
    
    // Retrieve password label
    // Place it above the button
    label = [[ClickableLabel alloc] init];
    label.text = @"Forgot password?";
    labelSize = [label.text sizeWithFont:label.font];
    labelX = self.tableView.frame.size.width / 2 - labelSize.width / 2;
    label.frame = CGRectMake(labelX, 10, labelSize.width, labelSize.height);
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.tableViewController = self;
    label.urlString = @"http://www.myeyesarehungry.com/api/password_retrieve.php";
    label.userInteractionEnabled = YES;
    
    frame = buttonView.frame;
    frame.size.height += 10;
    buttonView.frame = frame;
    [buttonView addSubview:label];
    [label release];


    self.tableView.backgroundColor = [UIColor clearColor];
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    BarButtonGen *buttonGen = [[BarButtonGen alloc] init];
    self.navigationItem.leftBarButtonItem = [buttonGen generateWithImage:@"nav_rect" title:@"Cancel" target:self action:@selector(cancelLogin:)];
    [buttonGen release];
    
    cellText = [[NSMutableArray alloc] initWithObjects:@"", @"", nil];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
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
        } else {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
    }
    
    // configure cell
    TextCell *textCell = (TextCell *) cell;
    if (indexPath.row == 0) {
        textCell.textField.placeholder = @"Email";
        textCell.textField.returnKeyType = UIReturnKeyNext;
        textCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        textCell.textField.secureTextEntry = NO;
    } else {
        textCell.textField.placeholder = @"Password";
        textCell.textField.returnKeyType = UIReturnKeyDone;
        textCell.textField.keyboardType = UIKeyboardTypeDefault;
        textCell.textField.secureTextEntry = YES;
    }
    
    textCell.textField.text = [cellText objectAtIndex:indexPath.row];
    [textCell.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    textCell.textField.tag = indexPath.row;
    textCell.tag = INDEX_TO_TAG(indexPath.row);
    
    textCell.accessoryType = UITableViewCellAccessoryNone;
    textCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textCell.textField.delegate = self;

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

-(TextCell *) cellWithTag:(NSInteger)tag
{
    TextCell *cell = (TextCell *) [self.tableView viewWithTag:tag];
    
    if (!cell) {
        int row = TAG_TO_INDEX(tag);
        int section = 0;
        cell = (TextCell *) [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    return cell;
}

-(TextCell *) cellInSection:(NSInteger)section AndRow:(NSInteger)row
{
    return [self cellWithTag:INDEX_TO_TAG(row)];
}

-(BOOL)isValidData
{
    NSString *email = [cellText objectAtIndex:0];
    NSString *password = [cellText objectAtIndex:1];
    
    if (email == nil || email.length < 7 ||
        [email rangeOfString:@"@"].location == NSNotFound ||
        [email rangeOfString:@"."].location == NSNotFound) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid email address"
                                                        message:@"Must be a valid email address with 7 or more characters"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        
        return NO;
    }

    NSString *chars = @"abcdefghijklmnopqrstuvwxyz1234567890_-";
    NSRange passRange = {0, 1};
    NSRange charsRange = {0, 1};

    // check for invalid chars (not in string above)
    int matched = 0;
    for (int i = 0; i < password.length; i++) {
        passRange.location = i;
        NSString *passChar = [[password substringWithRange:passRange] lowercaseString];
        for (int j = 0; j < chars.length; j++) {
            charsRange.location = j;
            NSString *charsChar = [chars substringWithRange:charsRange];
            if ([charsChar isEqualToString:passChar]) {
                matched++;
            }
        }
    }
    
    if (password == nil || password.length < 4 || matched != password.length) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid password"
                                                        message:@"Must be a valid password with 4 or more characters containing only A-Z, a-z, -, and _"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];

        return NO;
    }

    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextCell *cell = (TextCell *) [tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
}

- (void)textChange:(id)sender
{
    UITextField *textField = (UITextField *) sender;
    [cellText replaceObjectAtIndex:textField.tag withObject:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    TextCell *cell= (TextCell *) textField.superview.superview;

    if (cell.tag == INDEX_TO_TAG(0)) {
        TextCell *next = (TextCell *) [self cellWithTag:cell.tag + 1];
        [textField resignFirstResponder];
        [next.textField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }

    return NO;
}

-(void)loginHandler:(id)sender
{
    
    // disable cell selection until login complete
    self.tableView.userInteractionEnabled = NO;
    
    TextCell *emailCell = (TextCell *) [self cellWithTag:INDEX_TO_TAG(0)];
    TextCell *passCell = (TextCell *) [self cellWithTag:INDEX_TO_TAG(1)];
    NSString *email = emailCell.textField.text;
    NSString *password = passCell.textField.text;
    User *user = [User sharedUser];
    
    if ([self isValidData]) {
        user.target = self;
        user.selectorFailNetwork = @selector(loginFailNetwork);
        user.selectorFailCredentials = @selector(loginFailCredentials);
        user.selectorSuccess = @selector(loginSuccess);
        [user login:email password:password];
    } else {
        // re-enable cell selection
        self.tableView.userInteractionEnabled = YES;
    }
}

-(void) loginSuccess
{
    self.tableView.userInteractionEnabled = YES;
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void) loginFailNetwork
{
    self.tableView.userInteractionEnabled = YES;

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed"
                                                    message:@"Network error"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

-(void) loginFailCredentials
{
    self.tableView.userInteractionEnabled = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed"
                                                    message:@"Invalid username or password"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

-(void)cancelLogin:(id) sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
