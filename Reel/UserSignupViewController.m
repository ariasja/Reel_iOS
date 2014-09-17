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

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmationTextField;

@end

@implementation UserSignupViewController

- (void)viewDidLoad
{
    NSLog(@"[UserSignupViewController viewDidLoad]");
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)signUpButtonTouchUpInside:(id)sender {
    
    [SVProgressHUD show];
    
    NSDictionary *userParams = @{@"name":_nameTextField.text,
                                    @"username":_usernameTextField.text,
                                    @"email": _emailTextField.text,
                                    @"bio":@" ",
                                    @"password": _passwordTextField.text,
                                    @"password_confirmation": _passwordConfirmationTextField.text};
    [[ReelRailsAFNClient sharedClient]
     createCurrentUserWithParameters:userParams
                     CompletionBlock:^(NSError *error){
                         if([[ReelRailsAFNClient sharedClient] userCreateSuccess]){
                             [[ReelRailsAFNClient sharedClient]
                              createSessionWithParameters:@{@"email":_emailTextField.text,
                                                            @"password":_passwordTextField.text}
                              CompletionBlock:^(NSError *error){
                                  if([[ReelRailsAFNClient sharedClient] sessionCreateSuccess]){
                                      [[UserSession sharedSession] updateUserFoldersWithArray:(NSMutableArray*)@[]];
                                      [[UserSession sharedSession] updateUserPostsWithArray:(NSMutableArray*)@[]];
                                      [self segueToProfile];
                                      [SVProgressHUD dismiss];
                                  }else{
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Session Create Unsuccessful"
                                                                                      message:@""
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles:nil];
                                      [SVProgressHUD dismiss];
                                      [alert show];
                                  }
                                  
                          }];
                         } else {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User Create Unsuccessful"
                                                                             message:@""
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                             [SVProgressHUD dismiss];
                             [alert show];
                         }
                     }];
    

}

-(void)segueToProfile
{
    [self performSegueWithIdentifier:@"SignUpButtonPressedToProfileSegue" sender:self];
}


@end
