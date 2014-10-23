//
//  UserSignInSignUpTableViewController.m
//  Reel
//
//  Created by Jason Arias on 9/21/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ReelRailsAFNClient.h"
#import "SignInTableViewCell.h"
#import "SignUpTableViewCell.h"
#import "UIColor+ColorExtensions.h"
#import "UserSession.h"
#import "UserSignInSignUpTableViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <SVProgressHUD/SVProgressHUD.h>



@interface UserSignInSignUpTableViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *signInSignUpSegmentedControl;

@property (weak, nonatomic) IBOutlet UITableViewCell *signInTableViewCell;
@property (weak, nonatomic) IBOutlet UITextField *signInEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *signInPasswordTextField;

@property (weak, nonatomic) IBOutlet UITableViewCell *signUpTableViewCell;
@property (weak, nonatomic) IBOutlet UITextField *signUpNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *signUpUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *signUpEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *signUpPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *signUpPasswordConfirmationTextField;
@property (weak, nonatomic) IBOutlet UILabel *rLabel;
@property (weak, nonatomic) IBOutlet UILabel *eLabel1;
@property (weak, nonatomic) IBOutlet UILabel *eLabel2;
@property (weak, nonatomic) IBOutlet UILabel *lLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInSignUpButton;
@end

@implementation UserSignInSignUpTableViewController

- (IBAction)signInSignUpSegmentToggled:(id)sender {
    [self.tableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat cornerRadius = 27.5f;
    BOOL masksToBounds = YES;
    _rLabel.layer.cornerRadius = cornerRadius;
    _eLabel1.layer.cornerRadius = cornerRadius;
    _eLabel2.layer.cornerRadius = cornerRadius;
    _lLabel.layer.cornerRadius = cornerRadius;
    _rLabel.layer.masksToBounds = masksToBounds;
    _eLabel1.layer.masksToBounds = masksToBounds;
    _eLabel2.layer.masksToBounds = masksToBounds;
    _lLabel.layer.masksToBounds = masksToBounds;
    
    _signInSignUpButton.layer.cornerRadius = 23.0f;

    //[_reelTextView setTransform:CGAffineTransformMakeRotation(90* M_PI/180)];
    //[self.tableView setBackgroundView:nil];
    //[self.tableView setBackgroundView:[[UIView alloc] init]];
    //[self.tableView setBackgroundColor:[UIColor tealColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([[UserSession sharedSession] sessionActive])
        [self performSegueWithIdentifier:@"SignInSignUpSegue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", indexPath);
    if([self signInSelected]){
        [_signInSignUpButton setTitle:@"in" forState:UIControlStateNormal];
    } else { //signUpSelected
        [_signInSignUpButton setTitle:@"up" forState:UIControlStateNormal];
    }
    switch (indexPath.row) {
        case 0:
            return 134.0f;
            break;
        case 1:
            return 100.0f;
            break;
        case 2:
            return 16.0f;
            break;
        case 3:
            if([self signInSelected]){
                [_signInEmailTextField setHidden:NO];
                [_signInPasswordTextField setHidden:NO];
                return 83.0f;
            }else{
                [_signInEmailTextField setHidden:YES];
                [_signInPasswordTextField setHidden:YES];
                return 0.0f;
            }
        case 4:
            if([self signUpSelected]){
                [_signUpEmailTextField setHidden:NO];
                [_signUpNameTextField setHidden:NO];
                [_signUpUsernameTextField setHidden:NO];
                [_signUpPasswordTextField setHidden:NO];
                [_signUpPasswordConfirmationTextField setHidden:NO];
                return 203.0f;
            }else{
                [_signUpEmailTextField setHidden:YES];
                [_signUpNameTextField setHidden:YES];
                [_signUpUsernameTextField setHidden:YES];
                [_signUpPasswordTextField setHidden:YES];
                [_signUpPasswordConfirmationTextField setHidden:YES];
                return 0.0f;
            }
        case 5:
            if([self signUpSelected]){
                return 0.0f;
            }else{
                return 120.0f;
            }
            break;
        case 6:
            return 59.0f;
            break;
        case 7:
            return 200.0f;
            break;
        default:
            return 0.0f;
            break;
    }
       return 0.0f;
}

-(BOOL)signInSelected
{
    return _signInSignUpSegmentedControl.selectedSegmentIndex == 0;
}
-(BOOL)signUpSelected
{
    return _signInSignUpSegmentedControl.selectedSegmentIndex == 1;

}
- (IBAction)signInSignUpBottonTouchUpInside:(id)sender {
    if([self signInSelected]){
        [self signIn];

    } else if([self signUpSelected]){
        [self signUp];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bad things happened"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)signIn{
    [SVProgressHUD show];
    [UserSession sharedSession];
    
    [[ReelRailsAFNClient sharedClient] createSessionWithParameters:@{@"email":_signInEmailTextField.text,
                                                                     @"password":_signInPasswordTextField.text}
                                                   CompletionBlock:^(NSError *error){
                                                       if([[UserSession sharedSession] sessionActive]){
                                                       [[UserSession sharedSession] updateUserFoldersWithArray:
                                                        [[ReelRailsAFNClient sharedClient]
                                                         getFoldersForUserWithId:@{@"userId":[[UserSession sharedSession] userId]}
                                                                             CompletionBlock:^(NSError *error) {
                                                                                    [[UserSession sharedSession]
                                                                                     updateUserPostsWithArray:
                                                                                        [[ReelRailsAFNClient sharedClient] getPostsForUserWithId:@{@"userId":[[UserSession sharedSession] userId]}
                                                                                        CompletionBlock:^(NSError *error) {
                                                                                            [self segueToApp];
                                                                                            [SVProgressHUD dismiss];
                                                                                        }]];
                                                                            }]];
                                                       }else{
                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Session Not Created"
                                                                                                           message:@""
                                                                                                          delegate:nil
                                                                                                 cancelButtonTitle:@"OK"
                                                                                                 otherButtonTitles:nil];
                                                           [alert show];
                                                           [SVProgressHUD dismiss];
                                                       }
                                                   }];
}

-(void)signUp{
    
    [SVProgressHUD show];
    
    NSDictionary *userParams = @{@"name":_signUpNameTextField.text,
                                 @"username":_signUpUsernameTextField.text,
                                 @"email": _signUpEmailTextField.text,
                                 @"bio":@"",
                                 @"password": _signUpPasswordTextField.text,
                                 @"password_confirmation": _signUpPasswordConfirmationTextField.text};
    [[ReelRailsAFNClient sharedClient]
     createCurrentUserWithParameters:userParams
     CompletionBlock:^(NSError *error){
         if([[ReelRailsAFNClient sharedClient] userCreateSuccess]){
             [[ReelRailsAFNClient sharedClient]
              createSessionWithParameters:@{@"email":_signUpEmailTextField.text,
                                            @"password":_signUpPasswordTextField.text}
              CompletionBlock:^(NSError *error){
                  if([[ReelRailsAFNClient sharedClient] sessionCreateSuccess]){
                      [[UserSession sharedSession] updateUserFoldersWithArray:(NSMutableArray*)@[]];
                      [[UserSession sharedSession] updateUserPostsWithArray:(NSMutableArray*)@[]];
                      [self segueToApp];
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

-(void)segueToApp
{
    [self performSegueWithIdentifier:@"SignInSignUpSegue" sender:self];
}


-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder];
}

@end
