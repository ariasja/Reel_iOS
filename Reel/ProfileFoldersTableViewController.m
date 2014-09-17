//
//  ProfileFoldersTableViewController.m
//  Reel
//
//  Created by Jason Arias on 9/16/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ProfileFoldersTableViewController.h"
#import "ProfileTableViewCell.h"
#import "UserSession.h"
#import "ReelRailsAFNClient.h"

@interface ProfileFoldersTableViewController ()
@property (strong, nonatomic) NSMutableArray* folderPosts;
@property (strong, nonatomic) NSNumber* folderId;
@end

@implementation ProfileFoldersTableViewController

-(instancetype)initWIthFolderId:folderId
{
    self = [super init];
    if(!self)
        return nil;
    [self setFolderId:folderId];
    [self setFolderPosts:[[NSMutableArray alloc] init]];
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _folderPosts = [[ReelRailsAFNClient sharedClient] getPostsForFolderWithId:@{@"folderId": _folderId}
                                                              CompletionBlock:^(NSError *error) {
                                                                  //code
                                                              }];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"profileTableCell";
    long row = [indexPath row];
    ProfileTableViewCell *cell = [tableView
                                  dequeueReusableCellWithIdentifier:cellIdentifier
                                  forIndexPath:indexPath];
    NSArray *postArray = [[NSArray alloc] initWithArray:_folderPosts];
    cell.captionTextView.text = postArray[row][@"caption"];
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
    NSLog(@"%li", (long)numberOfRows);
    return numberOfRows;
}

///////// Segmented Control /////////

-(void)segmentedControlTouched
{
    NSLog(@"touch");
    [self.tableView reloadData];
    
}


@end
