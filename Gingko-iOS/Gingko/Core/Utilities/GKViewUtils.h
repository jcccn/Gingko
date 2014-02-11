//
//  GKViewUtils.h
//  Gingko
//
//  Created by Jiang Chuncheng on 12/10/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <A2DynamicDelegate.h>
#import <ELCImagePickerController/ELCAlbumPickerController.h>
#import <ELCImagePickerController/ELCImagePickerController.h>

typedef void(^GKImagePickerFinishedBlock)(UIViewController *picker, NSArray *infos);
typedef void(^GKImagePickerCanceledBlock)(UIViewController *picker);

@interface GKViewUtils : NSObject

+ (CGSize)sizeForText:(NSString *)string withSystemFontOfSize:(CGFloat)fontSize andRowWidth:(CGFloat)width;
+ (CGFloat)heightForText:(NSString *)string withSystemFontOfSize:(CGFloat)fontSize andRowWidth:(CGFloat)width;
+ (CGFloat)heightForText:(NSString *)string withSystemFontOfSize:(CGFloat)fontSize andRowWidth:(CGFloat)width padding:(CGFloat)padding;

+ (UIImageView *)imageViewWithAnimatingImageNames:(NSString *)firstImageName, ... NS_REQUIRES_NIL_TERMINATION;
+ (void)setAnimationForImageView:(UIImageView *)imageView withImageNames:(NSString *)firstImageName, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)makeCircleForImageView:(UIImageView *)imageView;
+ (void)makeRoundForView:(UIView *)view WithRadius:(CGFloat)radius;

+ (UIActionSheet *)showImagePickerActionSheetOn:(UIViewController *)viewController
                                  allowsEditing:(BOOL)allowsEditing
                                 maxImageNumber:(NSInteger)maxImageNumber
                                       finished:(GKImagePickerFinishedBlock)finishedBlock
                                       canceled:(GKImagePickerCanceledBlock)canceledBlock;

+ (void)showImagePickerOn:(UIViewController *)viewController
               sourceType:(UIImagePickerControllerSourceType)sourceType
            allowsEditing:(BOOL)allowsEditing
           maxImageNumber:(NSInteger)maxImageNumber
                 finished:(GKImagePickerFinishedBlock)finishedBlock
                 canceled:(GKImagePickerCanceledBlock)canceledBlock;


@end


@interface UIView (GKViewUtils)

- (UIImage *)screenshot;

@end

@interface UIColor (GKViewUtils)

/**
 *  构造颜色对象
 *
 *  @param red   红色0~255
 *  @param green 绿色0~255
 *  @param blue  蓝色0~255
 *  @param alpha 透明度0~255
 *
 *  @return RGBA颜色
 */
+ (UIColor *)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue A:(NSInteger)alpha;

@end

@interface UIAlertView (GKViewUtils)

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelButtonHandler:(void (^)(UIAlertView *alertView))cancelButtonBlock
                      otherButtonTitles:(NSArray *)otherButtonTitles
                                handler:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block;

@end

@interface UIViewController (GKViewUtils_UIImagePickerControllerDelegate)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

- (GKImagePickerCanceledBlock)didCancelSingleImageBlock;
- (void)setDidCancelSingleImageBlock:(GKImagePickerCanceledBlock)didCancelBlock;

- (GKImagePickerFinishedBlock)didFinishSingleImageBlock;
- (void)setDidFinishSingleImageBlock:(GKImagePickerFinishedBlock)didFinishBlock;

@end

@interface ELCImagePickerController (GKViewUtils)

@property (nonatomic, copy) GKImagePickerFinishedBlock didFinishBlock;
@property (nonatomic, copy) GKImagePickerCanceledBlock didCancelBlock;

@end