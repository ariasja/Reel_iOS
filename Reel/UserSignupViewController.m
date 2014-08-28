//
//  UserSignupViewController.m
//  Reel
//
//  Created by Jason Arias on 8/25/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ReelRailsAFNClient.h"
#import "UserSession.h"
#import "UserSignupViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>


@interface UserSignupViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation UserSignupViewController

- (void)viewDidLoad
{
    NSLog(@"[UserSignupViewController viewDidLoad]");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)signUpButtonTouchUpInside:(id)sender {
    NSLog(@"[UserSignupViewController signUpButtonTouchUpInside] (1)");
    
    NSString *userID = [UserSession userID];
    if (!userID) {
        NSLog(@"[UserSignupViewController signUpButtonTouchUpInside] (2)");
        [SVProgressHUD show];
        [[ReelRailsAFNClient sharedClient] createCurrentUserWithCompletionBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
    }
    
}


@end
