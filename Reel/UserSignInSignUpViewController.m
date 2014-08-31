//
//  SignInSignUpViewController.m
//  Reel
//
//  Created by Jason Arias on 8/28/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

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
    User* user = [[User alloc] init];
    if([UserSession userMatchesCurrentUserSession:user])
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

@end
