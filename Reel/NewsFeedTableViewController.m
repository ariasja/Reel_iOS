//
//  NewsFeedTableViewController.m
//  Reel
//
//  Created by Jason Arias on 10/7/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "ReelRailsAFNClient.h"
#import "PostTableViewCell.h"
#import "UserSession.h"

#import <SVProgressHUD/SVProgressHUD.h>


@interface NewsFeedTableViewController ()
@property (weak, nonatomic) IBOutlet UITextView *reelTextView;
@property (strong, nonatomic) NSMutableArray *feedArray;
@end

@implementation NewsFeedTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_reelTextView.layer setCornerRadius:20.0f];
    [SVProgressHUD show];
    _feedArray = [[ReelRailsAFNClient sharedClient] getFeedItemsForUserWithId:@{@"user_id": [[UserSession sharedSession] userId]}
            CompletionBlock:^(NSError *error) {
                if(!error){
                    [[self tableView] reloadData];
                    [SVProgressHUD dismiss];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cant GET News Feed Posts"
                                                                    message:@""
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [SVProgressHUD dismiss];
                    [alert show];
                    
                }
            }];
}

////////// UITableView Delegate Stuff //////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"postTableCell";
    long row = [indexPath row];
    
    PostTableViewCell *cell = (PostTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell captionTextView] setText:_feedArray[row][@"caption"]];
    NSLog(@"%@",_feedArray[row][@"caption"]);
    
    return cell;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number =(NSInteger) [_feedArray count];
    NSLog(@"%ld", (long) number);
    return number;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79.0f;
}

@end
