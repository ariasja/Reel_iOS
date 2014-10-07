//
//  ProfileFolderTableViewController.h
//  Reel
//
//  Created by Jason Arias on 10/7/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProfileFoldersTableViewController.h"

@class ProfileFoldersTableViewController;
@interface VisitUserProfileFolderTableViewController : ProfileFoldersTableViewController

@property (weak, nonatomic) IBOutlet UITextView *userNameTextView;
@property (strong, nonatomic) NSMutableString *userUsername;

@end
