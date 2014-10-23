//
//  RecordVideoViewController.m
//  Reel
//
//  Created by Jason Arias on 10/12/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "RecordVideoViewController.h"
#import "ThumbnailSelectorViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>


@interface RecordVideoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *rotateCameraButton;

@property (strong, nonatomic) NSArray *circleArray;
@property (weak, nonatomic) IBOutlet UILabel *circle1;
@property (weak, nonatomic) IBOutlet UILabel *circle2;
@property (weak, nonatomic) IBOutlet UILabel *circle3;
@property (weak, nonatomic) IBOutlet UILabel *circle4;
@property (weak, nonatomic) IBOutlet UILabel *circle5;
@property (weak, nonatomic) IBOutlet UILabel *circle6;
@property (weak, nonatomic) IBOutlet UILabel *circle7;
@property (weak, nonatomic) IBOutlet UILabel *circle8;

@property (nonatomic) BOOL animate;


@end

@implementation RecordVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _circleArray = [[NSArray alloc] initWithObjects:_circle1, _circle2, _circle3, _circle4, _circle5, _circle6, _circle7, _circle8, nil];
    
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[[self navigationController] navigationBar] setShadowImage:[UIImage new]];
    [[[self navigationController] navigationBar] setTranslucent:YES];

    _rotateCameraButton.layer.cornerRadius = 18.0f;
    UIBarButtonItem *backButton =
    [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    UIView *view = [self view];
    // Video and Audio Session
    _session = [[RecordVideoSession alloc] init];
    [self formatCircles:_circleArray];
    
    // Video Preview Layer
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _videoPreviewLayer.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height, CGRectGetWidth(view.bounds), CGRectGetWidth(view.bounds));
    
    
    [view.layer addSublayer:_videoPreviewLayer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

-(void)formatCircles:(NSArray*)circleArray
{
    CGFloat radius = 15;
    BOOL masksToBounds = YES;
    _recordButton.layer.cornerRadius = 39;
    for(int i=0; i<[circleArray count]; ++i) {
        ((UILabel*)circleArray[i]).layer.cornerRadius = radius;
        ((UILabel*)circleArray[i]).layer.masksToBounds = masksToBounds;

        ((UILabel*)circleArray[i]).alpha = 0.0;
    }
}

- (IBAction)recordButtonTouchDown:(id)sender {
    NSLog(@"Touch Down");
    
    //Set the file save to URL
    NSString *DestFilename = @ "reelVideo.mov";
    NSString *DestPath;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DestPath = [paths objectAtIndex:0];
    DestPath = [DestPath stringByAppendingPathComponent:DestFilename];
    
    _saveLocationURL = [[NSURL alloc] initFileURLWithPath:DestPath];
    NSLog(@"%@", _saveLocationURL);
    [self startAnimation];
    [_session startRecordingToFileWithURL:_saveLocationURL];

}

- (IBAction)recordButtonTouchUpInside:(id)sender {
    NSLog(@"Touch Up");
    [_session stopRecording];
    [self stopAnimation];
    [SVProgressHUD show];
    [self cropVideoToSquare];
}

- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position
{
    NSArray *Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *Device in Devices)
    {
        if ([Device position] == Position)
        {
            return Device;
        }
    }
    return nil;
}

- (IBAction)CameraToggleButtonPressed:(id)sender
{
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1)		//Only do if device has multiple cameras
    {
        NSLog(@"Toggle camera");
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[[_session videoInput] device] position];
        if (position == AVCaptureDevicePositionBack)
        {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        }
        else if (position == AVCaptureDevicePositionFront)
        {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionBack] error:&error];
        }
        
        if (newVideoInput != nil)
        {
            [_session beginConfiguration];		//We can now change the inputs and output configuration.  Use commitConfiguration to end
            [_session removeInput:[_session videoInput]];
            if ([_session canAddInput:newVideoInput])
            {
                [_session addInput:newVideoInput];
                [_session setVideoInput:newVideoInput];
            }
            else
            {
                [_session addInput:[_session videoInput]];
            }
            [_session commitConfiguration];
        }
    }
}

-(void)startAnimation
{
    _animate = YES;
    [self animateCircleArray:_circleArray];
}

-(void)stopAnimation
{
    _animate = NO;
}

-(void)animateCircleArray:(NSArray*)circleArray
{
    if([circleArray count] > 0 && _animate){
        [UIView animateWithDuration:0.5 animations:^{
            ((UITextField*)circleArray[0]).alpha = 1.0;
        }];
        NSRange range;
        
        range.location = 1;
        range.length = [circleArray count] -1;
        NSArray *newArray = [circleArray subarrayWithRange:range];
        [self performSelector:@selector(animateCircleArray:) withObject:newArray afterDelay:.5];
    }
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"finishedRecordingSegue"]) {
        ThumbnailSelectorViewController *destViewController = segue.destinationViewController;
        [destViewController setVideoURL:_croppedVideoURL];
        NSLog(@"%@", _croppedVideoURL);
    }
}

-(void)cropVideoToSquare
{
    // output file
    NSString* docFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* outputPath = [docFolder stringByAppendingPathComponent:@"reelVideoCropped.mov"];
    _croppedVideoURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSLog(@"%@", _croppedVideoURL);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath])
        [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    
    //inputFile
    AVAsset* asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:[_saveLocationURL path]]];    
    AVMutableComposition *composition = [AVMutableComposition composition];
    [composition  addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // input clip
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    // make square
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.height);
    videoComposition.frameDuration = CMTimeMake(1, 100);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );
    
    //rotate to portrait.
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) /2 );
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
    
    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    //export clip
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL=[NSURL fileURLWithPath:outputPath];
    exporter.outputFileType=AVFileTypeQuickTimeMovie;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
        NSLog(@"Exporting done!");
        [self performSegueWithIdentifier:@"finishedRecordingSegue" sender:self];
    }];
}

@end
