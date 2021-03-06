//
//  WXDiscoverViewCell.m
//  WXChat
//
//  Created by WDX on 2019/6/17.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXDiscoverViewCell.h"
@interface WXDiscoverViewCell ()

@end
@implementation WXDiscoverViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
        
    }
    return self;
}
- (void)setupUI{
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = rgb(21,21,21);
    _titleLabel.text = @"企业圈";
    [self.contentView addSubview:_titleLabel];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = k_background_color;
    [self.contentView addSubview:_line];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont systemFontOfSize:13];
    _countLabel.textColor = UIColor.whiteColor;
    _countLabel.backgroundColor = UIColor.redColor;
    _countLabel.cornerRadius = 17/2;
    [_countLabel sizeToFit];
    _countLabel.hidden = YES;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_countLabel];
    
    _unreadIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:_unreadIcon];
    
}
- (void)layoutSubviews{
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.left.equalTo(@17);
        make.centerY.equalTo(self.contentView);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).offset(17);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
        make.centerY.equalTo(self.iconView);
        make.height.equalTo(@17);
        make.width.greaterThanOrEqualTo(@17);
    }];
    [_unreadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-50);
        make.centerY.equalTo(self.iconView);
        make.width.height.equalTo(@35);
    }];
}
@end
