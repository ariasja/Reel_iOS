//
//  VideoPlaybackAndEditViewController.h
//  Reel
//
//  Created by Jason Arias on 10/17/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "PlayerView.h"

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@class PlayerView;
@interface VideoPlaybackViewController : UIViewController

@property (nonatomic) NSURL *videoURL;
@property (nonatomic) AVURLAsset *urlAsset;
@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayerItem *playerItem;
@property (nonatomic, strong) IBOutlet PlayerView *playerView;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

- (IBAction)play:sender;
@end
