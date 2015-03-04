//
//  GKDownloader.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

/**
 *  下载器，支持缓存和进度，多线程，异步
 */

#import "GKMacros.h"

#import <BDMultiDownloader/BDMultiDownloader.h>

typedef void(^GKDownloaderProgressBlock)(double progress);
typedef void(^GKDownloaderCompletedBlock)(id data, BOOL finished, BOOL fromCache);
typedef void(^GKDownloaderImageCompletedBlock)(UIImage *image, BOOL finished, BOOL fromCache);

@interface GKDownloader : NSObject

/**
 *  核心多线程下载器BDMultiDownloader
 *
 *  @return 下载器
 */
+ (BDMultiDownloader *)multiDownloader;

/**
 *  使用SDWebImage下载图片并缓存
 *
 *  @param urlString      图片地址
 *  @param progressBlock  下载进度回调
 *  @param completedBlock 下载完成回调
 */
+ (void)downloadImageWithURL:(NSString *)urlString progress:(GKDownloaderProgressBlock)progressBlock completed:(GKDownloaderImageCompletedBlock)completedBlock;

/**
 *  使用BDMultiDownloader下载文件。超大文件的下载可能有文件。
 *
 *  @param urlString      文件网络地址
 *  @param filePath       文件本地地址
 *  @param progressBlock  下载进度回调
 *  @param completedBlock 下载完成回调
 */
+ (void)downloadFileWithURL:(NSString *)urlString toFilePath:(NSString *)filePath progress:(GKDownloaderProgressBlock)progressBlock completed:(GKDownloaderCompletedBlock)completedBlock;

/**
 *  使用BDMultiDownloader下载文件到指定目录，并以网址md5值为文件名。
 *
 *  @param urlString      文件网络地址
 *  @param directoryPath  文件本地保存的目录
 *  @param progressBlock  下载进度回调
 *  @param completedBlock 下载完成回调
 */
+ (void)downloadFileWithURL:(NSString *)urlString toDirectoryWithMd5Name:(NSString *)directoryPath progress:(GKDownloaderProgressBlock)progressBlock completed:(GKDownloaderCompletedBlock)completedBlock;

@end
