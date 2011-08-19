//
//  FollowsViewController.m
//  MyEyesAreHungry
//
//  Created by bobby on 8/17/11.
//  Copyright 2011 self. All rights reserved.
//

#import "FollowsViewController.h"
#import "ASIFormDataRequest.h"
#import "Login.h"

#define INDEX_TO_TAG(x) ((x) + 1000)
#define TAG_TO_INDEX(x) ((x) - 1000)
#define MAX_SEL_FOLLOWS 4

@implementation FollowsViewController

@synthesize followsNames, followsIds;

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
    [selectedNames release];
    self.followsNames = nil;
    self.followsIds = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(UITableViewCell *) cellWithTag:(NSInteger)tag
{
    UITableViewCell *cell = (UITableViewCell *) [self.tableView viewWithTag:tag];
    
    if (!cell) {
        int row = TAG_TO_INDEX(tag);
        int section = 0;
        cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    return cell;
}

-(void)populate
{
    for (int i = 0; i < followsNames.count; i++) {
        [selectedNames addObject:[followsNames objectAtIndex:i]];
    }
    NSLog(@"followsNames.count = %d", followsNames.count);
    
    NSURL *url = [NSURL URLWithString:@"http://www.myeyesarehungry.com/api/friends.php"];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:[Login userToken] forKey:@"user_name"];
    [request startSynchronous];

    NSDictionary *dict = [request responseHeaders];
    NSString *csvFollowsIds = [dict objectForKey:@"X-Friends-Ids"];
    NSString *csvFollowsNames = [dict objectForKey:@"X-Friends-Names"];
    
    [self.followsIds removeAllObjects];
    [self.followsNames removeAllObjects];
    
    [self.followsIds addObjectsFromArray:[csvFollowsIds componentsSeparatedByString:@","]];
    [self.followsNames addObjectsFromArray:[csvFollowsNames componentsSeparatedByString:@","]];

    [request release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    selectedNames = [[NSMutableArray alloc] init];
    [self populate];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Follows";
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    for (int i = 0; i < followsNames.count; i++) {
        if (![selectedNames containsObject:[followsNames objectAtIndex:i]]) {
            [followsIds removeObjectAtIndex:i];
            [followsNames removeObjectAtIndex:i];
            i--;
        }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (followsIds == nil || followsIds.count == 0)
        return 1;
    return followsIds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    if (followsIds == nil || followsIds.count == 0) {
        cell.textLabel.text = @"No follows";
    } else {
        if (selectedNames.count > 0 &&
            [selectedNames containsObject:[followsNames objectAtIndex:indexPath.row]])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = [followsNames objectAtIndex:indexPath.row];
    }

    cell.tag = INDEX_TO_TAG(indexPath.row);

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (followsIds && followsIds.count > 0 && indexPath.section == 0) {
        UITableViewCell * cell = [self cellWithTag:INDEX_TO_TAG(indexPath.row)];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [selectedNames removeObject:cell.textLabel.text];
        } else {
            
            int numSel = 1;
            
            for (int i = 0; i < followsIds.count; i++) {
                UITableViewCell *cell = (UITableViewCell *) [self cellWithTag:INDEX_TO_TAG(i)];
                if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
                    numSel++;
            }
            
            if (numSel > MAX_SEL_FOLLOWS) {
                NSString *msg = [NSString stringWithFormat:@"Select a max of %d", MAX_SEL_FOLLOWS];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too many follows"
                                                                message:msg
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
                [alert release];

            } else {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [selectedNames addObject:cell.textLabel.text];
            }
            
        }
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
