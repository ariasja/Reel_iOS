//
//  ProfileFolderTableViewCell.m
//  Reel
//
//  Created by Jason Arias on 9/15/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "ProfileFolderTableViewCell.h"

@implementation ProfileFolderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonTouchUpInside:(id)sender {
    
}

@end
