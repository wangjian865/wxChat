//
//  WXMessageAlertViewCell.m
//  WXChat
//
//  Created by WDX on 2019/6/12.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMessageAlertViewCell.h"
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
    _nameLabel.text = @"this is name";
    [self.contentView addSubview:_nameLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.text = @"this is description";
    [self.contentView addSubview:_descriptionLabel];
}

- (void)layoutSubviews{
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(15);
        make.top.offset(14);
        make.width.equalTo(self.avatarView.mas_height);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
        make.left.equalTo(self.avatarView.mas_right).offset(25);
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.contentView.mas_centerY).offset(2);
    }];
}
@end
