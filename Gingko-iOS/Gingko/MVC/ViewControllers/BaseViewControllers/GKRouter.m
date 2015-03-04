//
//  GKRouter.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

#import "GKRouter.h"

#import "GKBaseViewController.h"

NSString *const GKSchemeWebView = @"webview";
NSString *const GKSchemePhotoViewer = @"photoview";

NSString *const GKParamUrl = @"url";
NSString *const GKParamTitle = @"title";

// 生成视图控制器的方式
typedef NS_ENUM(NSUInteger, ViewControllerNewType) {
    ViewControllerNewTypeXib,           //从ib里面加载，[[ViewControllerClass alloc] initWithNibName:nil bundle:nil]
    ViewControllerNewTypeStoryboard,    //从Storyboard里面加载
    ViewControllerNewTypeClass,         //直接初始化 [[ViewControllerClass alloc] init]
    ViewControllerNewTypeInstance       //已经是实例化的对象
};

@interface GKSchemeItem : NSObject

@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, assign) ViewControllerNewType newType;
@property (nonatomic, strong) id classOrInstance;
//@property (nonatomic, strong) id otherInfo;

@end



@interface GKRouter ()

@property (nonatomic, strong) NSMutableDictionary *schemeMap;

@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, weak) UITabBarController *tabBarController;
@property (nonatomic, strong) UIStoryboard *storyboard;

@property (nonatomic, weak) UIViewController *currentViewController;

+ (GKRouter *)sharedInstance;

- (UIViewController *)viewControllerFromSchemeItem:(GKSchemeItem *)item;

+ (UIViewController *)searcGKootViewController;

@end


@implementation GKRouter

