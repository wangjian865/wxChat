//
//  WXMyMomentTableViewCell.m
//  WXChat
//
//  Created by WX on 2019/8/4.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMyMomentTableViewCell.h"
#import "Utility.h"
@implementation WXMyMomentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setInfoModel:(FriendMomentInfo *)infoModel{
    _infoModel = infoModel;
    _timeLabel.text = [Utility getMomentTime:infoModel.enterpriseztime];
    NSArray *urlArr = [infoModel.enterprisezfujina componentsSeparatedByString:@","];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:urlArr.firstObject]];
    _contentLabel.text = infoModel.enterprisezcontent;
}
@end
