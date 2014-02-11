//
//  GKWebViewController.h
//  Gingko
//
//  Created by Jiang Chuncheng on 2/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

/**
 *  网页浏览视图控制器
 */

#import "GKBaseViewController.h"

#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

@interface GKWebViewController : GKBaseViewController <UIWebViewDelegate> {
    
}

@property (nonatomic, assign) BOOL shouldShowHtmlInnerTitle;    //是否显示网页自带的标题

- (id)receivedWebviewAction:(id)dictionary;

@end
