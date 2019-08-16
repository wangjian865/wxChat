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
}
@end
