//
//  WXMailBottomCell.m
//  MailDemo
//
//  Created by 王坚 on 2019/6/21.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMailBottomCell.h"
#import "Masonry.h"
@interface WXMailBottomCell ()
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel *titleLabel;
@end
@implementation WXMailBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
        self.separatorInset = UIEdgeInsetsMake(0, 700, 0, 0);
    }
    return self;
}
- (void)setupUI{
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.contentView);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = rgb(51,51,51);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"添加邮箱";
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.iconView.mas_right).offset(22);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = rgb(224, 224, 224);
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = rgb(224, 224, 224);
    [self.contentView addSubview:topLine];
    [self.contentView addSubview:bottomLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
    _iconView.image = [UIImage imageNamed:title];
}
@end
