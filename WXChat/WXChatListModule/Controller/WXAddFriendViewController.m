//
//  WXAddFriendViewController.m
//  WXChat
//
//  Created by WDX on 2019/6/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXAddFriendViewController.h"

@interface WXAddFriendViewController ()
/**
 * textfield
 */
@property (nonatomic, strong) UITextField *textField;
@end

@implementation WXAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    self.view.backgroundColor = k_background_color;
    [self setupUI];
}

- (void)setupUI{
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.left.right.equalTo(@0);
        make.height.equalTo(@60);
    }];
    
    //放大镜图片
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"magnifying_glass"]];
    [containerView addSubview:iconView];
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"输入对方的手机号";
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.keyboardType = UIKeyboardTypePhonePad;
    [_textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [containerView addSubview:_textField];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).offset(20);
        make.centerY.equalTo(containerView);
        make.width.height.equalTo(@30);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10);
        make.centerY.equalTo(containerView);
        make.right.offset(-30);
    }];
}


-(void)changedTextField:(id)textField{
    if (_textField.text.length == 11){
        if ([WXValidationTool validateCellPhoneNumber:_textField.text]){
            //网络请求
        }else{
            [MBProgressHUD showError:@"手机号不合法"];
        }
    }
}
@end

