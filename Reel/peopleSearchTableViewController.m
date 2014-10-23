//
//  peopleSearchTableViewController.m
//  Reel
//
//  Created by Jason Arias on 9/24/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "PeopleSearchTableViewController.h"
#import "ReelRailsAFNClient.h"
#import "UserSession.h"
#import "UserTableViewCell.h"
#import "VisitUserProfileTableViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface PeopleSearchTableViewController ()<UITableViewDelegate, UITableViewDataSource> {}

@property (weak, nonatomic) IBOutlet UISegmentedControl *followingFollowersSegmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;

@end

@implementation PeopleSearchTableViewController

-(void)viewDidLoad
{
    [SVProgressHUD show];

    //All Users
    _usersArray = [[ReelRailsAFNClient sharedClient] getUsersWithCompletionBlock:^(NSError *error) {/*code*/}];
    //Users who current user is following
    _searchResults = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD show];
    NSNumber* userId = [[UserSession sharedSession] userId];
    _followedUsersArray = [[ReelRailsAFNClient sharedClient] getFollowedUsersForUserWithParameters:@{@"userId":userId}
                                                                                   CompletionBlock:^(NSError *error) {
                                                                                       if(!error){
                                                                                           [[self tableView] reloadData];
                                                                                       }
                                                                                   }];
    //Users following current user
    _followersArray = [[ReelRailsAFNClient sharedClient] getFollowersForUserWithParameters:@{@"userId":userId}
                                                                           CompletionBlock:^(NSError *error) {
                                                                               if(!error){
                                                                                   [[self tableView] reloadData];
                                                                                   NSLog(@"%@", _followersArray);
                                                                                   [SVProgressHUD dismiss];
                                                                               }
                                                                           }];
}

////////// Segmented Control
- (IBAction)signInSignUpSegmentToggled:(id)sender {
    NSLog(@"touch");
    [self.tableView reloadData];
}

- (NSInteger)segmentSelected
{
    NSLog(@"%d", (int)[_followingFollowersSegmentedControl selectedSegmentIndex]);
    return [_followingFollowersSegmentedControl selectedSegmentIndex];
}

////////// UITableDeligate Stuff //////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"userTableCell";
    long row = [indexPath row];
    
    UserTableViewCell *cell = (UserTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSMutableArray *userArray = [[NSMutableArray alloc] initWithArray:@[]];
    if(tableView == self.searchDisplayController.searchResultsTableView){
        userArray = [[NSMutableArray alloc] initWithArray:_searchResults];
    }else{
        if([self segmentSelected] == 0){
            userArray = _followedUsersArray;
        }else if([self segmentSelected] == 1){
            userArray = _followersArray;
        }
    }
    
    NSLog(@"%@", userArray[row][@"name"]);
    NSLog(@"%@", userArray[row][@"username"]);
    [[cell nameTextView]setText:userArray[row][@"name"]];
    NSMutableString* usernameString = [[NSMutableString alloc] initWithString:@"@"];
    [usernameString appendString:userArray[row][@"username"]];
    [[cell usernameTextView] setText:usernameString];
    [cell setUserId:userArray[row][@"id"]];
    
    return cell;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResults count];
    }else{
        if([self segmentSelected] == 0){
            return [_followedUsersArray count];
        }else if ([self segmentSelected] == 1){
            return [_followersArray count];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79.0f;
}

////////// Seach Bar stuff //////////
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(name contains[c] %@) || (username contains[c] %@)", searchText, searchText];
    _searchResults = [_usersArray filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

////////// Segue stuff //////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"visitUserProfileSegue"]) {
        NSIndexPath *indexPath = nil;
        
        NSNumber *userId = nil;
        NSString *userName = nil;
        NSString *userUsername = nil;
        NSString *userBio = nil;
        NSString *userEmail = nil;
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            userId = [_searchResults objectAtIndex:indexPath.row][@"id"];
            userName = [_searchResults objectAtIndex:indexPath.row][@"name"];
            userUsername = [_searchResults objectAtIndex:indexPath.row][@"username"];
            userBio = [_searchResults objectAtIndex:indexPath.row][@"bio"];
            userEmail = [_searchResults objectAtIndex:indexPath.row][@"email"];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            NSArray *array = [self segmentSelected] == 0 ? _followedUsersArray : _followersArray;
            userId = [array objectAtIndex:indexPath.row][@"id"];
            userName = [array objectAtIndex:indexPath.row][@"name"];
            userUsername = [array objectAtIndex:indexPath.row][@"username"];
            userBio = [array objectAtIndex:indexPath.row][@"bio"];
            userEmail = [array objectAtIndex:indexPath.row][@"email"];
        }
        
        VisitUserProfileTableViewController *destViewController = segue.destinationViewController;
        [destViewController setUserId:userId];
        [destViewController setUserName:userName];
        [destViewController setUserUsername:userUsername];
        [destViewController setUserBio:userBio];
        [destViewController setUserEmail:userEmail];
        [destViewController setFollowing:[self isCurrentUserFollowingUserWithId:userId]];
    }
}

-(BOOL) isCurrentUserFollowingUserWithId:(NSNumber*)userId
{
    for(int i = 0; i < [_followedUsersArray count]; ++i){
        if(_followedUsersArray[i][@"id"] == userId)
            return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", indexPath);
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self performSegueWithIdentifier:@"visitUserProfileSegue" sender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
