//
//  GKAudioPlayer.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  音频播放
 */

#import "GKCore.h"
#import <AVFoundation/AVFoundation.h>

@protocol GKAudioPlayerDelegate;

@interface GKAudioPlayer : NSObject {
    
}

@property (nonatomic, weak)  id<GKAudioPlayerDelegate> delegate;

+ (instancetype)defaultPlayer;

- (void)startPlayingWithFilePath:(NSString *)path delegate:(id<GKAudioPlayerDelegate>)newDelegate;

- (void)stopPlaying;

@end


@protocol GKAudioPlayerDelegate <NSObject>

@optional

- (void)audioPlayerDidFinishPlaying:(GKAudioPlayer *)player successfully:(BOOL)flag;

- (void)audioPlayerDecodeErrorDidOccur:(GKAudioPlayer *)player error:(NSError *)error;

- (void)audioPlayerBeginInterruption:(GKAudioPlayer *)player;

- (void)audioPlayerEndInterruption:(GKAudioPlayer *)player withOptions:(NSUInteger)flags;

@end