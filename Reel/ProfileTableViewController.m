//
//  AbstractProfileTableViewController.m
//  Reel
//
//  Created by Jason Arias on 10/6/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "FolderTableViewCell.h"
#import "PostTableViewCell.h"
#import "ProfileFoldersTableViewController.h"


@interface ProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *reelsOrAllSegmentedControl;


@end

@implementation ProfileTableViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
    [_reelsOrAllSegmentedControl addTarget:self
                                    action:@selector(segmentedControlTouched)
                          forControlEvents:UIControlEventValueChanged];
    
}

+(NSString*)formatUserName:(NSString*)unformattedUserName
{
    NSMutableString *formattedUsername = [[NSMutableString alloc] initWithString:@"@"];
    [formattedUsername appendString:unformattedUserName];
    return formattedUsername;
}


///////// UITableViewController Delegate /////////


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier0 = @"profileFolderTableCell";
    NSString *CellIdentifier1 = @"profileTableCell";
    
    long row = [indexPath row];
    // Configure the cell...
    if(_reelsOrAllSegmentedControl.selectedSegmentIndex == 0)
    {
        FolderTableViewCell *cell = [tableView
                                     dequeueReusableCellWithIdentifier:CellIdentifier0
                                     forIndexPath:indexPath];
        NSArray *folderArray = [[NSArray alloc] initWithArray:_userFolders];
        [cell.titleButton setTitle:folderArray[row][@"title"] forState:UIControlStateNormal];
        cell.folderId = folderArray[row][@"id"];
        return cell;
    } else if(_reelsOrAllSegmentedControl.selectedSegmentIndex == 1){
        PostTableViewCell *cell = [tableView
                                   dequeueReusableCellWithIdentifier:CellIdentifier1
                                   forIndexPath:indexPath];
        NSArray *postArray = [[NSArray alloc] initWithArray:_userPosts];
        cell.captionTextView.text = postArray[row][@"caption"];
        return cell;
    }
    
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if(_reelsOrAllSegmentedControl.selectedSegmentIndex == 0)
    {
        numberOfRows = [_userFolders count];
    } else if(_reelsOrAllSegmentedControl.selectedSegmentIndex == 1){
        numberOfRows = [_userPosts count];
    }
    NSLog(@"%li", (long)numberOfRows);
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79.0f;
}

///////// Segmented Control /////////
-(void)segmentedControlTouched
{
    NSLog(@"touch");
    [self.tableView reloadData];
    
}

///////// Segue /////////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"segueToFolderPosts"])
    {
        // Get reference to the destination view controller
        ProfileFoldersTableViewController *vc = [segue destinationViewController];
        FolderTableViewCell* cell = (FolderTableViewCell*)[[sender superview] superview];
        NSLog(@"%@", [cell class]);
        
        // Pass any objects to the view controller here, like...
        NSNumber *folderId = [cell folderId];
        NSString *folderTitle = [[cell titleButton] titleForState:UIControlStateNormal];
        [vc setFolderId:folderId];
        [vc setFolderTitle:folderTitle];
    }
}
- (IBAction)titleButtonTouchUpInside:(id)sender {
    NSLog(@"%@", [sender class]);
    [self performSegueWithIdentifier:@"segueToFolderPosts" sender:sender];
}

@end
