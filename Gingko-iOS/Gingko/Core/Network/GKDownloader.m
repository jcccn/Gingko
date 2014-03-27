//
//  GKDownloader.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "GKDownloader.h"

#import <SDWebImage/SDWebImageManager.h>

#import "GKStringUtils.h"

@interface GKDownloader ()

+ (instancetype)sharedInstance;

@end

@implementation GKDownloader

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (BDMultiDownloader *)multiDownloader {
    return [BDMultiDownloader shared];
}

+ (void)downloadImageWithURL:(NSString *)urlString progress:(GKDownloaderProgressBlock)progressBlock completed:(GKDownloaderImageCompletedBlock)completedBlock {
    if ( ! [urlString length]) {
        return;
    }
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:urlString]
                                               options:0
                                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                  if (progressBlock) {
                                                      progressBlock(receivedSize / ((CGFloat)expectedSize));
                                                  }
                                              }
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (completedBlock) {
                                                     completedBlock(image, cacheType, finished);
                                                 }
                                             }];
}

+ (void)downloadFileWithURL:(NSString *)urlString toFilePath:(NSString *)filePath progress:(GKDownloaderProgressBlock)progressBlock completed:(GKDownloaderCompletedBlock)completedBlock {
    
    BOOL isDirectory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        if (completedBlock && ( ! isDirectory)) {
            completedBlock([NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:NULL], YES, YES);
        }
        return;
    }
    
    if ( ! [urlString length]) {
        return;
    }
    
    BDMultiDownloader *downloader = [BDMultiDownloader shared];
    //FIXME：多个同时下载时候会不会冲突
    downloader.onDownloadProgressWithProgressAndSuggestedFilename = ^(double progress, NSString *suggstedFilename) {
        if (progressBlock) {
            progressBlock(progress);
        }
    };
    [downloader queueRequest:urlString
                  completion:^(NSData *data) {
                      if ([data length] && [filePath length]) {
                          [data writeToFile:filePath atomically:YES];
                      }
                      
                      if (completedBlock) {
                          completedBlock(data, NO, ([data length] ? YES : NO));
                      }
                  }];
}

+ (void)downloadFileWithURL:(NSString *)urlString toDirectoryWithMd5Name:(NSString *)directoryPath progress:(GKDownloaderProgressBlock)progressBlock completed:(GKDownloaderCompletedBlock)completedBlock {
    NSString *md5String = [urlString md5];
    NSString *extString = [urlString pathExtension];
    NSString *md5FileName = [NSString stringWithFormat:@"%@.%@", md5String, extString];
    
    BOOL isDirectory;
    if ( ! ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory] && isDirectory)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    NSString *filePath = [directoryPath stringByAppendingPathComponent:md5FileName];
    [self downloadFileWithURL:urlString
                   toFilePath:filePath
                     progress:progressBlock
                    completed:completedBlock];
}

@end
