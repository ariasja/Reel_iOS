//
//  RecordVideoViewController.m
//  Reel
//
//  Created by Jason Arias on 10/9/14.
//  Copyright (c) 2014 Jason Arias. All rights reserved.
//

#import "RecordVideoSession.h"

@interface RecordVideoSession () <AVCaptureFileOutputRecordingDelegate>
@end

@implementation RecordVideoSession


-(instancetype)init
{
    self = [super init];
    
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error1;
    if(_videoDevice){
        _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:_videoDevice error:&error1];
        if (_videoInput){
            [self addInput:_videoInput];
        }
    }
    _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error2;
    if(_audioDevice){
        _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:_audioDevice error:&error2];
        if (_audioInput){
            [self addInput:_audioInput];
        }
    }
    
    //ADD MOVIE FILE OUTPUT
    NSLog(@"Adding movie file output");
    _movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    Float64 maxSeconds = 4;			//Max seconds
    int32_t preferredTimeScale = 30;	//Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(maxSeconds, preferredTimeScale);
    _movieOutput.maxRecordedDuration = maxDuration;
    _movieOutput.minFreeDiskSpaceLimit = 1024 * 1024;
    
    if ([self canAddOutput:_movieOutput])
        [self addOutput:_movieOutput];
    

    [self startRunning];

    return self;
}

-(void)startRecordingToFileWithURL:(NSURL*)movieURL
{
    NSLog(@"startRecording");
    [_movieOutput startRecordingToOutputFileURL:movieURL recordingDelegate:self];
}

-(void)stopRecording
{
    [self stopRunning];
    [_movieOutput stopRecording];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error
{
    [self stopRecording];
    BOOL RecordedSuccessfully = YES;
    if (error)
    {
        // A problem occurred: Find out if the recording was successful.
        NSLog(@"%@", [error localizedDescription]);
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully)
    {
        NSLog(@"didFinishRecordingToOutputFileAtURL - success");
    }
}

@end
