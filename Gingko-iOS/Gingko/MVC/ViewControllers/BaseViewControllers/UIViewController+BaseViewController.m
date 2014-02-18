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
    NSLog(@"load class %@", self);
    [self jr_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(swizzle_viewDidLoad) error:NULL];
}

- (void)swizzle_viewDidLoad {
    //Do something before origin viewDidLoad
    [self swizzle_viewDidLoad];
}

@end
