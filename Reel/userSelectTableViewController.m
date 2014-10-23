//
//  UserSelectTableViewController.m
//  Reel
//
//  Created by Jason Arias on 10/23/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ReelRailsAFNClient.h"
#import "UserSelectTableViewController.h"
#import "UserSelectionTableViewCell.h"
#import "User.h"
#import "UserSession.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import "UIColor+ColorExtensions.h"


@interface UserSelectTableViewController ()
@property(strong, nonatomic) NSMutableArray *followedUsersArray;
@property(strong, nonatomic) NSMutableArray *selectedUsersArray;
@property(weak, nonatomic) NSString *cellIdentifier;
@property (weak, nonatomic) IBOutlet UIButton *xButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@end

@implementation UserSelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    [self formatTopButtons];
    _selectedUsersArray  = [[NSMutableArray alloc] init];
    _followedUsersArray = [[ReelRailsAFNClient sharedClient]
                           getFollowedUsersForUserWithParameters:@{@"userId":[[UserSession sharedSession] userId]}
                                                             CompletionBlock:^(NSError *error) {
                                                                 if(!error){
                                                                     [[self tableView] reloadData];
                                                                  }
                                                             }];
    _cellIdentifier = @"userCell";
    [SVProgressHUD dismiss];
}

-(void)formatTopButtons
{
    _xButton.layer.cornerRadius = _xButton.layer.bounds.size.height/2;
    _checkButton.layer.cornerRadius = _checkButton.layer.bounds.size.height/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = [indexPath row];
    UserSelectionTableViewCell *cell = [tableView
                               dequeueReusableCellWithIdentifier:_cellIdentifier
                               forIndexPath:indexPath];
    NSString *name = _followedUsersArray[row][@"name"];
    [cell.nameTextView setText:name];
    NSString *username = _followedUsersArray[row][@"username"];
    [cell.usernameTextView setText:[ProfileTableViewController formatUserName:username]];
    
    cell.selectedButton.layer.cornerRadius = cell.selectedButton.layer.bounds.size.height/2;
    cell.selectedButton.layer.borderWidth = 2.0;
    cell.selectedButton.layer.borderColor = [UIColor appBlueColor].CGColor;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    numberOfRows = [_followedUsersArray count];
    NSLog(@"%li", (long)numberOfRows);
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79.0f;
}

-(User*)getUserAtRow:(long)row
{
    User *user = [[User alloc] init];
    [user setUserId:_followedUsersArray[row][@"id"]];
    [user setUserName:_followedUsersArray[row][@"name"]];
    [user setUserUsername:_followedUsersArray[row][@"username"]];
    [user setUserEmail:_followedUsersArray[row][@"email"]];
    [user setUserBio:_followedUsersArray[row][@"bio"]];
    return user;
}


- (IBAction)xButtonTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)checkButtonTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)selectButtonTouchUpInside:(id)sender {
    UserSelectionTableViewCell *cell = (UserSelectionTableViewCell*) [[sender superview] superview];
    NSLog(@"%@", cell);
    NSLog(@"%@", [[sender superview] superview].class);
    NSLog(@"%d", [cell cellPicked]);
    if(![cell cellPicked])
    {
        cell.selectedButton.layer.backgroundColor = [UIColor appBlueColor].CGColor;
    }else{
        cell.selectedButton.layer.backgroundColor = [UIColor appTanColor].CGColor;
    }

}



@end
