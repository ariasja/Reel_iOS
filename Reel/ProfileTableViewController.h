//
//  AbstractProfileTableViewController.h
//  Reel
//
//  Created by Jason Arias on 10/6/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  ProfileTableViewController : UITableViewController

@property ( nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userUsername;
@property (strong, nonatomic) NSString *userBio;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSMutableArray *userFolders;
@property (strong, nonatomic) NSMutableArray *userPosts;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *usernameTextView;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

+(NSString*)formatUserName:(NSString*)unformattedUserName;


@end
