//
//  WXAddCompanyViewController.m
//  WXChat
//
//  Created by 王坚 on 2019/6/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXAddCompanyViewController.h"

@interface WXAddCompanyViewController ()
@property (nonatomic, strong)UITextField *inputView;
@property (nonatomic, strong)UILabel *promptLabel;
@property (nonatomic, strong)UIView *companyView;

@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel *companyNameLabel;
@property (nonatomic, strong)UILabel *companyDescriptionLabel;
@property (nonatomic, strong)UILabel *companyCountLabel;
@end

@implementation WXAddCompanyViewController

- (UIView *)companyView{
    if (_companyView == nil){
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = UIColor.whiteColor;
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"旺旺集团";
        nameLabel.textColor = rgb(21,21,21);
        nameLabel.font = [UIFont systemFontOfSize:18];
        UILabel *descroptionLabel = [[UILabel alloc] init];
        descroptionLabel.text = @"旺仔牛奶,旺旺雪饼,旺旺大礼包";
        descroptionLabel.textColor = rgb(153,153,153);
        descroptionLabel.font = [UIFont systemFontOfSize:12];
        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.text = @"39人";
        countLabel.textColor = rgb(153,153,153);
        countLabel.font = [UIFont systemFontOfSize:12];
        
        _companyCountLabel = countLabel;
        _companyView = contentView;
        _iconView = imageView;
        _companyDescriptionLabel = descroptionLabel;
        _companyNameLabel = nameLabel;
        
        [_companyView addSubview:_iconView];
        [_companyView addSubview:_companyNameLabel];
        [_companyView addSubview:_companyDescriptionLabel];
        [_companyView addSubview:_companyCountLabel];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.top.mas_equalTo(12);
            make.centerY.equalTo(contentView);
            make.width.equalTo(imageView.mas_height);
        }];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(16);
            make.bottom.equalTo(contentView.mas_centerY).offset(-3);
            make.right.equalTo(contentView).offset(-50);
        }];
        [descroptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(contentView.mas_centerY).offset(3);
            make.right.equalTo(nameLabel);
        }];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.top.offset(15);
        }];
        
    }
    return _companyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = k_background_color;
    
    [self setupUI];
}
- (void)setupUI{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"公司编号";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = rgb(51,51,51);
    _promptLabel = label;
    [self.view addSubview:label];
    
    UITextField *textField = [[UITextField alloc] init];
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 21)];
    textField.leftView = leftV;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.textColor = rgb(51,51,51);
    textField.font = [UIFont systemFontOfSize:14];
    textField.backgroundColor = UIColor.whiteColor;
    _inputView = textField;
    [self.view addSubview:textField];
    [self.view addSubview:self.companyView];
}
- (void)viewDidLayoutSubviews{
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.offset(14);
    }];
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.promptLabel);
        make.left.equalTo(self.promptLabel.mas_right).offset(8);
        make.right.offset(-14);
        make.height.mas_equalTo(42);
    }];
    [_companyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(68);
        make.top.offset(74);
    }];
}


@end
