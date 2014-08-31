//
//  TabBarControllerViewController.m
//  Reel
//
//  Created by Jason Arias on 8/21/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

#import "ReelTabBarControllerViewController.h"
#import "ReelRailsAFNClient.h"
#import "UserSession.h"

@interface ReelTabBarControllerViewController ()

@end

@implementation ReelTabBarControllerViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![UserSession userID]) {
        [SVProgressHUD show];
        
        [[ReelRailsAFNClient sharedClient]
         createCurrentUserWithCompletionBlock:^(NSError *error) {
             [SVProgressHUD dismiss];
         }];
    }
}

@end
