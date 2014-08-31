//
//  UserSignupProcessingViewController.m
//  Reel
//
//  Created by Jason Arias on 8/25/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "UserSignupProcessingViewController.h"

#import "UserSession.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ReelRailsAFNClient.h"

@interface UserSignupProcessingViewController ()

@end

@implementation UserSignupProcessingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[UserSignupViewController viewDidAppear] (1)");
    [super viewDidAppear:animated];
    
    NSNumber *userID = [UserSession userID];
    if ([userID.stringValue  isEqual: @"0"]) {
        NSLog(@"[UserSignupViewController viewDidAppear] (2)");
        [SVProgressHUD show];
        [[ReelRailsAFNClient sharedClient] createCurrentUserWithCompletionBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
    }
}
@end
