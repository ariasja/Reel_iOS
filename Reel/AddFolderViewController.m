//
//  AddFolderViewController.m
//  Reel
//
//  Created by Jason Arias on 9/23/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "AddFolderViewController.h"
#import "FoldersTableViewController.h"
#import "ReelRailsAFNClient.h"
#import "UserSession.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface AddFolderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation AddFolderViewController

- (IBAction)doneButtonTouchUpInside:(id)sender {
    if([[_titleTextField text] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Folder Title Cannot Be Empty"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        [SVProgressHUD show];
        [[ReelRailsAFNClient sharedClient] createFolderWithParameters:@{@"user_id":[[UserSession sharedSession] userId],
                                                                    @"title" : [_titleTextField text]}
                                                      CompletionBlock:^(NSError *error) {
                                                          if(!error){
                                                              [SVProgressHUD dismiss];
                                                              [self dismissViewController];
                                                          }
                                                      }];
    }
}

-(void)dismissViewController
{
    FoldersTableViewController* vc = (FoldersTableViewController*) self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [[vc tableView] reloadData];
    }];

}

- (IBAction)cancelButtonTouchUpInside:(id)sender {
    [self dismissViewController];
}

-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder];
}

@end
