//
//  GKBaseViewController.h
//  Gingko
//
//  Created by Jiang Chuncheng on 8/25/13.
//  Copyright (c) 2013 SenseForce. All rights reserved.
//

/**
 *  视图控制器的基类
 */

#import <UIKit/UIKit.h>

#import "GKCore.h"
#import "GKRouter.h"
#import "UIViewController+ADTransitionController.h"
#import "GKTitleBar.h"

@interface GKBaseViewController : UIViewController {
    
}

@property (nonatomic, copy) NSDictionary *param;

@property (nonatomic, strong) GKTitleBar *titleBar;

//---------------->>>>>>声明周期>>>>>>>>
//loadParam → viewDidLoad → loadData → initSubviews → layoutView → viewWillAppear → viewDidApprear → viewWillDisappear → viewDidDisappear → freeData → dealloc
- (void)loadParam;
- (void)loadData;       //加载缓存等数据
- (void)initSubviews;   //初始化额外的子类
- (void)freeData;       //清理缓存等数据

//<<<<<<<<声明周期<<<<<<<<<-------------

@end
