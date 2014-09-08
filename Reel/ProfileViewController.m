//
//  ProfileViewController.m
//  Reel
//
//  Created by Jason Arias on 8/30/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ProfileViewController.h"
#import "ReelRailsAFNClient.h"
#import "SWRevealViewController.h"
#import "UserSession.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface ProfileViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *usernameTextView;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
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
    
    [_nameTextView setText:[[UserSession sharedSession] userName]];
    NSMutableString *usernameString = [[NSMutableString alloc] initWithString:@"@"];
    [usernameString appendString:[[UserSession sharedSession] userUsername]];
    [_usernameTextView setText:usernameString];
    [_bioTextView setText:[[UserSession sharedSession] userBio]];
}

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

-(void)editInfoButtonPressed
{
    [self performSegueWithIdentifier:@"EditInfoSegue" sender:self];
}


@end
