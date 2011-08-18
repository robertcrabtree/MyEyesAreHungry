//
//  FollowsViewController.h
//  MyEyesAreHungry
//
//  Created by bobby on 8/17/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FollowsViewController : UITableViewController {
    NSMutableArray *followsNames;
    NSMutableArray *followsIds;
    NSMutableArray *selectedNames;
    NSString *userToken;
}

@property (nonatomic, retain) NSMutableArray *followsNames;
@property (nonatomic, retain) NSMutableArray *followsIds;
@property (nonatomic, retain) NSString *userToken;

@end
