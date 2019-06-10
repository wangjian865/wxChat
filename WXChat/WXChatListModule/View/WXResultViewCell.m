//
//  WXResultViewCell.m
//  WXChat
//
//  Created by WDX on 2019/6/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXResultViewCell.h"
@interface WXResultViewCell ()
/**
 * 头像
 */
@property (nonatomic, strong) UIImageView *iconView;
/**
 * 名称
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 * 说明
 */
@property (nonatomic, strong) UILabel *promptLabel;
@end
@implementation WXResultViewCell

- (UIImageView *)iconView{
    if (_iconView == nil){
        _iconView = [[UIImageView alloc] init];
        //占位图
        _iconView.image = [UIImage imageNamed:@"normal_icon"];
    }
    return _iconView;
}
- (UILabel *)nameLabel{
    if (_nameLabel == nil){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = rgb(51,51,51);
        _nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        _nameLabel.text = @"This is a name";
    }
    return _nameLabel;
}
- (UILabel *)promptLabel{
    if (_promptLabel == nil){
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = @"This is a prompt";
        _promptLabel.textColor = rgb(153,153,153);
        _promptLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    }
    return _promptLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.promptLabel];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.promptLabel];
    }
    return self;
}
- (void)layoutSubviews{
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@14);
        make.top.equalTo(@11);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(self.iconView.mas_height);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
}


@end
