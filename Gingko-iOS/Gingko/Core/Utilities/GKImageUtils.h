//
//  GKImageUtils.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIImage-Categories/UIImage+Alpha.h>
#import <UIImage-Categories/UIImage+FixRotation.h>
#import <UIImage-Categories/UIImage+Resize.h>
#import <UIImage-Categories/UIImage+RoundedCorner.h>

/*  图片质量
 * 高质量：原图
 * 中等质量：原图大小的70%。最小宽度：480 最大宽度：720
 * 低质量：原图大小的50%。最小宽度：320 最大宽度：480
 */
typedef NS_ENUM(NSUInteger, GKImageQuality) {
    GKImageQualityLow = 0,        //低质量图片
    GKImageQualityNormal = 1,     //中等质量图片
    GKImageQualityHigh = 2,       //高质量图片
    GKImageQualityOrigin = 3,     //原图
    GKImageQualityAuto = 10       //根据网络自动选择图片质量
};

@interface GKImageUtils : NSObject

/**
 *  根据要显示的区域大小，选择合适的缩略图请求尺寸
 *
 *  @param imageViewRect 图片要显示显示的控件大小
 *
 *  @return 合适的图片的宽度
 */
+ (NSInteger)fitThumbnailWidthForImageBounds:(CGRect)imageViewRect;

@end


@interface UIImage (GKImageUtils)

/**
 *  九宫格图片
 *
 *  @param top    上边固定像素
 *  @param left   左边固定像素
 *  @param bottom 下边固定像素
 *  @param right  右边固定像素
 *
 *  @return 就行九宫格拉伸后的图片
 */
- (UIImage *)ninePathByInsertTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
- (UIImage *)ninePathByInsert:(CGFloat)insert;

/**
 *	根据网络状况自动调整上传图片的质量
 *
 *	@return	调整后的图片
 */
- (UIImage *)adjustImageQualityAutomatically;

/**
 *	调整上传图片的质量
 *
 *	@param	quality	调整的质量等级
 *
 *	@return	调整后的图片
 */
- (UIImage *)adjustImageToQuality:(GKImageQuality)quality;

/**
 *  截取中间的正方形区域
 *
 *  @return 截取的图片
 */
- (UIImage *)cropCenterSquare;

/**
 *  修正方向
 *
 *  @return 修正方向后的图片
 */
- (UIImage *)upOrientation;

@end
