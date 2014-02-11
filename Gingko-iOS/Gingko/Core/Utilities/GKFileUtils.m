//
//  GKFileUtils.m
//  Gingko
//
//  Created by Jiang Chuncheng on 12/10/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "GKFileUtils.h"

#import "GKImageUtils.h"

#define kMaxImageWidthDefault   2048

#define kCompressionQualityDefault  0.8f

@implementation GKFileUtils

NSString *documentDirectoryPath = nil;
NSString *cacheDirectoryPath = nil;

#pragma mark - File Path
+ (NSString *)documentsDirectory {
    if ( ! documentDirectoryPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentDirectoryPath = [paths objectAtIndex:0];
    }
    return documentDirectoryPath;
}

+ (NSString *)tmpDirectory {
    return NSTemporaryDirectory();
}

+ (NSString *)cacheDirectory {
    if ( ! cacheDirectoryPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cacheDirectoryPath = [paths objectAtIndex:0];
    }
    return cacheDirectoryPath;
}

+ (NSString *)subDocumentsPath:(NSString *)subFilepath {
    return [[self documentsDirectory] stringByAppendingPathComponent:subFilepath];
}

+ (NSString *)ensureParentDirectory:(NSString *)filepath {
    NSString *parentDirectory = [filepath stringByDeletingLastPathComponent];
    BOOL isDirectory;
    if (( ! [[NSFileManager defaultManager] fileExistsAtPath:parentDirectory isDirectory:&isDirectory]) || ( ! isDirectory)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:parentDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return filepath;
}

+ (NSString *)ensureDirectory:(NSString *)filepath {
    BOOL isDirectory;
    if (( ! [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory]) || ( ! isDirectory)) {
        [self ensureParentDirectory:filepath];
        [[NSFileManager defaultManager] createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return filepath;
}

+ (void)saveImage:(UIImage *)image toFile:(NSString *)filePath {
    [self saveImage:image toFile:filePath maxWidth:kMaxImageWidthDefault];
}

+ (void)saveImage:(UIImage *)image toFile:(NSString *)filePath maxWidth:(CGFloat)maxWidth {
    NSData *imageData;
    UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                       bounds:CGSizeMake(maxWidth, maxWidth)
                                         interpolationQuality:kCGInterpolationDefault];
    if ([image hasAlpha]) {
        imageData = UIImagePNGRepresentation(scaledImage);
    }
    else {
        imageData = UIImageJPEGRepresentation(scaledImage, kCompressionQualityDefault);
    }
    [self ensureParentDirectory:filePath];
    [imageData writeToFile:filePath atomically:YES];
}

+ (NSString *)saveImageWithTimestampName:(UIImage *)image {
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *picturePath = [[GKFileUtils tmpDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.jpg", timestamp]];
    [self saveImage:image toFile:picturePath];
    return picturePath;
}

@end
