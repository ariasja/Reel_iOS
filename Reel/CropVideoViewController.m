//
//  CropVideoViewController.m
//  Reel
//
//  Created by Jason Arias on 10/21/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "CropVideoViewController.h"
#import "ThumbnailSelectorViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LayerState){
    LayerStateResting,
    LayerStatePickedUp,
};

@interface CropVideoViewController ()
@property (nonatomic , strong) CALayer *trimLayer;

@property (nonatomic, assign) LayerState currentLayerState;
@property (nonatomic, assign) CGPoint oldPoint;

@property(nonatomic) AVMutableVideoComposition *mutableComposition;
@property(nonatomic) AVMutableVideoCompositionLayerInstruction *layerInstruction;

@end

@implementation CropVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *nextButton =
    [[UIBarButtonItem alloc] initWithTitle:@"crop it" style:UIBarButtonItemStylePlain target:self action:@selector(cropButtonPressed)];
    [nextButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:18], NSFontAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    [[self navigationItem] setRightBarButtonItem:nextButton];
    
    _trimLayer = [CALayer layer];
    _trimLayer.frame = CGRectMake(self.playerView.bounds.origin.x, self.playerView.bounds.origin.y, self.width, self.width);
    _trimLayer.backgroundColor = [UIColor clearColor].CGColor;
    _trimLayer.borderColor = [UIColor whiteColor].CGColor;
    _trimLayer.borderWidth = 5;
    [self.view.layer addSublayer:_trimLayer];
    
    AVAsset *asset = [AVAsset assetWithURL:self.videoURL];
    _mutableComposition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:asset];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self play:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.player pause];
}

-(void)cropButtonPressed
{
    [self cropVideo];
    [self performSegueWithIdentifier:@"SegueToThumbnailSelectorViewController" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SegueToThumbnailSelectorViewController"]) {
        ThumbnailSelectorViewController *destViewController = segue.destinationViewController;
        [destViewController setVideoURL:self.videoURL];

    }
}

-(void)cropVideo
{
    AVAsset *asset = [AVURLAsset assetWithURL:self.videoURL];
    AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    AVAssetTrack *audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    
    NSError *error;
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    ///Video Track
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    error = nil;
    [videoCompositionTrack insertTimeRange:videoTrack.timeRange ofTrack:videoTrack atTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) error:&error];
    NSLog(@"videoCompositionTrack timeRange: %lld, %lld", videoCompositionTrack.timeRange.start.value, videoCompositionTrack.timeRange.duration.value);
    if(error)
        NSLog(@"videoCompositionTrack error: %@", error);
    
    ///Audio Track
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    error = nil;
    [audioCompositionTrack insertTimeRange:audioTrack.timeRange ofTrack:audioTrack atTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) error:&error];
    NSLog(@"audioCompositionTrack timeRange: %lld, %lld", audioCompositionTrack.timeRange.start.value, audioCompositionTrack.timeRange.duration.value);
    if(error)
        NSLog(@"audioCompositionTrack error: %@", error);

    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderScale = 1.0;
    videoComposition.renderSize = videoTrack.naturalSize;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVMutableVideoCompositionLayerInstruction *instruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [instruction setCropRectangle:_trimLayer.frame atTime:kCMTimeZero];
    videoComposition.instructions = [NSArray arrayWithObjects:instruction, nil];
    
    //  Create export session with composition
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPreset960x540];
    exportSession.outputURL = self.videoURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.videoComposition = videoComposition;
    exportSession.shouldOptimizeForNetworkUse = YES;
    CMTimeRange range = CMTimeRangeMake(videoCompositionTrack.timeRange.start, videoCompositionTrack.timeRange.duration);
    exportSession.timeRange = range;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch ([exportSession status]) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                break;
            default:
                NSLog(@"Cropping Completed");
                dispatch_async(dispatch_get_main_queue(), ^{});
                break;
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location =  [touch locationInView:self.view];
    self.oldPoint = location;
    if(CGRectContainsPoint(self.trimLayer.frame, location))
    {
        self.currentLayerState = LayerStatePickedUp;
        [CATransaction begin];
        [CATransaction setAnimationDuration:.5f];
        [CATransaction commit];
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = 5.f;
        animationGroup.repeatCount = 1000000;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(self.currentLayerState == LayerStatePickedUp)
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:.5f];
        [CATransaction commit];
    }
    self.currentLayerState = LayerStateResting;
    [self.trimLayer removeAllAnimations];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    CGPoint framePointPosition = self.trimLayer.position;
    NSLog(@"%f", framePointPosition.y);
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    CGFloat newYPosition = framePointPosition.y + (location.y - self.oldPoint.y);
    
    if(newYPosition < self.width/2 || newYPosition > self.height - self.width/2) {
        
    } else if((self.currentLayerState == LayerStatePickedUp) && CGRectContainsPoint(self.trimLayer.frame, location)){
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.f];
        self.trimLayer.position =  CGPointMake(framePointPosition.x, newYPosition);
        [CATransaction commit];
        self.oldPoint = location;
    }
}


@end
