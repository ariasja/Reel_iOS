//
//  PlayerView.m
//  Reel
//
//  Created by Jason Arias on 10/17/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "PlayerView.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView()
@property (nonatomic) AVPlayer *player;
@end

@implementation PlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer*)player
{
    return [(AVPlayerLayer *) [self layer] player];
}

- (void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)self.layer setPlayer:player];
}
@end
