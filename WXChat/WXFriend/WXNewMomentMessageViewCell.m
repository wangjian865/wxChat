//
//  WXNewMomentMessageViewCell.m
//  WXChat
//
//  Created by WX on 2019/7/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXNewMomentMessageViewCell.h"

@implementation WXNewMomentMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(CommentInfo *)model{
    _model = model;
    [_userIconView sd_setImageWithURL:[NSURL URLWithString:model.commentsTgusetImg]];
    _nameLabel.text = model.commentsTgusetName;
    _contentLabel.text = model.commentsContext;
    _timeLabel.text = [Utility getMomentTime:model.commentsDatetime];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
