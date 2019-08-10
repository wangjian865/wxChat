//
//  WXMailListSectionCell.m
//  MailDemo
//
//  Created by WDX on 2019/6/19.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMailListSectionCell.h"
#import "Masonry.h"
@interface WXMailListSectionCell ()

@end
@implementation WXMailListSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.contentView.backgroundColor = rgb(240,240,240);
    
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    _iconView.image = [UIImage imageNamed:@"蓝色箭头"];
    _accountLabel = [[UILabel alloc] init];
    _accountLabel.textColor = rgb(48,134,191);
    _accountLabel.font = [UIFont systemFontOfSize:14];
    _accountLabel.text = @"314319645@qq.com";
    [self.contentView addSubview:_accountLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = rgb(48,134,191);
    _countLabel.font = [UIFont systemFontOfSize:14];
    _countLabel.text = @"3";
    [self.contentView addSubview:_countLabel];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@15);
        make.width.height.equalTo(@8);
    }];
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(17);
        make.centerY.equalTo(self.contentView);
    }];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-19);
        make.centerY.equalTo(self.contentView);
    }];
}
- (void)setIsShow:(BOOL)isShow{
    _isShow = isShow;
    if (isShow){
        [UIView animateWithDuration:0.3 animations:^{
            self.iconView.transform = CGAffineTransformMakeRotation(M_PI/4*3);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.iconView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}
@end