+ (GKRouter *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (id)init {
    self = [super init];
    if (self) {
        self.schemeMap = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (void)setRootViewController:(UIViewController *)rootController {
    [self sharedInstance].rootViewController = rootController;
}

+ (void)setNavigationController:(UINavigationController *)navigationController {
    [self sharedInstance].navigationController = navigationController;
}

+ (void)setTabBarController:(UITabBarController *)tabBarController {
    [self sharedInstance].tabBarController = tabBarController;
}

+ (void)setStoryboard:(UIStoryboard *)storyboard {
    [self sharedInstance].storyboard = storyboard;
}

+ (void)map:(NSString *)scheme toViewControllerName:(NSString *)className {
    if(scheme && className) {
        GKSchemeItem *schemeItem = [[GKSchemeItem alloc] init];
        schemeItem.scheme = scheme;
        schemeItem.newType = ViewControllerNewTypeXib;      //使用这种类别是可以的，nibName参数为空来自动搜索
        schemeItem.classOrInstance = className;
        
        [self sharedInstance].schemeMap[scheme] = schemeItem;
    }
}

+ (void)map:(NSString *)scheme toViewControllerStoryboadId:(NSString *)storyboardIdentifier {
    if(scheme && storyboardIdentifier) {
        GKSchemeItem *schemeItem = [[GKSchemeItem alloc] init];
        schemeItem.scheme = scheme;
        schemeItem.newType = ViewControllerNewTypeStoryboard;
        schemeItem.classOrInstance = storyboardIdentifier;
        
        [self sharedInstance].schemeMap[scheme] = schemeItem;
    }
}

+ (void)map:(NSString *)scheme toViewController:(GKBaseViewController *)viewController {
    if(scheme && viewController) {
        GKSchemeItem *schemeItem = [[GKSchemeItem alloc] init];
        schemeItem.scheme = scheme;
        schemeItem.newType = ViewControllerNewTypeInstance;
        schemeItem.classOrInstance = viewController;
        
        [self sharedInstance].schemeMap[scheme] = schemeItem;
    }
}

+ (void)unmap:(NSString *)scheme {
    if (scheme) {
        [[self sharedInstance].schemeMap removeObjectForKey:scheme];
    }
}

+ (void)clear {
    [[self sharedInstance].schemeMap removeAllObjects];
}

+ (BOOL)canOpenScheme:(NSString *)scheme {
    if ( ! scheme) {
        return NO;
    }
    return ([self sharedInstance].schemeMap[scheme] != nil);
}

+ (UIViewController *)open:(NSString *)scheme param:(NSDictionary *)param transitionType:(TransitionType)transitionType {
    if ( ! scheme) {
        return nil;
    }
    
    UIViewController *viewController = [[self sharedInstance] viewControllerFromSchemeItem:[self sharedInstance].schemeMap[scheme]];
    if ( ! viewController) {
        return nil;
    }
    
    if ([viewController isKindOfClass:[GKBaseViewController class]]) {
        ((GKBaseViewController *)viewController).param = param;
    }
    
    UIViewController *curentViewController = [self currentViewController];
    
    if (curentViewController.transitionController) {
        ADTransition *transition = [[ADSwipeFadeTransition alloc] initWithDuration:0.3f
                                                                       orientation:ADTransitionBottomToTop
                                                                        sourceRect:curentViewController.view.frame];
        [curentViewController.transitionController pushViewController:viewController withTransition:transition];
    }
    else if(curentViewController.navigationController) {
        if (transitionType == TransitionTypeModal) {
            [curentViewController presentViewController:viewController animated:YES completion:NULL];
        }
        else {
            [curentViewController.navigationController pushViewController:viewController animated:YES];
        }
    }
    else {
        [curentViewController presentViewController:viewController animated:YES completion:NULL];
    }
    
    [self sharedInstance].currentViewController = viewController;
    
    return viewController;
}

+ (UIViewController *)openURL:(NSString *)fullUrl {
    //@"blogDetail://blogId=88&showComment=0"
    if ( ! [fullUrl length]) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:fullUrl];
    NSString *scheme = [url scheme];
    NSString *query = [url query];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    for (NSString *keyValue in [query componentsSeparatedByString:@"&"]) {
        NSArray *keyAndValues = [keyValue componentsSeparatedByString:@"="];
        if ([keyAndValues count] == 2) {
            param[keyAndValues[0]] = keyAndValues[1];
        }
    }
    
    return [self open:scheme param:param transitionType:TransitionTypePush];
}

+ (void)closeCurrentViewController {
    UIViewController *curentViewController = [self currentViewController];
    if (curentViewController.presentedViewController) {
        [curentViewController dismissViewControllerAnimated:YES completion:NULL];
    }
    else if (curentViewController.transitionController) {
        NSArray *viewControllers = curentViewController.transitionController.viewControllers;
        NSInteger index = [viewControllers indexOfObject:curentViewController];
        if (NSNotFound == index) {
            index = [viewControllers count] - 1;
        }
        UIViewController *newTopViewController = [viewControllers objectAtIndex:MAX(index - 1, 0)];
        [curentViewController.transitionController popViewController];  //这里会自动采用与push对应的pop动画！
        
        [self sharedInstance].currentViewController = newTopViewController;
    }
    else if(curentViewController.navigationController) {
        NSArray *viewControllers = curentViewController.navigationController.viewControllers;
        NSInteger index = [viewControllers indexOfObject:curentViewController];
        UIViewController *newTopViewController = [viewControllers objectAtIndex:MAX(index - 1, 0)];
        [curentViewController.navigationController popViewControllerAnimated:YES];
        
        [self sharedInstance].currentViewController = newTopViewController;
    }
    else {
        UIViewController *presentingViewController = curentViewController.presentingViewController;
        if (presentingViewController) {
            [presentingViewController dismissViewControllerAnimated:YES completion:NULL];
            [self sharedInstance].currentViewController = presentingViewController;
        }
    }
}

+ (UIViewController *)currentViewController {
    UIViewController *currentViewController = [self sharedInstance].currentViewController;
    if ( ! (currentViewController.isViewLoaded && currentViewController.view.window)) {
        // 搜寻当前的视图控制器
        UIViewController *rootViewController = [self searcGKootViewController];
        
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            currentViewController = [(UINavigationController *)rootViewController visibleViewController];
        }
        else if([rootViewController isKindOfClass:[ADTransitionController class]]) {
            currentViewController = [(ADTransitionController *)rootViewController visibleViewController];
        }
        else if([rootViewController isKindOfClass:[UITabBarController class]]) {
            UIViewController *selectedViewController = [(UITabBarController *)rootViewController selectedViewController];
            if (selectedViewController.presentedViewController) {
                currentViewController = selectedViewController.presentedViewController;
            }
            else {
                currentViewController = selectedViewController;
            }
        }
        else {
            // 难题啊！
            currentViewController = rootViewController;
        }
    }
    return currentViewController;
}

#pragma mark - Private

+ (UIViewController *)searcGKootViewController {
    
    if ([self sharedInstance].rootViewController) {
        return [self sharedInstance].rootViewController;
    }
    
    UIViewController *result;
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows) {
            if (topWindow.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil) {
        result = topWindow.rootViewController;
    }
    else {
        NSAssert(NO, @"找不到当前的根视图控制器");
    }
    return result;
}

- (UIViewController *)viewControllerFromSchemeItem:(GKSchemeItem *)item {
    UIViewController *viewController = nil;
    id handler = item.classOrInstance;
    ViewControllerNewType newType = item.newType;
    if (ViewControllerNewTypeInstance == newType) {
        viewController = handler;
    }
    else if (ViewControllerNewTypeStoryboard == newType) {
        if ( ! [handler isKindOfClass:[NSString class]]) {
            return nil;
        }
        @try {
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:handler];
        }
        @catch (NSException *exception) {
            NSLog(@"view controller with id \"%@\" is not found in storyboard!", handler);
        }
        @finally {
            
        }
    }
    else if (newType == ViewControllerNewTypeXib) {
        viewController = [[NSClassFromString(handler) alloc] initWithNibName:nil bundle:nil];
    }
    else if (newType == ViewControllerNewTypeClass) {
        viewController = [[NSClassFromString(handler) alloc] init];
    }
    
    // check
    if ( ! [viewController isKindOfClass:[UIViewController class]]) {
        return nil;
    }
    
    return viewController;
}

@end


@implementation GKSchemeItem


@end
