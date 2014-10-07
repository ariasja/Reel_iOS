//
//  UserTableViewCell.h
//  Reel
//
//  Created by Jason Arias on 9/25/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *usernameTextView;
@property (strong, nonatomic) NSNumber* userId;

@end
