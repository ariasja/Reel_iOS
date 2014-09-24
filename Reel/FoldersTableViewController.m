//
//  FoldersTableViewController.m
//  Reel
//
//  Created by Jason Arias on 9/22/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "AddPostViewController.h"
#import "FoldersTableViewController.h"
#import "FolderTableViewCell.h"
#import "UserSession.h"
#import "ReelRailsAFNClient.h"

#import <QuartzCore/QuartzCore.h>




@interface FoldersTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *plusReelButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@end

@implementation FoldersTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [_plusReelButton.layer setCornerRadius:10.0f];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}


-(IBAction)folderButtonTouchedUpInside:(id)sender
{
    AddPostViewController* vc = [(UINavigationController*) [(UITabBarController*) [self presentingViewController] selectedViewController] childViewControllers][0];
    FolderTableViewCell *cell = (FolderTableViewCell*) [[sender superview] superview];
    NSLog(@"%@", vc.class);
    NSLog(@"%@", cell.class);
    NSMutableString *title = [[NSMutableString alloc] initWithString:@" "];
    [title appendString:[[cell titleButton] titleForState:UIControlStateNormal]];
    NSLog(@"%@", title);
    NSLog(@"%@", [cell folderId]);
    
    [vc reformatAddToReelButtonForFolderWithTitle:title
                                         folderId:[cell folderId]];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)backButtonTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"folderTableCell";
    
    long row = [indexPath row];
    // Configure the cell...
    FolderTableViewCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:CellIdentifier
                                        forIndexPath:indexPath];
    NSArray *folderArray = [[NSArray alloc] initWithArray:[[UserSession sharedSession] userFolders]];
    [cell.titleButton setTitle:folderArray[row][@"title"] forState:UIControlStateNormal];
    cell.folderId = folderArray[row][@"id"];
    return cell;


}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [[[UserSession sharedSession] userFolders] count];
    NSLog(@"%li", (long)numberOfRows);
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79.0f;
}

@end