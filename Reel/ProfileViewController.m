//
//  ProfileViewController.m
//  Reel
//
//  Created by Jason Arias on 8/30/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "ProfileFolderTableViewCell.h"
#import "ReelRailsAFNClient.h"
#import "SWRevealViewController.h"
#import "UserSession.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *usernameTextView;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *reelsOrAllSegmentedControl;

@property (strong, nonatomic) NSMutableArray *postArray;
@property (strong, nonatomic) NSMutableArray *folderArray;
@end

@implementation ProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *signOutButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutButtonPressed)];
    [[self navigationItem] setLeftBarButtonItem:signOutButton];
    
    UIBarButtonItem *editInfoButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Edit Info" style:UIBarButtonItemStylePlain target:self action:@selector(editInfoButtonPressed)];
    [[self navigationItem] setRightBarButtonItem:editInfoButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    NSMutableString *usernameString = [[NSMutableString alloc] initWithString:@"@"];
    [usernameString appendString:[[UserSession sharedSession] userUsername]];
    [_usernameTextView setText:usernameString];
    
    NSLog(@"%@", [[UserSession sharedSession] userBio]);
    NSString *userBio = [[UserSession sharedSession] userBio] ? [[UserSession sharedSession] userBio] : @"";
    [_bioTextView setText:userBio];
}


-(void)getPosts
{
    NSMutableArray* postsArray = [[NSMutableArray alloc] init];
    [[ReelRailsAFNClient sharedClient] getPostsForUserWithId:[[UserSession sharedSession] userId]
                                                   PostArray:postsArray
                                             CompletionBlock:^(NSError *error){
                                                 NSLog(@"%@", postsArray);
                                             }];
     [self setPostArray:postsArray];
}

-(NSMutableArray*)getFolders
{
    NSDictionary* parameters = @{ @"user_id":[[UserSession sharedSession] userId]};
    return [[ReelRailsAFNClient sharedClient] getFoldersForUserWithId:parameters
                                               CompletionBlock:^(NSError *error){
                                               }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier0 = @"profileFolderTableCell";
    static NSString *CellIdentifier1 = @"profileTableCell";
    
    long row = [indexPath row];
    // Configure the cell...
    if([_reelsOrAllSegmentedControl isEnabledForSegmentAtIndex:0])
    {
        ProfileFolderTableViewCell *cell = [tableView
                                            dequeueReusableCellWithIdentifier:CellIdentifier0
                                            forIndexPath:indexPath];
        cell.titleTextView.text = _folderArray[row][@"title"];
        return cell;
    } else if([_reelsOrAllSegmentedControl isEnabledForSegmentAtIndex:1]){
        ProfileTableViewCell *cell = [tableView
                                      dequeueReusableCellWithIdentifier:CellIdentifier1
                                      forIndexPath:indexPath];
        cell.captionTextView.text = _postArray[row][@"caption"];
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
    [self getPosts];
    [self setFolderArray:[self getFolders]];
    if([_reelsOrAllSegmentedControl isEnabledForSegmentAtIndex:0])
    {
        numberOfRows = [[self folderArray] count];
    } else if([_reelsOrAllSegmentedControl isEnabledForSegmentAtIndex:1]){
        numberOfRows = [[self postArray] count];
    }
    NSLog(@"%li", (long)numberOfRows);
    return numberOfRows;
}


///////// Sign Out /////////
-(void)signOutButtonPressed
{
    [SVProgressHUD show];
    [[ReelRailsAFNClient sharedClient] destroySessionWithCompletionBlock:^(NSError *error) {
        [self segueToSignInSignOutViewController];
        [SVProgressHUD dismiss];
    }];
}

-(void)segueToSignInSignOutViewController
{
    if([[ReelRailsAFNClient sharedClient] sessionDestroySuccess]){
        [self performSegueWithIdentifier:@"SignOutSegue" sender:self];
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
