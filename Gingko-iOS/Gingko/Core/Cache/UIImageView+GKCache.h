//
//  UIImageView+GKCache.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "GKConstants.h"

typedef NSString * (^ImageUrlFilterBlock)(NSString *originUrl, NSInteger imageWidth);

@interface UIImageView (GKCache)

/**
 *  设置图片地址过滤器，用于修正图片地址
 *
 *  @param block 地址过滤器
 */
+ (void)setUrlFilter:(ImageUrlFilterBlock)block;

/**
 *  设置默认图片
 *
 *  @param placeholder 默认图片
 */
+ (void)setPlaceholderImage:(UIImage *)placeholder;


/**
 *  自动根据视图大小加载相应的缩略图
 *
 *  autoThumbnail = YES
 *  fadeIn = YES
 */
- (void)setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName;

/**
 *  自动根据视图大小加载相应的缩略图
 *
 *  @param urlString 原始图片地址
 */
- (void)setImageWithURLString:(NSString *)urlString;

/**
 *  自动根据视图大小加载相应的缩略图
 *
 *  autoThumbnail = YES
 *  @param urlString 原始图片地址
 *  @param shouldAnimate 是否执行动画
 */
- (void)setImageWithURLString:(NSString *)urlString withFadeIn:(BOOL)shouldAnimate;

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage withFadeIn:(BOOL)shouldAnimate;

/**
 *
 *  注意：placeholder是图片不是名称
 *
 *  autoThumbnail = YES
 *  fadeIn = NO
 */
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage;

/**
 * 加载网络图片
 *
 *  @param urlString 原始图片地址
 *  @param thumbnail 是否使用缩略图
 */
- (void)setImageWithURLString:(NSString *)urlString autoThumbnail:(BOOL)thumbnail;

@end
