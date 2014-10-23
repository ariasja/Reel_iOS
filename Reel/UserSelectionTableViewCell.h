//
//  UserSelectionTableViewCell.h
//  Reel
//
//  Created by Jason Arias on 10/23/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "UserTableViewCell.h"

@interface UserSelectionTableViewCell : UserTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (nonatomic, assign) BOOL cellPicked;

@end
