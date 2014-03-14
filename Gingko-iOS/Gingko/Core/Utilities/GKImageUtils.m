//
//  GKImageUtils.m
//  Gingko
//
//  Created by Jiang Chuncheng on 12/10/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "GKImageUtils.h"

#import <Reachability/Reachability.h>

@implementation GKImageUtils

+ (NSInteger)fitThumbnailWidthForImageBounds:(CGRect)imageViewRect {
    NSInteger screenScale = (NSInteger)[[UIScreen mainScreen] scale];
    
    CGFloat maxImageViewWidth = MAX(imageViewRect.size.width, imageViewRect.size.height);
    NSInteger fitThumbnailWidth;
    if (maxImageViewWidth > 569) {
        return NSIntegerMax;
    }
    else if (maxImageViewWidth > 500) {
        fitThumbnailWidth = 600;
    }
    else if (maxImageViewWidth > 401) {
        fitThumbnailWidth = 500;
    }
    else if (maxImageViewWidth > 301) {
        fitThumbnailWidth = 400;
    }
    else if (maxImageViewWidth > 201) {
        fitThumbnailWidth = 300;
    }
    else if (maxImageViewWidth > 101) {
        fitThumbnailWidth = 200;
    }
    else if (maxImageViewWidth > 51) {
        fitThumbnailWidth = 100;
    }
    else {
        fitThumbnailWidth = 50;
    }
    return fitThumbnailWidth * screenScale;
}

@end

@implementation UIImage (GKImageUtils)

- (UIImage *)ninePathByInsertTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    UIImage *resizedImage = nil;
    CGFloat sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVersion < 6.0) {
        resizedImage = [self stretchableImageWithLeftCapWidth:left topCapHeight:top];
    }
    else {
        resizedImage = [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
    }
    return resizedImage;
}

- (UIImage *)ninePathByInsert:(CGFloat)insert {
    return [self ninePathByInsertTop:insert left:insert bottom:insert right:insert];
}

- (UIImage *)adjustImageQualityAutomatically {
    return [self adjustImageToQuality:GKImageQualityAuto];
}

- (UIImage *)adjustImageToQuality:(GKImageQuality)quality {
    GKImageQuality GKImageQuality = quality;
    if (GKImageQuality == GKImageQualityAuto) {
        NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
        // 默认(比如网络暂时无连接)是中等质量图片。如果是手机网络，使用低质量图片。如果是WIFI，使用高质量图片。
        if (networkStatus == ReachableViaWWAN) {
            GKImageQuality = GKImageQualityLow;
        }
        else if (networkStatus == ReachableViaWiFi) {
            GKImageQuality = GKImageQualityHigh;
        }
        else {
            GKImageQuality = GKImageQualityNormal;
        }
    }
    
    if (quality == GKImageQualityLow || quality == GKImageQualityNormal) {
        UIImage *scaledImage = nil;
        
        /**
         * 1、先判断宽度是否在区间内。
         * 2、如果宽度小于最小值，使用原图
         * 3、按比例计算需要的宽度。
         * 4、如果需要宽度大于最大值，使用最大值缩放
         * 4、否则，按计算得到的比例来
         */
        CGFloat minWidth = (quality == GKImageQualityLow ? 320 : 480);
        CGFloat maxWidth = (quality == GKImageQualityLow ? 480 : 720);
        
        CGFloat originWidth = self.size.width;
        CGFloat originHeight = self.size.height;
        
        if (originWidth < minWidth) {
            return self;
        }
        
        CGFloat wantedRatio = (quality == GKImageQualityLow ? 0.5f : 0.7f);
        
        CGFloat wantedWidth = originWidth * wantedRatio;
        
        if (wantedWidth > maxWidth) {
            wantedWidth = maxWidth;
        }
        
        scaledImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                 bounds:CGSizeMake(wantedWidth, wantedWidth * (originHeight / originWidth))
                                   interpolationQuality:kCGInterpolationDefault];
        
        return scaledImage;
    }
    
    return self;
}

- (UIImage *)cropCenterSquare {
    float originalWidth  = self.size.width;
    float originalHeight = self.size.height;
    if (originalHeight == originalWidth) {
        return self;
    }
    
    UIImage *cropedImage = nil;
    float edge = fminf(originalWidth, originalHeight);
    float posX = (originalWidth   - edge) / 2.0f;
    float posY = (originalHeight  - edge) / 2.0f;
    
    CGRect cropSquare = CGRectMake(posX, posY, edge, edge);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, cropSquare);
    
    cropedImage = [UIImage imageWithCGImage:imageRef
                                      scale:self.scale
                                orientation:self.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return cropedImage;
}

- (NSInteger)fitThumbnailWidthForImageBounds:(CGRect)imageViewRect {
    NSInteger screenScale = (NSInteger)[[UIScreen mainScreen] scale];
    
    CGFloat maxImageViewWidth = MAX(imageViewRect.size.width, imageViewRect.size.height);
    NSInteger fitThumbnailWidth;
    if (maxImageViewWidth > 321) {
        return NSIntegerMax;
    }
    else if (maxImageViewWidth > 201) {
        fitThumbnailWidth = 300;
    }
    else if (maxImageViewWidth > 101) {
        fitThumbnailWidth = 200;
    }
    else if (maxImageViewWidth > 51) {
        fitThumbnailWidth = 100;
    }
    else {
        fitThumbnailWidth = 50;
    }
    return fitThumbnailWidth * screenScale;
}

- (UIImage *)upOrientation {
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    else {
        return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUp];
    }
}

@end
