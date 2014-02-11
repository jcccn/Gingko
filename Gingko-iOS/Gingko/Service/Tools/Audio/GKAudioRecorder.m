//
//  GKAudioRecorder.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "GKAudioRecorder.h"

#import "GKAmrCodec.h"
#import "GKDateUtils.h"
#import "GKFileUtils.h"

@interface GKAudioRecorder () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *avAudioRecorder;

@property (nonatomic, strong) NSDate *startRecordDate;

- (void)reachMaxRecordTime;

@end

@implementation GKAudioRecorder

+ (instancetype)defaultRecorder {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (id)init {
    self = [super init];
    if (self) {
        self.maxRecordTimeInterval = kDefaultMaxRecordTimeInterval;
        self.minRecordTimeInterval = kDefaultMinRecordTimeInterval;
    }
    return self;
}

- (void)startRecordingToFilePath:(NSString *)path delegate:(id<GKAudioRecorderDelegate>)delegate {
    
    if (self.avAudioRecorder.isRecording) {
        [self.avAudioRecorder stop];
    }
    
    self.delegate = delegate;
    
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if ([path length]) {
        _recordedFilepath = [path copy];
    }
    else {
        _recordedFilepath = [[GKFileUtils tmpDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr", [GKDateUtils timestamp]]];
    }
    _recordedTimeInterval = 0;
    
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithFloat: 8000.0] forKey:AVSampleRateKey];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat: 16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    self.avAudioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:[_recordedFilepath stringByAppendingPathExtension:@"wav"]]
                                                       settings:recordSetting
                                                          error:&error];
    error = nil;
    if (error) {
        if ([self.delegate respondsToSelector:@selector(audioRecorderDidFinisGKecording:successfully:)]) {
            [self.delegate audioRecorderDidFinisGKecording:self successfully:NO];
        }
        return;
    }
    self.avAudioRecorder.delegate = self;
    [self.avAudioRecorder prepareToRecord];
    [self.avAudioRecorder recordForDuration:self.maxRecordTimeInterval];
    
    //[self performSelector:@selector(reachMaxRecordTime) withObject:nil afterDelay:self.maxRecordTimeInterval];    //用recordForDuration代替
    self.startRecordDate = [NSDate date];
}

- (void)stopRecording {
    _recordedTimeInterval = [[NSDate date] timeIntervalSinceDate:self.startRecordDate];
    if (_recordedTimeInterval < self.minRecordTimeInterval) {
        [self cancelRecording];
    }
    else {
        [self.avAudioRecorder stop];
        self.avAudioRecorder = nil;
    }
}

- (void)convertWaveToAmr:(NSString *)waveFilePath {
    int frames = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:waveFilePath]) {
        frames = [GKAmrCodec encodeWaveFile:waveFilePath toAmrFile:_recordedFilepath withChannels:1 bps:16];
    }
    if ([self.delegate respondsToSelector:@selector(audioRecorderDidFinisGKecording:successfully:)]) {
        [self.delegate audioRecorderDidFinisGKecording:self successfully:frames];
    }
}

- (void)cancelRecording {
    [self.avAudioRecorder stop];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.avAudioRecorder.url path]]) {
        [self.avAudioRecorder deleteRecording];
    }
    self.avAudioRecorder = nil;
}

- (void)reachMaxRecordTime {
    if ( ! [self.avAudioRecorder isRecording]) {
        return;
    }
    [self stopRecording];
}

#pragma mark - AVAudioRecorder Delegate

- (void)audioRecorderDidFinisGKecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    BOOL canceled = ( ! [[NSFileManager defaultManager] fileExistsAtPath:[recorder.url path]]);
    if (flag && ( ! canceled)) {
        [self performSelectorInBackground:@selector(convertWaveToAmr:) withObject:[recorder.url path]];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(audioRecorderDidFinisGKecording:successfully:)]) {
            [self.delegate audioRecorderDidFinisGKecording:self successfully:NO];
        }
    }
    
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reachMaxRecordTime) object:nil];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(audioRecorderEncodeErrorDidOccur:error:)]) {
        [self.delegate audioRecorderEncodeErrorDidOccur:self error:error];
    }
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    if ([self.delegate respondsToSelector:@selector(audioRecorderBeginInterruption:)]) {
        [self.delegate audioRecorderBeginInterruption:self];
    }
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags {
    if ([self.delegate respondsToSelector:@selector(audioRecorderEndInterruption:withOptions:)]) {
        [self.delegate audioRecorderEndInterruption:self withOptions:flags];
    }
}

@end
