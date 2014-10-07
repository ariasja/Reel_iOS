//
//  VisitUserProfileTableViewController.h
//  Reel
//
//  Created by Jason Arias on 9/27/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProfileTableViewController.h"

@class ProfileTableViewController;

@interface VisitUserProfileTableViewController : ProfileTableViewController

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (nonatomic) BOOL following;

@end
