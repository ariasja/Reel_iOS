//
//  UserSessionNavigationControllerViewController.m
//  Reel
//
//  Created by Jason Arias on 8/30/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//


#import "CurrentUserProfileTableViewController.h"
#import "UserSignInSignUpViewController.h"
#import "UserSession.h"
#import "UserSessionNavigationController.h"

@interface UserSessionNavigationController ()

@end

@implementation UserSessionNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL signedIn = [[UserSession sharedSession] sessionActive];
    if(signedIn){
        //[self performSegueWithIdentifier:@"SkipSignInSignUpSegue" sender:self];
    }
}

@end
