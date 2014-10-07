//
//  VisitUserProfileTableViewController.m
//  Reel
//
//  Created by Jason Arias on 9/27/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "FolderTableViewCell.h"
#import "PeopleSearchTableViewController.h"
#import "PostTableViewCell.h"
#import "ReelRailsAFNClient.h"
#import "UserSession.h"
#import "VisitUserProfileTableViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>


@interface VisitUserProfileTableViewController ()


@end

@implementation VisitUserProfileTableViewController


@synthesize following = _following;

-(void)viewDidLoad
{
    [super viewDidLoad];
    [_followButton.layer setCornerRadius:10.0f];
    [[self followButton] setTitle:_following ? @"unfollow" : @"follow" forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:[self userName]
                                                     style:UIBarButtonItemStyleBordered
                                                    target:nil
                                                    action:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    [super viewWillAppear:animated];
    [self setUpUserInfo];
    [SVProgressHUD dismiss];
    [[self tableView] reloadData];
}

-(void)setUpUserInfo
{
    [[self nameTextView] setText:[self userName]];
    [[self usernameTextView] setText:[ProfileTableViewController formatUserName:[self userUsername]]];
    [[self bioTextView] setText:[self userBio]];
    [self setUserFolders:[[ReelRailsAFNClient sharedClient] getFoldersForUserWithId:@{@"userId": [self userId]}
                                               CompletionBlock:^(NSError *error) {
                                                   if(!error){
                                                       [[self tableView] reloadData];
                                                   } else {
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting Folders"
                                                                                                       message:@""
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:@"OK"
                                                                                             otherButtonTitles:nil];
                                                       [alert show];
                                                   }
                                               }]];
    [self setUserPosts:[[ReelRailsAFNClient sharedClient] getPostsForUserWithId:@{@"userId": [self userId]}
                                             CompletionBlock:^(NSError *error) {
                                                 if(!error){
                                                     [[self tableView] reloadData];
                                                 }else{
                                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting Posts"
                                                                                                     message:@""
                                                                                                    delegate:nil
                                                                                           cancelButtonTitle:@"OK"
                                                                                           otherButtonTitles:nil];
                                                     [alert show];
                                                 }
                                             }]];
}


- (IBAction)followButtonTouchUpInside:(id)sender {
    [self toggleFollow];
}

-(void)toggleFollow
{
    if(_following)
    {
        [self setFollowing:NO];
        [[self followButton] setTitle:@"follow" forState:UIControlStateNormal];
        [[ReelRailsAFNClient sharedClient] destroyRelationshipWhereUserWithId:[[UserSession sharedSession] userId]
                                                          UnfollowsUserWithId:[self userId]
                                                          WithCompletionBlock:^(NSError *error) {
                                                              if(error){
                                                                  //reset BOOL and button text and display error message
                                                                  [self setFollowing:YES];
                                                                  [[self followButton] setTitle:@"unfollow" forState:UIControlStateNormal];
                                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Unfollowing"
                                                                                                                  message:@""
                                                                                                                 delegate:nil
                                                                                                        cancelButtonTitle:@"OK"
                                                                                                        otherButtonTitles:nil];
                                                                  [alert show];
                                                              }

                                                          }];
    }else{ //not following
        [self setFollowing:YES];
        [[self followButton] setTitle:@"unfollow" forState:UIControlStateNormal];
        [[ReelRailsAFNClient sharedClient] createRelationshipWhereUserWithId:[[UserSession sharedSession] userId]
                                                           FollowsUserWithId:[self userId]
                                                         WithCompletionBlock:^(NSError *error) {
                                                             if(error){
                                                                 //reset BOOL and button text and display error message
                                                                 [self setFollowing:NO];
                                                                 [[self followButton] setTitle:@"follow" forState:UIControlStateNormal];
                                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Following"
                                                                                                                 message:@""
                                                                                                                delegate:nil
                                                                                                       cancelButtonTitle:@"OK"
                                                                                                       otherButtonTitles:nil];
                                                                 [alert show];
                                                             }

                                                         }];

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([[segue identifier] isEqualToString:@"segueToFolderPosts"])
    {
        // Get reference to the destination view controller
        VisitUserProfileTableViewController *vc = [segue destinationViewController];
        FolderTableViewCell* cell = (FolderTableViewCell*)[[sender superview] superview];
        NSLog(@"%@", [cell class]);
        
        // Pass any objects to the view controller here, like...
        [vc setUserUsername:[ProfileTableViewController formatUserName:[self userUsername]]];
    }

    
}



@end
