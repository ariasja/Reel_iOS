//
//  ReelAddPostTableViewController.m
//  Reel
//
//  Created by Jason Arias on 8/1/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ReelAddPostTableViewController.h"


@interface ReelAddPostTableViewController ()

@end

@implementation ReelAddPostTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:ReelAddPostCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:ReelAddEventCellIdentifier
                             forIndexPath:indexPath];
    if (indexPath.row == 5)
        cell.textLabel.text = NSLocalizedString(@"Done", nil);
    return cell;
}


@end
