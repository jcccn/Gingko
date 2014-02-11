//
//  GKAmrCodec.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  AMR编码解码器
 *
 */

#import <Foundation/Foundation.h>

#define PCM_FRAME_SIZE 160 // 8khz 8000*0.02=160
#define MAX_AMR_FRAME_SIZE 32
#define AMR_FRAME_COUNT_PER_SECOND 50

@interface GKAmrCodec : NSObject

+ (int)encodeWaveFile:(NSString *)waveFilePath toAmrFile:(NSString *)amrFilePath withChannels:(NSUInteger)nChannels bps:(NSUInteger)nBitsPerSample;

+ (int)decodeAmrFile:(NSString *)amrFilePath toWaveFile:(NSString *)waveFilePath;

@end
