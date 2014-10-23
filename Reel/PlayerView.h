//
//  PlayerView.h
//  Reel
//
//  Created by Jason Arias on 10/17/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface PlayerView : UIView

+ (Class)layerClass;
- (AVPlayer*)player;
- (void)setPlayer:(AVPlayer *)player;

@end
