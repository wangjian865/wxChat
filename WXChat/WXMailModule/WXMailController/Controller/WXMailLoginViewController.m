//
//  WXMailLoginViewController.m
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMailLoginViewController.h"
#import "ViewMailConfigController.h"
#import "MailViewModel.h"
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
    [MailViewModel loginMailWithMailAccount:@"wdxzstdl@163.com" password:@"wj86565902" accountType:@"163" successBlock:^(NSString * _Nonnull data) {
        NSLog(@"1");
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
- (IBAction)configAction:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewMailConfigController *configVC = [sb instantiateViewControllerWithIdentifier:@"mailConfigVC"];
    [self.navigationController pushViewController:configVC animated:true];
}
- (IBAction)loginErrorAction:(UIButton *)sender {
    NSLog(@"登录有问题");
}


@end
