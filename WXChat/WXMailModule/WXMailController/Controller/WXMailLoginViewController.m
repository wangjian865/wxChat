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
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

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
    if (self.accountTF.text.length <= 0){
        [MBProgressHUD showError:@"请输入账号"];
        return;
    }
    if (self.passwordTF.text.length <= 0){
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    [MailViewModel loginMailWithMailAccount:self.accountTF.text password:self.passwordTF.text accountType:self.type successBlock:^(NSString * _Nonnull data) {
        [MBProgressHUD showSuccess:data];
        [self.navigationController popToRootViewControllerAnimated:true];
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
