//
//  ProfileViewController.m
//  Reel
//
//  Created by Jason Arias on 8/30/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "CurrentUserProfileTableViewController.h"
#import "PostTableViewCell.h"
#import "FolderTableViewCell.h"
#import "ProfileFoldersTableViewController.h"
#import "ReelRailsAFNClient.h"
#import "SWRevealViewController.h"
#import "UserSession.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface CurrentUserProfileTableViewController ()

@end

@implementation CurrentUserProfileTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *signOutButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutButtonPressed)];
    [[self navigationItem] setLeftBarButtonItem:signOutButton];
    
    UIBarButtonItem *editInfoButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Edit Info" style:UIBarButtonItemStylePlain target:self action:@selector(editInfoButtonPressed)];
    [[self navigationItem] setRightBarButtonItem:editInfoButton];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Profile"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    [self setUpUserInfo];
    
}

-(void)setUpUserInfo
{
    NSString *userName = [[UserSession sharedSession] userName];
    NSString *userUsername = [[UserSession sharedSession] userUsername];
    NSString *userBio = [[UserSession sharedSession] userBio];
    
    [self setUserId:[[UserSession sharedSession] userId]];
    [self setUserName:userName];
    [[self nameTextView] setText:userName];
    [self setUserUsername:userUsername];
    [[self usernameTextView] setText:[ProfileTableViewController formatUserName:userUsername]];
    [self setUserBio:userBio];
    [[self bioTextView] setText:userBio];
    [self setUserEmail:[[UserSession sharedSession] userEmail]];
    [self setUserFolders:[[UserSession sharedSession] userFolders]];
    [self setUserPosts:[[UserSession sharedSession] userPosts]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
        [self.navigationItem setHidesBackButton:YES];
}


///////// Sign Out /////////
-(void)signOutButtonPressed
{
    [SVProgressHUD show];
    [[ReelRailsAFNClient sharedClient] destroySessionWithCompletionBlock:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:^(void){}];
        [SVProgressHUD dismiss];
    }];
}

-(void)segueToLogInPage
{
    if([[ReelRailsAFNClient sharedClient] sessionDestroySuccess]){
        [self performSegueWithIdentifier:@"logOutSegue" sender:self];
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Session not Destroyed"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

///////// Edit /////////
-(void)editInfoButtonPressed
{
    [self performSegueWithIdentifier:@"EditInfoSegue" sender:self];
}




@end
