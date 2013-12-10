//
//  UIViewController+BaseViewController.m
//  Ginbaseo
//
//  Created by Jiang Chuncheng on 8/25/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

#import "UIViewController+BaseViewController.h"

@implementation UIViewController (BaseViewController)

+ (void)load {
    NSLog(@"load %@", self);
    original_viewDidLoad = class_replaceMethod([self class], @selector(viewDidLoad), (IMP)base_viewDidLoad, NULL);
    
//    original_pushViewController = class_replaceMethod([self class], @selector(pushViewController:animated:), (IMP)base_pushViewController, NULL);
    
    original_presentViewController = class_replaceMethod([self class], @selector(presentViewController:animated:completion:), (IMP)base_presentViewController, NULL);
}


IMP original_viewDidLoad;
void base_viewDidLoad(id SELF, SEL _cmd) {
    /*
     // FIXME: EXC_BAD_ACCESS
    if (original_viewDidLoad) {
        original_viewDidLoad(SELF, _cmd);
    }
     */
    
    NSLog(@"addition for [%@ %@] after %p", SELF, NSStringFromSelector(_cmd), original_viewDidLoad);
}

/*
IMP original_pushViewController;
void base_pushViewController(id SELF, SEL _cmd, UIViewController *viewController, BOOL animated) {
    if (base_pushViewController) {
        base_pushViewController(SELF, _cmd, viewController, animated);
    }
    
    NSLog(@"addition for [%@ %@] after %p", SELF, NSStringFromSelector(_cmd), base_pushViewController);
}
*/

IMP original_presentViewController;
void base_presentViewController(id SELF, SEL _cmd, UIViewController *viewControllerToPresent, BOOL flag, id completion) {
    if (original_presentViewController) {
        original_presentViewController(SELF, _cmd, viewControllerToPresent, flag, completion);
    }
    
    NSLog(@"addition for [%@ %@] after %p", SELF, NSStringFromSelector(_cmd), original_presentViewController);
}


@end
