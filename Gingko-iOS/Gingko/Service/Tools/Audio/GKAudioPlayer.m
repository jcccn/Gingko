//
//  GKAudioPlayer.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "GKAudioPlayer.h"

#import "GKAmrCodec.h"

@interface GKAudioPlayer () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;

- (BOOL)isPlaying;

@end

@implementation GKAudioPlayer

+ (instancetype)defaultPlayer {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (void)startPlayingWithFilePath:(NSString *)path delegate:(id<GKAudioPlayerDelegate>)newDelegate {
    if ( ! path) {
        return;
    }
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if ([self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:successfully:)]) {
            [self.delegate audioPlayerDidFinishPlaying:self successfully:YES];
        }
        if ([newDelegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:successfully:)]) {
            [newDelegate audioPlayerDidFinishPlaying:self successfully:NO];
        }
        return;
    }
    
    NSString *waveFilePath;
    if ([path rangeOfString:@".wav"].location == NSNotFound && [path rangeOfString:@".amr"].location != NSNotFound) {
        waveFilePath = [path stringByAppendingPathExtension:@"wav"];
        if ( ! [[NSFileManager defaultManager] fileExistsAtPath:waveFilePath]) {    //已经转换过就不转换了
            [GKAmrCodec decodeAmrFile:path toWaveFile:waveFilePath];
        }
        
    }
    else {
        waveFilePath = [path copy];
    }
    
    if (self.delegate != newDelegate) {
        if ([self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:successfully:)]) {
            [self.delegate audioPlayerDidFinishPlaying:self successfully:YES];
        }
        self.delegate = newDelegate;
    }
    
    NSError *error;
    self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:waveFilePath] error:&error];
    if (self.avAudioPlayer) {
        self.avAudioPlayer.delegate = self;
        [self.avAudioPlayer prepareToPlay];
        [self.avAudioPlayer play];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:successfully:)]) {
            [self.delegate audioPlayerDidFinishPlaying:self successfully:NO];
        }
    }
}

- (void)stopPlaying {
    if (self.avAudioPlayer) {
        [self.avAudioPlayer stop];
        self.avAudioPlayer = nil;
    }
    
    if ([self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:successfully:)]) {
        [self.delegate audioPlayerDidFinishPlaying:self successfully:YES];
    }
}

- (BOOL)isPlaying {
    return self.avAudioPlayer.isPlaying;
}

#pragma mark - AVAudioPlayer Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:successfully:)]) {
        [self.delegate audioPlayerDidFinishPlaying:self successfully:YES];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(audioPlayerDecodeErrorDidOccur:error:)]) {
        [self.delegate audioPlayerDecodeErrorDidOccur:self error:error];
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    if ([self.delegate respondsToSelector:@selector(audioRecorderBeginInterruption:)]) {
        [self.delegate audioPlayerBeginInterruption:self];
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    if ([self.delegate respondsToSelector:@selector(audioPlayerEndInterruption:withOptions:)]) {
        [self.delegate audioPlayerEndInterruption:self withOptions:flags];
    }
}

@end
