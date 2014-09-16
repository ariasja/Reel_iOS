//
//  EditInfoViewController.m
//  Reel
//
//  Created by Jason Arias on 9/7/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "EditInfoViewController.h"
#import "ReelRailsAFNClient.h"
#import "UserSession.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface EditInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *editNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *editUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *editEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *editBioTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@end

@implementation EditInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_editNameTextField setText:[[UserSession sharedSession] userName]];
    [_editUsernameTextField setText:[[UserSession sharedSession] userUsername]];
    [_editEmailTextField setText:[[UserSession sharedSession] userEmail]];
    [_editBioTextField setText:[[UserSession sharedSession] userBio]];
}

- (IBAction)doneButtonTouchUpInside:(id)sender {
    [SVProgressHUD show];
    NSDictionary *params = @{@"id": [[[UserSession sharedSession] userId] stringValue],
                             @"name": _editNameTextField.text,
                             @"username": _editUsernameTextField.text,
                             @"email": _editEmailTextField.text,
                             @"bio": _editBioTextField.text};
    [[ReelRailsAFNClient sharedClient] updateCurrentUserWithParameters:params CompletionBlock:^(NSError *error) {
        [self segueToProfileViewController];
        [SVProgressHUD dismiss];
    }];
    
}
- (IBAction)cancelButtonTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //code
    }];
}



-(void)segueToProfileViewController
{
    if([[ReelRailsAFNClient sharedClient] userUpdateSuccess]){
        [self dismissViewControllerAnimated:YES completion:^{
            //code
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Unsuccessful"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
