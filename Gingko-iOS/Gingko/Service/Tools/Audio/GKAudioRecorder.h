//
//  GKAudioRecorder.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  音频录制
 */

#import "GKMacros.h"

#import <AVFoundation/AVFoundation.h>

#define kDefaultMaxRecordTimeInterval   59.0f
#define kDefaultMinRecordTimeInterval   2.0f

@protocol GKAudioRecorderDelegate;

@interface GKAudioRecorder : NSObject {
    
}

@property (nonatomic, weak)  id<GKAudioRecorderDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval minRecordTimeInterval;     //最短录制时间
@property (nonatomic, assign) NSTimeInterval maxRecordTimeInterval;     //最长录制时间
@property (nonatomic, readonly) NSTimeInterval recordedTimeInterval;    //完成的录音长度
@property (nonatomic, readonly) NSString *recordedFilepath;             //完成的录音文件路径

+ (instancetype)defaultRecorder;

- (void)startRecordingToFilePath:(NSString *)path delegate:(id<GKAudioRecorderDelegate>)delegate;

- (void)stopRecording;

- (void)cancelRecording;

@end


@protocol GKAudioRecorderDelegate <NSObject>

@optional

- (void)audioRecorderDidFinisGKecording:(GKAudioRecorder *)recorder successfully:(BOOL)flag;

- (void)audioRecorderEncodeErrorDidOccur:(GKAudioRecorder *)recorder error:(NSError *)error;

- (void)audioRecorderBeginInterruption:(GKAudioRecorder *)recorder;

- (void)audioRecorderEndInterruption:(GKAudioRecorder *)recorder withOptions:(NSUInteger)flags;

@end