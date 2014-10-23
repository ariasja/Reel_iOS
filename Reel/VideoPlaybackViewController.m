//
//  VideoPlaybackAndEditViewController.m
//  Reel
//
//  Created by Jason Arias on 10/17/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "VideoPlaybackViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface VideoPlaybackViewController ()

@end

@implementation VideoPlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = self.view;
    
    UIBarButtonItem *backButton =
    [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    _width = self.view.bounds.size.width;
    _height = self.view.bounds.size.height;
    
    _urlAsset = [[AVURLAsset alloc] initWithURL:_videoURL options:nil];
    _playerItem = [[AVPlayerItem alloc] initWithAsset:_urlAsset];
    _player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
    _playerView = [[PlayerView alloc] init];
    _playerView.layer.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, CGRectGetWidth(view.bounds), CGRectGetWidth(view.bounds));
    [_playerView setPlayer: _player];
    [self.view.layer addSublayer:_playerView.layer];
}

- (IBAction)play:sender {
    [_player play];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playerItemDidReachEnd:)
     name:AVPlayerItemDidPlayToEndTimeNotification
     object:[self.player currentItem]];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}








@end
