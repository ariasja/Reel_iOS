//
//  ProfileFoldersTableViewController.h
//  Reel
//
//  Created by Jason Arias on 9/16/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileFoldersTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextView *folderLabelTextView;
@property (strong, nonatomic) NSString* folderTitle;
@property (strong, nonatomic) NSNumber* folderId;
@property (strong, nonatomic) NSMutableArray* folderPosts;

@end
