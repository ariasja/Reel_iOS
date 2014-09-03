//
//  AddPostTableViewController.m
//  Reel
//
//  Created by Jason Arias on 8/1/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "AddPostViewController.h"
#import "UIColor+ColorExtensions.h"
#import "AddPostConfirmationViewController.h"
#import "ReelRailsAFNClient.h"
#import "UserSession.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface AddPostViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addPostButton;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UITextField *hashTagTextField;
@property (weak, nonatomic) IBOutlet UITextField *atTagTextField;
@property (weak, nonatomic) IBOutlet UITextField *geoLocationTextField;

@end


@implementation AddPostViewController


//viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)addButtonTouchUpInside:(id)sender {
    [SVProgressHUD show];
    [[ReelRailsAFNClient sharedClient] createPostWithParameters:@{@"user_id":[[UserSession sharedSession] sessionActive]
                                                                  ? [[UserSession sharedSession] userId] : @"99",
                                                                  @"caption":_captionTextField.text,
                                                                  @"hasTag":_hashTagTextField.text,
                                                                  @"atTag":_atTagTextField.text,
                                                                  @"geo_lat":_geoLocationTextField.text,
                                                                  @"geo_long":_geoLocationTextField.text}
                                                CompletionBlock:^(NSError *error) {
                                                    [SVProgressHUD dismiss];
                                                }];
}

@end
