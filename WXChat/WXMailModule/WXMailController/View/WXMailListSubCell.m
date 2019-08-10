//
//  WXMailListSubCell.m
//  MailDemo
//
//  Created by WDX on 2019/6/19.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMailListSubCell.h"
#import "Masonry.h"

@interface WXMailListSubCell ()
/**
 * icon
 */
@property (nonatomic, strong) UIImageView *iconView;
/**
 * label
 */
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation WXMailListSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupUI];
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
    _iconView.image = [UIImage imageNamed:title];
}
- (void)setupUI{
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.contentView);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = rgb(21,21,21);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"this title label";
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.iconView.mas_right).offset(15);
    }];
}
@end
