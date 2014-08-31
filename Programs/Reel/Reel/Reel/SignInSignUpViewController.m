//
//  SignInSignUpViewController.m
//  Reel
//
//  Created by Jason Arias on 8/28/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "SignInSignUpViewController.h"

@interface SignInSignUpViewController ()

@end

@implementation SignInSignUpViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

@end
