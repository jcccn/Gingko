//
//  UIImageView+GKCache.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

#import "UIImageView+GKCache.h"

static ImageUrlFilterBlock imageUrlFilterBlock;
static UIImage *imagePlaceholder;

@interface UIImageView (GKCachePrivate)

- (void)setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName autoThumbnail:(BOOL)thumbnail;
- (void)setImageWithURLString:(NSString *)urlString
         placeholderImageName:(NSString *)placeholderImageName
             placeholderImage:(UIImage *)placeholderImage
                autoThumbnail:(BOOL)thumbnail
                   withFadeIn:(BOOL)shouldAnimate;

@end

@implementation UIImageView (GKCache)

+ (void)setUrlFilter:(ImageUrlFilterBlock)block {
    imageUrlFilterBlock = block;
}

+ (void)setPlaceholderImage:(UIImage *)placeholder {
    imagePlaceholder = placeholder;
}


- (void)setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName {
    [self setImageWithURLString:urlString placeholderImageName:placeholderImageName autoThumbnail:YES];
}

- (void)setImageWithURLString:(NSString *)urlString {
    [self setImageWithURLString:urlString autoThumbnail:YES];
}

- (void)setImageWithURLString:(NSString *)urlString withFadeIn:(BOOL)shouldAnimate {
    [self setImageWithURLString:urlString
           placeholderImageName:nil
               placeholderImage:nil
                  autoThumbnail:YES
                     withFadeIn:shouldAnimate];
}

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage withFadeIn:(BOOL)shouldAnimate {
    [self setImageWithURLString:urlString
           placeholderImageName:nil
               placeholderImage:holderImage
                  autoThumbnail:YES
                     withFadeIn:shouldAnimate];
}

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)holderImage {
    [self setImageWithURLString:urlString
           placeholderImageName:nil
               placeholderImage:holderImage
                  autoThumbnail:YES
                     withFadeIn:NO];
}

- (void)setImageWithURLString:(NSString *)urlString autoThumbnail:(BOOL)thumbnail {
    [self setImageWithURLString:urlString placeholderImageName:nil autoThumbnail:thumbnail];
}

#pragma mark - Private

- (void)setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName autoThumbnail:(BOOL)thumbnail {
    [self setImageWithURLString:urlString
           placeholderImageName:placeholderImageName
               placeholderImage:nil
                  autoThumbnail:thumbnail
                     withFadeIn:YES];
}

- (void)setImageWithURLString:(NSString *)urlString
         placeholderImageName:(NSString *)placeholderImageName
             placeholderImage:(UIImage *)placeholderImage
                autoThumbnail:(BOOL)thumbnail
                   withFadeIn:(BOOL)shouldAnimate {
    NSURL *url;
    
    if ([urlString rangeOfString:[GKConstants homePath]].length) {
        url = [NSURL fileURLWithPath:urlString];
    }
    else {
        NSString *newUrlString = urlString;
        
        if (imageUrlFilterBlock) {
            NSInteger fitWidth = (thumbnail ? [GKImageUtils fitThumbnailWidthForImageBounds:self.bounds] : NSIntegerMax);
            newUrlString = imageUrlFilterBlock(urlString, fitWidth);
        }
        
        self.image = nil;
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeCenter;
        
        url = [NSURL URLWithString:newUrlString];
    }
    if ( ! placeholderImage) {
        if ( ! placeholderImageName || ! [UIImage imageNamed:placeholderImageName]) {
            placeholderImage = imagePlaceholder;
        }
        else {
            placeholderImage = [UIImage imageNamed:placeholderImageName];
        }
    }
    if ( ! url) {
        self.image = placeholderImage;
        return;
    }
    
    WeakSelf;
    [self sd_setImageWithURL:url
            placeholderImage:placeholderImage
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if ( ! error) {
                           weakSelf.contentMode = UIViewContentModeScaleAspectFill;
                           NSInteger screenScale = (NSInteger)[[UIScreen mainScreen] scale];
                           CGSize imageSize = weakSelf.bounds.size;
                           imageSize = CGSizeMake(screenScale * imageSize.width, screenScale * imageSize.height);
                           weakSelf.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                                        bounds:imageSize
                                                          interpolationQuality:kCGInterpolationDefault];
                           weakSelf.backgroundColor = [UIColor clearColor];
                           if (shouldAnimate) {
                               weakSelf.alpha = 0.1f;
                               [UIView animateWithDuration:0.5f
                                                     delay:0
                                                   options:UIViewAnimationOptionCurveEaseIn
                                                animations:^{
                                                    weakSelf.alpha = 1.0f;
                                                }
                                                completion:^(BOOL finished) {
                                                    
                                                }];
                           }
                       }
                   }];
}

@end
