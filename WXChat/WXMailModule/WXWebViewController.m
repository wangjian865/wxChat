//
//  WXWebViewController.m
//  WXChat
//
//  Created by WDX on 2019/6/12.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXWebViewController.h"
#import "MMWebView.h"
@interface WXWebViewController ()<MMWebViewDelegate>
/**
 * webView
 */
@property (nonatomic, strong) MMWebView *webView;
@end

@implementation WXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebView];
}

- (void)setupWebView{
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString * appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL * baseURL = [NSURL fileURLWithPath:htmlPath];
    
    _webView = [[MMWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.displayProgressBar = YES; // 显示进度条
    _webView.allowBackGesture = YES;  // 允许侧滑返回
    [_webView setupJSBridge];  // JS交互
    [_webView registerHandler:@"testObjcCallback" handler:^(id data, WVJSResponseCallback responseCallback) {
        responseCallback(@"Response from testObjcCallback");
    }];
    [_webView callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    [_webView loadHTMLString:@"" baseURL:nil];
    [self.view addSubview:_webView];
}

@end
