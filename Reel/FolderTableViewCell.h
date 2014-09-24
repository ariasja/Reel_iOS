//
//  ProfileFolderTableViewCell.h
//  Reel
//
//  Created by Jason Arias on 9/15/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (strong, nonatomic) NSNumber *folderId;

@end
