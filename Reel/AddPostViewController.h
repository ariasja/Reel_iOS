//
//  AddPostTableViewController.h
//  Reel
//
//  Created by Jason Arias on 8/1/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AddPostViewController : UITableViewController <CLLocationManagerDelegate>

@property(weak, nonatomic)NSURL *videoURL;
@property(strong, nonatomic) id thumbnailImage;

-(void)reformatAddToReelButtonForFolderWithTitle:(NSString*)title
                                        folderId:(NSNumber*)folderId;
@end
