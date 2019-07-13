//
//  WXMailLoginViewController.m
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMailLoginViewController.h"

@interface WXMailLoginViewController ()

@end

@implementation WXMailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
}
- (void)setupNavi{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(mailLoginAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (void)mailLoginAction {
    NSLog(@"登录邮箱");
}


@end
