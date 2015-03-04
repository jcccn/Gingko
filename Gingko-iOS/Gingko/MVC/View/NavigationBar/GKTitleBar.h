//
//  GKTitleBar.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/14/15.
//  Copyright (c) 2015 SenseForce. All rights reserved.
//

/**
 *  界面的标题栏
 */

#import <UIKit/UIKit.h>

#import <BlocksKit/BlocksKit.h>

#import "GKCore.h"

#define kDefaultTitleBarHeight  44.0f

@class GKRouter;

@interface GKTitleBar : UIView {
    
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, assign) BOOL hidesBackButton;

@property (nonatomic, strong) UIButton *leftBarButton;
@property (nonatomic, strong) UIButton *rightBarButton;

@property (nonatomic, weak) IBOutlet UIViewController *viewController;

+ (instancetype)defaultTitleBar;

@end
