//
//  ProfileViewController.m
//  Reel
//
//  Created by Jason Arias on 8/30/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ProfileViewController.h"
#import "PostTableViewCell.h"
#import "FolderTableViewCell.h"
#import "ProfileFoldersTableViewController.h"
#import "ReelRailsAFNClient.h"
#import "SWRevealViewController.h"
#import "UserSession.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *usernameTextView;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *reelsOrAllSegmentedControl;
@end

@implementation ProfileViewController

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
    
    [_reelsOrAllSegmentedControl addTarget:self
                                    action:@selector(segmentedControlTouched)
               forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
        [self.navigationItem setHidesBackButton:YES];
        [self setUpProfile];
}

///////// Profile Info /////////
-(void)setUpProfile
{
    [_nameTextView setText:[[UserSession sharedSession] userName]];
    NSString *userUsername = [[UserSession sharedSession] userUsername];
    NSMutableString *usernameString = [[NSMutableString alloc] initWithString:@"@"];
    [usernameString appendString:userUsername];
    [_usernameTextView setText:usernameString];
    NSLog(@"%@", [[UserSession sharedSession] userBio]);
    NSString *userBio = [[UserSession sharedSession] userBio] ? [[UserSession sharedSession] userBio] : @"";
    [_bioTextView setText:userBio ? userBio : @""];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier0 = @"profileFolderTableCell";
    NSString *CellIdentifier1 = @"profileTableCell";
    
    long row = [indexPath row];
    // Configure the cell...
    if(_reelsOrAllSegmentedControl.selectedSegmentIndex == 0)
    {
        FolderTableViewCell *cell = [tableView
                                            dequeueReusableCellWithIdentifier:CellIdentifier0
                                            forIndexPath:indexPath];
        NSArray *folderArray = [[NSArray alloc] initWithArray:[[UserSession sharedSession] userFolders]];
        [cell.titleButton setTitle:folderArray[row][@"title"] forState:UIControlStateNormal];
        cell.folderId = folderArray[row][@"id"];
        return cell;
    } else if(_reelsOrAllSegmentedControl.selectedSegmentIndex == 1){
        PostTableViewCell *cell = [tableView
                                      dequeueReusableCellWithIdentifier:CellIdentifier1
                                      forIndexPath:indexPath];
        NSArray *postArray = [[NSArray alloc] initWithArray:[[UserSession sharedSession] userPosts]];
        cell.captionTextView.text = postArray[row][@"caption"];
        return cell;
    }
    
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if(_reelsOrAllSegmentedControl.selectedSegmentIndex == 0)
    {
        numberOfRows = [[[UserSession sharedSession] userFolders] count];
    } else if(_reelsOrAllSegmentedControl.selectedSegmentIndex == 1){
        numberOfRows = [[[UserSession sharedSession] userPosts] count];
    }
    NSLog(@"%li", (long)numberOfRows);
    return numberOfRows;
}

///////// Segmented Control /////////

-(void)segmentedControlTouched
{
    NSLog(@"touch");
    [self.tableView reloadData];

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

///////// Segue /////////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"segueToFolderPosts"])
    {
        // Get reference to the destination view controller
        ProfileFoldersTableViewController *vc = [segue destinationViewController];
        FolderTableViewCell* cell = (FolderTableViewCell*)[[sender superview] superview];
        NSLog(@"%@", [cell class]);
        
        // Pass any objects to the view controller here, like...
        NSNumber *folderId = [cell folderId];
        NSString *folderTitle = [[cell titleButton] titleForState:UIControlStateNormal];
        [vc setFolderId:folderId];
        [vc setFolderTitle:folderTitle];
    }
}
- (IBAction)titleButtonTouchUpInside:(id)sender {
    NSLog(@"%@", [sender class]);
    [self performSegueWithIdentifier:@"segueToFolderPosts" sender:sender];
}


@end
