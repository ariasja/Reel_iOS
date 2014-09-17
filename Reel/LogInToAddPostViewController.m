//
//  LogInToAddPostViewController.m
//  Reel
//
//  Created by Jason Arias on 9/16/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "LogInToAddPostViewController.h"
#import "UserSession.h"

@implementation LogInToAddPostViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    if([[UserSession sharedSession] sessionActive]){
        [self performSegueWithIdentifier:@"SegueToAddPostViewController" sender:self];
    }
}

@end
