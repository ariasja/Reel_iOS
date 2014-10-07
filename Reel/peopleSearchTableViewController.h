//
//  PeopleSearchTableViewController.h
//  Reel
//
//  Created by Jason Arias on 9/25/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleSearchTableViewController : UITableViewController

@property(strong, nonatomic) NSArray *usersArray;
@property(strong, nonatomic) NSArray *searchResults;
@property(strong, nonatomic) NSMutableArray *followedUsersArray;
@property(strong, nonatomic) NSMutableArray *followersArray;

@end
