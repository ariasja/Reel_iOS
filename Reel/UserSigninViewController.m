//
//  UserSigninViewController.m
//  Reel
//
//  Created by Jason Arias on 8/28/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ReelRailsAFNClient.h"
#import "UserSigninViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface UserSigninViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation UserSigninViewController

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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)signInButtonTouchUpInside:(id)sender
{
    [SVProgressHUD show];
    [[ReelRailsAFNClient sharedClient]
     createSessionWithParameters:@{@"email":_emailTextField.text,
                                   @"password":_passwordTextField.text}
     CompletionBlock:^(NSError *error){
         [SVProgressHUD dismiss];
     }];
}


@end
