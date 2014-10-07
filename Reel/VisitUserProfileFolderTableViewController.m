//
//  ProfileFolderTableViewController.m
//  Reel
//
//  Created by Jason Arias on 10/7/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "PostTableViewCell.h"
#import "VisitUserProfileFolderTableViewController.h"
#import "ReelRailsAFNClient.h"

#import <SVProgressHUD/SVProgressHUD.h>


@interface VisitUserProfileFolderTableViewController ()

@property(strong, nonatomic) NSString *userName;

@end

@implementation VisitUserProfileFolderTableViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableString *usernameString = [[NSMutableString alloc] initWithString:@"by: "];
    [usernameString appendString:_userUsername];
    [[self userNameTextView] setText:usernameString];
    
}


@end
