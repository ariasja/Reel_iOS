//
//  ThumbnailSelectorViewController.m
//  Reel
//
//  Created by Jason Arias on 10/21/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "AddPostViewController.h"
#import "ThumbnailSelectorViewController.h"

@interface ThumbnailSelectorViewController ()
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) UIImage *thumbnail;

@end

@implementation ThumbnailSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _checkButton.layer.cornerRadius = 18.0f;
}


- (IBAction)sliderValueChanged:(id)sender {
    Float64 durationSeconds = CMTimeGetSeconds(self.player.currentItem.asset.duration);
    CMTime newTime = CMTimeMakeWithSeconds(_progressSlider.value * durationSeconds, 200);
    [self.player seekToTime:newTime];
}

- (IBAction)checkButtonTouchUpInside:(id)sender {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    NSError *err = NULL;
    Float64 durationSeconds = CMTimeGetSeconds(self.player.currentItem.asset.duration);
    CMTime time = CMTimeMakeWithSeconds(_progressSlider.value * durationSeconds, 200);
    
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    
    _thumbnail = [UIImage imageWithCGImage:imgRef];
    NSLog(@"Image: %@", _thumbnail);
    
    [self performSegueWithIdentifier:@"finishedThumbnailSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"finishedThumbnailSegue"])
    {
        AddPostViewController *destinationViewController = [segue destinationViewController];
        [destinationViewController setThumbnailImage:_thumbnail];
        [destinationViewController setVideoURL:self.videoURL];
    }
}

@end
