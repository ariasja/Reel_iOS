//
//  ProfileFoldersTableViewController.m
//  Reel
//
//  Created by Jason Arias on 9/16/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ProfileFoldersTableViewController.h"
#import "PostTableViewCell.h"
#import "UserSession.h"
#import "ReelRailsAFNClient.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface ProfileFoldersTableViewController ()
@end

@implementation ProfileFoldersTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD show];
    [self setFolderPosts:[[ReelRailsAFNClient sharedClient] getPostsForFolderWithId:@{@"folder_id":_folderId}
                                                                  CompletionBlock:^(NSError *error) {
                                                                      [[self tableView] reloadData];
                                                                      [SVProgressHUD dismiss];

                                                                  }]];
    [[self folderLabelTextView] setText:_folderTitle];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@", _folderId);
    NSLog(@"%@", _folderPosts);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", _folderPosts);
    NSString* cellIdentifier = @"postTableCell";
    long row = [indexPath row];
    PostTableViewCell *cell = [tableView
                                  dequeueReusableCellWithIdentifier:cellIdentifier
                                  forIndexPath:indexPath];
    NSString *caption = _folderPosts[row][@"caption"];
    [cell.captionTextView setText:caption];
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
    numberOfRows = [_folderPosts count];
    NSLog(@"%li", (long)numberOfRows);
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79.0f;
}


@end
