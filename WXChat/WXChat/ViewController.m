//
//  ViewController.m
//  WXChat
//
//  Created by WDX on 2019/4/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"ftp://eline:8&-x68T5-krbyD-s3@10.40.59.73/project/78b3b2815bdb43adbda2d192eec8f6e6_1.XXX产品_项目立项报告 (1).pptx"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [self.view addSubview:webView];
    
    [webView loadRequest: request];
    
}


@end
