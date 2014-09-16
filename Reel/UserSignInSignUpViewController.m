//
//  SignInSignUpViewController.m
//  Reel
//
//  Created by Jason Arias on 8/28/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "UserSigninViewController.h"
#import "User.h"
#import "UserSession.h"
#import "UserSignInSignUpViewController.h"

@interface UserSignInSignUpViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation UserSignInSignUpViewController

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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    //[self.navigationController.navigationBar setHidden:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[self.navigationController.navigationBar setHidden:YES];

}

- (IBAction)signInButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"SignInButtonPressedSegue" sender:self];
    
}
- (IBAction)signUpButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"SignUpButtonPressedSegue" sender:self];
}

@end
