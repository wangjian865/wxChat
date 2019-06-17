//
//  WXMessageAlertViewCell.m
//  WXChat
//
//  Created by WDX on 2019/6/12.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMessageAlertViewCell.h"
#import "WXMessageAlertModel.h"
@interface WXMessageAlertViewCell ()
/**
 * 头像
 */
@property (nonatomic, strong) UIImageView *avatarView;
/**
 * 姓名
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 * 描述
 */
@property (nonatomic, strong) UILabel *descriptionLabel;
/**
 * 功能按钮
 */
@property (nonatomic, strong) UIButton *button;
@end
@implementation WXMessageAlertViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    _avatarView = [[UIImageView alloc] init];
    _avatarView.image = [UIImage imageNamed:@"normal_icon"];
    [self.contentView addSubview:_avatarView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"周杰伦";
    [self.contentView addSubview:_nameLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.text = @"申请加入周杰伦唱片公司";
    [self.contentView addSubview:_descriptionLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"同意" forState:UIControlStateNormal];
    [_button setTitleColor:rgb(48,134,191) forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:12];
    _button.layer.borderColor = rgb(48,134,191).CGColor;
    _button.layer.borderWidth = 1;
    [self.contentView addSubview:_button];
}

- (void)layoutSubviews{
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(15);
        make.width.height.equalTo(@47);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
        make.left.equalTo(self.avatarView.mas_right).offset(25);
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.contentView.mas_centerY).offset(2);
    }];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(k_current_Width(-14));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@38);
        make.height.equalTo(@24);
    }];
}
- (void)setModel: (WXMessageAlertModel *)model{
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl]];
    _nameLabel.text = model.name;
    _descriptionLabel.text = model.descriptionText;
}
@end