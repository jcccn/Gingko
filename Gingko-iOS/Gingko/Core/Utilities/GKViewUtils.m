//
//  GKViewUtils.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

#import "GKViewUtils.h"

#import <objc/runtime.h>

#import "GKStringUtils.h"

#define MaxLabelHeight  2000.0f
#define DefaultAnimationInterval    0.2f

static NSString *kAssociationKeyDidFinishBlock = @"didFinishBlock";
static NSString *kAssociationKeyDidCancelBlock = @"didCancelBlock";

@implementation GKViewUtils

+ (CGSize)sizeForText:(NSString *)string withSystemFontOfSize:(CGFloat)fontSize andRowWidth:(CGFloat)width {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MaxLabelHeight)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}
                                       context:nil];
    return rect.size;
}

+ (CGFloat)heightForText:(NSString *)string withSystemFontOfSize:(CGFloat)fontSize andRowWidth:(CGFloat)width {
    return [self sizeForText:string withSystemFontOfSize:fontSize andRowWidth:width].height;
}

+ (CGFloat)heightForText:(NSString *)string withSystemFontOfSize:(CGFloat)fontSize andRowWidth:(CGFloat)width padding:(CGFloat)padding {
    return [self heightForText:string withSystemFontOfSize:fontSize andRowWidth:width] + padding * 2;
}

+ (UIImageView *)imageViewWithAnimatingImageNames:(NSString *)firstImageName, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *images = [NSMutableArray array];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:firstImageName]];
    
    va_list args;
    va_start(args, firstImageName);
    for (NSString *name = firstImageName; name != nil; name = va_arg(args, id)) {
        UIImage *image = [UIImage imageNamed:name];
        if (image) {
            [images addObject:image];
        }
    }
    va_end(args);
    
    if ([images count] > 0) {
        imageView.animationImages = images;
        imageView.animationDuration = [images count] * DefaultAnimationInterval;
        imageView.animationRepeatCount = -1;
    }
    
    return imageView;
}

+ (void)setAnimationForImageView:(UIImageView *)imageView withImageNames:(NSString *)firstImageName, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *images = [NSMutableArray array];
    va_list args;
    va_start(args, firstImageName);
    for (NSString *name = firstImageName; name != nil; name = va_arg(args, id)) {
        UIImage *image = [UIImage imageNamed:name];
        if (image) {
            [images addObject:image];
        }
    }
    va_end(args);
    
    if ([images count] > 0) {
        imageView.animationImages = images;
        imageView.animationDuration = [images count] * DefaultAnimationInterval;
        imageView.animationRepeatCount = -1;
    }
}

+ (void)makeCircleForImageView:(UIImageView *)imageView {
    imageView.layer.cornerRadius = imageView.bounds.size.width / 2;
    imageView.layer.masksToBounds = YES;
}

+ (void)makeRoundForView:(UIView *)view WithRadius:(CGFloat)radius {
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

+ (UIActionSheet *)showImagePickerActionSheetOn:(UIViewController *)viewController
                                  allowsEditing:(BOOL)allowsEditing
                                 maxImageNumber:(NSInteger)maxImageNumber
                                       finished:(GKImagePickerFinishedBlock)finishedBlock
                                       canceled:(GKImagePickerCanceledBlock)canceledBlock {
    if ( ! viewController) {
        return nil;
    }
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"拍摄照片"
                               handler:^{
                                   [self showImagePickerOn:viewController
                                                sourceType:UIImagePickerControllerSourceTypeCamera
                                             allowsEditing:allowsEditing
                                            maxImageNumber:maxImageNumber
                                                  finished:finishedBlock
                                                  canceled:canceledBlock];
                               }];
    
    [actionSheet bk_addButtonWithTitle:@"选取照片"
                               handler:^{
                                   [self showImagePickerOn:viewController
                                                sourceType:UIImagePickerControllerSourceTypePhotoLibrary
                                             allowsEditing:allowsEditing
                                            maxImageNumber:maxImageNumber
                                                  finished:finishedBlock
                                                  canceled:canceledBlock];
                               }];
    
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [actionSheet showInView:viewController.view];
    return actionSheet;
}

