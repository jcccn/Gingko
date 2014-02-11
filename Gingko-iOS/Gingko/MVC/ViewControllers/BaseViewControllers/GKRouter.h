//
//  GKRouter.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  松耦合的视图控制器导航器。通过scheme来实现跳转到不同的界面。
 *  配置步骤：
 [GKRouter setRootViewController:xxx];
 [GKRouter setStoryboard:xxx];
 [GKRouter map:xxx toVVV:ooo];
 打开页面：
 [GKRouter open:xxx param:@{ kk: vv} transitionType:TransitionTypePush];
 关闭页面：
 [GKRouter closeCurrentViewController];
 */

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const GKSchemeWebView;
UIKIT_EXTERN NSString *const GKSchemePhotoViewer;

UIKIT_EXTERN NSString *const GKParamUrl;
UIKIT_EXTERN NSString *const GKParamTitle;

typedef NS_ENUM(NSUInteger, TransitionType) {
    TransitionTypePush,
    TransitionTypeModal
};

@class GKBaseViewController;

@interface GKRouter : NSObject {
    
}

+ (void)setRootViewController:(UIViewController *)rootController;
+ (void)setNavigationController:(UINavigationController *)navigationController;
+ (void)setTabBarController:(UITabBarController *)tabBarController;
+ (void)setStoryboard:(UIStoryboard *)storyboard;

/**
 *  协议映射。建立scheme和视图控制器类的对应关系
 *
 *  @param scheme    协议名，比如@"blogDetail"
 *  @param className 视图控制器类名，比如@"BlogDetailViewController"
 */
+ (void)map:(NSString *)scheme toViewControllerName:(NSString *)className;
+ (void)map:(NSString *)scheme toViewControllerStoryboadId:(NSString *)storyboardIdentifier;
+ (void)map:(NSString *)scheme toViewController:(GKBaseViewController *)viewController;
+ (void)unmap:(NSString *)scheme;
+ (void)clear;

+ (BOOL)canOpenScheme:(NSString *)scheme;
+ (UIViewController *)open:(NSString *)scheme param:(NSDictionary *)param transitionType:(TransitionType)transitionType;
/**
 *  根据地址显示视图控制器
 *
 *  @param fullUrl 完整的地址，比如@"blogDetail://blogId=88&showComment=0"
 *
 *  @return 将打开的视图控制器
 */
+ (UIViewController *)openURL:(NSString *)fullUrl;
+ (void)closeCurrentViewController;

+ (UIViewController *)currentViewController;

@end
