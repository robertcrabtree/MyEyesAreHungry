//
//  UserImage.m
//  MyEyesAreHungry
//
//  Created by bobby on 8/22/11.
//  Copyright 2011 self. All rights reserved.
//

#import "UserImage.h"
#include "WebViewController.h"
#include "User.h"

@interface TouchyImageView : UIImageView {
    UITableViewController *tableViewController;
}
@property (nonatomic, assign) UITableViewController *tableViewController;

@end

@implementation TouchyImageView

@synthesize tableViewController;
    
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = [NSString stringWithFormat:@"http://www.myeyesarehungry.com/member.php?name=%@", [User sharedUser].user];
    [tableViewController.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
}

-(void)dealloc
{
    tableViewController = nil;
    [super dealloc];
}

@end

@implementation UserImage

-(void)loadUserImage:(UITableViewController *) tableViewController
{
    NSString *url = [NSString stringWithFormat:@"http://www.myeyesarehungry.com/avatars/%@.jpg", [User sharedUser].user];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    if (image == nil) {
        url = @"http://www.myeyesarehungry.com/images/avatar.jpg";
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    }
    
    
    float imageSpacing = 20;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float imageX = imageSpacing;
    float imageY = imageSpacing;
    float imageCenter = imageY + imageHeight / 2;
    
    TouchyImageView *imageView  = [[TouchyImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageWidth, imageHeight)];
    imageView.backgroundColor = [UIColor redColor];
    imageView.userInteractionEnabled = YES;
    imageView.tableViewController = tableViewController;
    
    UIFont *font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
    float labelSpacing = 5;
    float labelWidth = 320 - imageX - imageWidth - labelSpacing;
    float labelHeight = font.pointSize;
    float labelX = imageX + labelSpacing + imageWidth;
    float labelY = imageCenter - labelHeight / 2;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
    label.text = [[User sharedUser].user capitalizedString];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentLeft;
    label.font = font;
    
    float viewSpacing = 10;
    float viewX = 0;
    float viewY = 0;
    float viewWidth = imageX + imageWidth + labelX + labelWidth;
    float viewHeight = imageY + imageHeight + viewSpacing;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
    imageView.image = image;
    [view addSubview:imageView];
    [view addSubview:label];
    
    tableViewController.tableView.tableHeaderView = view;
    
    [imageView release];
    [label release];
    [view release];
}

@end