+ (void)showImagePickerOn:(UIViewController *)viewController
               sourceType:(UIImagePickerControllerSourceType)sourceType
            allowsEditing:(BOOL)allowsEditing
           maxImageNumber:(NSInteger)maxImageNumber
                 finished:(GKImagePickerFinishedBlock)finishedBlock
                 canceled:(GKImagePickerCanceledBlock)canceledBlock {
    if ( ! [UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return;
    }
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePickerController.allowsEditing = allowsEditing;
        imagePickerController.sourceType = sourceType;
        viewController.didCancelSingleImageBlock = canceledBlock;
        viewController.didFinishSingleImageBlock = finishedBlock;
        imagePickerController.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)viewController;
        [viewController presentViewController:imagePickerController animated:YES completion:NULL];
    }
    else {
        if (maxImageNumber <= 1) {//选择相册里单张图片
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePickerController.allowsEditing = allowsEditing;
            imagePickerController.sourceType = sourceType;
            viewController.didCancelSingleImageBlock = canceledBlock;
            viewController.didFinishSingleImageBlock = finishedBlock;
            imagePickerController.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)viewController;
            [viewController presentViewController:imagePickerController animated:YES completion:NULL];
        }
        else {//选择相册里多张图片
            ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] init];
            ELCImagePickerController *imagePickerController = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
            [albumController setParent:imagePickerController];
            imagePickerController.didFinishBlock = finishedBlock;
            imagePickerController.didCancelBlock = canceledBlock;
            imagePickerController.maximumImagesCount = maxImageNumber;
            __weak ELCAlbumPickerController *blockAlbumPicker = albumController;
            [imagePickerController bk_performBlock:^(id sender) {
                blockAlbumPicker.navigationItem.title = @"照片";
            }
                                        afterDelay:0.5f];
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}

@end

@implementation UIView (GKViewUtils)

- (UIImage *)screenshot {
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    __autoreleasing UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshotImage;
}

@end


@implementation UIColor (GKViewUtils)

+ (UIColor *)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue A:(NSInteger)alpha {
    return [self colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha / 255.0f];
}

@end

@implementation UIAlertView (GKViewUtils)

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                    cancelButtonHandler:(void (^)(UIAlertView *alertView))cancelButtonBlock
                      otherButtonTitles:(NSArray *)otherButtonTitles
                                handler:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))otherButtonsBlock {
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:title message:message];
    __weak UIAlertView *weakAlertView = alertView;
    
    BOOL showCancelButton = ( ! [GKStringUtils isEmpty:cancelButtonTitle]);
    if (showCancelButton) {
        [alertView bk_setCancelButtonWithTitle:cancelButtonTitle handler:^ {
            if (cancelButtonBlock) {
                cancelButtonBlock(weakAlertView);
            }
        }];
    }
    
    [otherButtonTitles bk_each: ^(NSString *buttonTitle) {
		[alertView addButtonWithTitle:buttonTitle];
	}];
    if (otherButtonsBlock) {
        alertView.bk_didDismissBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (( ! showCancelButton) || buttonIndex) {  //如果有取消按钮就不回调取消按钮
                otherButtonsBlock(weakAlertView, buttonIndex);
            }
        };
    }
    
    [alertView show];
    
    return alertView;
}

@end


@implementation UIViewController (GKViewUtils_UIImagePickerControllerDelegate)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    GKImagePickerFinishedBlock didFinishSingleBlock = self.didFinishSingleImageBlock;
    if (didFinishSingleBlock) {
        didFinishSingleBlock(picker, (info ? @[ info ] : [NSArray array]));
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    GKImagePickerCanceledBlock didCancelBlock = self.didCancelSingleImageBlock;
    if (didCancelBlock) {
        didCancelBlock(picker);
    }
}


- (GKImagePickerCanceledBlock)didCancelSingleImageBlock {
    return [self bk_associatedValueForKey:&kAssociationKeyDidCancelBlock];
}

- (void)setDidCancelSingleImageBlock:(GKImagePickerCanceledBlock)didCancelBlock {
    [self bk_associateCopyOfValue:didCancelBlock withKey:&kAssociationKeyDidCancelBlock];
}

- (GKImagePickerFinishedBlock)didFinishSingleImageBlock {
    return [self bk_associatedValueForKey:&kAssociationKeyDidFinishBlock];
}

- (void)setDidFinishSingleImageBlock:(GKImagePickerFinishedBlock)didFinishBlock {
    [self bk_associateCopyOfValue:didFinishBlock withKey:&kAssociationKeyDidFinishBlock];
}

@end

@implementation ELCImagePickerController (GKViewUtils)

@dynamic didFinishBlock, didCancelBlock;

+ (void)load {
	@autoreleasepool {
		[self bk_registerDynamicDelegateNamed:@"imagePickerDelegate"];
		[self bk_linkDelegateMethods: @{
                                        @"didFinishBlock": @"elcImagePickerController:didFinishPickingMediaWithInfo:",
                                        @"didCancelBlock": @"elcImagePickerControllerDidCancel:"
                                        }];
	}
}

@end