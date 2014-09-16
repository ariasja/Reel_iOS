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
@property (weak, nonatomic) IBOutlet UIButton *createFolderButton;

@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UITextField *hashTagTextField;
@property (weak, nonatomic) IBOutlet UITextField *atTagTextField;
@property (weak, nonatomic) IBOutlet UITextField *folderTextField;

@end


@implementation AddPostViewController


//viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)createFolderButtonTouchUpInside:(id)sender {
    [SVProgressHUD show];
    [[ReelRailsAFNClient sharedClient] createFolderWithParameters:@{@"user_id":[[UserSession sharedSession] sessionActive]
                                                                   ? [[[UserSession sharedSession] userId] stringValue] : @"99",
                                                                   @"title":_folderTextField.text}
                                                  CompletionBlock:^(NSError *error){
                                                      [SVProgressHUD dismiss];
                                                  }];
}

- (IBAction)addButtonTouchUpInside:(id)sender {
    [SVProgressHUD show];
    [[ReelRailsAFNClient sharedClient] createPostWithParameters:@{@"user_id":[[UserSession sharedSession] sessionActive]
                                                                  ? [[[UserSession sharedSession] userId] stringValue] : @"99",
                                                                  @"caption":_captionTextField.text,
                                                                  @"hashTag":_hashTagTextField.text,
                                                                  @"atTag":_atTagTextField.text}
                                                CompletionBlock:^(NSError *error) {

                                                    [SVProgressHUD dismiss];
                                                }];
}

-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder];
}

@end
