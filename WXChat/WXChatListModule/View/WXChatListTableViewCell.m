//
//  WXChatListTableViewCell.m
//  WXChat
//
//  Created by WDX on 2019/6/5.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXChatListTableViewCell.h"
@interface WXChatListTableViewCell ()
/**
 * badge
 */
@property (nonatomic, strong) UILabel *badgeLabel;
@end
@implementation WXChatListTableViewCell{
    CGFloat _badgeWidth;
}

#pragma mark - Setup Constraints


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //自定义UI
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _badgeWidth = 15;
        [self _setWX_UI];
    }
    
    return self;
}
- (void)_setWX_UI{
    _badgeLabel = [[UILabel alloc] init];
    _badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    _badgeLabel.textColor = UIColor.whiteColor;
    _badgeLabel.backgroundColor = UIColor.redColor;
    _badgeLabel.font = [UIFont boldSystemFontOfSize:11];
    _badgeLabel.hidden = YES;
    _badgeLabel.layer.cornerRadius = _badgeWidth/2;
    _badgeLabel.clipsToBounds = YES;
    _badgeLabel.hidden = YES;
    [self addSubview:_badgeLabel];
    [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-21);
        make.bottom.offset(-9);
        make.width.height.mas_equalTo(self->_badgeWidth);
    }];
}
- (void)setModel:(id<IConversationModel>)model{
    [super setModel:model];
    self.avatarView.showBadge = NO;
    if (model.conversation.unreadMessagesCount == 0) {
        _badgeLabel.hidden = YES;
    }
    else{
        _badgeLabel.hidden = NO;
        [self setBadge:model.conversation.unreadMessagesCount];
    }
}
- (void)setBadge:(NSInteger)badge
{
    if (badge > 0) {
        self.badgeLabel.hidden = NO;
    }
    else{
        self.badgeLabel.hidden = YES;
    }
    
    if (badge > 99) {
        self.badgeLabel.text = @"N+";
    }else{
        self.badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)badge];
    }
    if (badge >= 10){
        [_badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1.5*(self->_badgeWidth));
        }];
    }else{
        [_badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self->_badgeWidth);
        }];
    }
}
/*!
 @method
 @brief 设置avatarView的约束
 @discussion
 @return
 */
- (void)_setupAvatarViewConstraints
{
    self.avatarView.imageCornerRadius = 22.5;
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(14);
        make.width.height.equalTo(@45);
    }];
}

/*!
 @method
 @brief 设置timeLabel的约束
 @discussion
 @return
 */
//无需变动
//- (void)_setupTimeLabelConstraints
//{
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseConversationCellPadding]];
//
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
//}

/*!
 @method
 @brief 设置titleLabel的约束
 @discussion
 @return
 */
//- (void)_setupTitleLabelConstraints
//{
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:-EaseConversationCellPadding]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.timeLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseConversationCellPadding]];
//
//    self.titleWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseConversationCellPadding];
//    self.titleWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding];
//    [self addConstraint:self.titleWithAvatarLeftConstraint];
//}

/*!
 @method
 @brief 设置detailLabel的约束
 @discussion
 @return
 */
//- (void)_setupDetailLabelConstraints
//{
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseConversationCellPadding]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseConversationCellPadding]];
//
//    self.detailWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseConversationCellPadding];
//    self.detailWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding];
//    [self addConstraint:self.detailWithAvatarLeftConstraint];
//}

@end
