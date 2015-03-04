//
//  GKFileUtils.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKFileUtils : NSObject

+ (NSString *)documentsDirectory;
+ (NSString *)tmpDirectory;
+ (NSString *)cacheDirectory;
+ (NSString *)subDocumentsPath:(NSString *)subFilepath;
+ (NSString *)ensureDirectory:(NSString *)filepath;
+ (NSString *)ensureParentDirectory:(NSString *)filepath;

+ (void)saveImage:(UIImage *)image toFile:(NSString *)filePath;
+ (void)saveImage:(UIImage *)image toFile:(NSString *)filePath maxWidth:(CGFloat)maxWidth;
+ (NSString *)saveImageWithTimestampName:(UIImage *)image;

@end
