//
//  GKWebViewController.m
//  Gingko
//
//  Created by Jiang Chuncheng on 2/11/14.
//  Copyright (c) 2014 SenseForce. All rights reserved.
//

#import "GKWebViewController.h"

@interface GKWebViewController () {
    
}

@property (nonatomic, strong) WebViewJavascriptBridge *jsBridge;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) NSString *url;

- (void)loadUrl:(NSString *)urlString;

@end

@implementation GKWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    WeakSelf
    self.jsBridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        id responseDataFromObjC = [weakSelf receivedWebviewAction:data];
        responseCallback(responseDataFromObjC);
    }];
    
    [self loadUrl:self.url];
}

- (void)loadParam {
    self.url = self.param[GKParamUrl];
}

- (void)loadUrl:(NSString *)urlString {
    if ([GKStringUtils isEmpty:urlString]) {
        return;
    }
    if ([urlString rangeOfString:[[NSBundle mainBundle] resourcePath]].location != NSNotFound) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:urlString isDirectory:NO]]];
    }
    else {
        NSURL *url = [NSURL URLWithString:urlString];
        if ( ! [[url scheme] length]) {
            url = [NSURL URLWithString:[@"http://" stringByAppendingString:urlString]];
        }
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (id)receivedWebviewAction:(id)dictionary {
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWitGKequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //禁用长按弹出行为表单
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout = \"none\""];
    
    if ([self shouldShowHtmlInnerTitle]) {
        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if ( ! [GKStringUtils isEmpty:title]) {
            self.title = title;
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end
