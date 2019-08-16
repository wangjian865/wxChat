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
//    _timeLabel.text = [Utility getMomentTime:infoModel.enterpriseztime];
    _timeLabel.text = [Utility getMessageTime:infoModel.enterpriseztime];
    NSArray *urlArr = [infoModel.enterprisezfujina componentsSeparatedByString:@","];
    NSString *url = urlArr.firstObject;
    if ([url isEqualToString:@""] || url == nil){
        //无图片
        _imgWidth.constant = 0;
    }else{
        _imgWidth.constant = 68;
        [_iconView sd_setImageWithURL:[NSURL URLWithString:urlArr.firstObject]];
    }
    
    _contentLabel.text = infoModel.enterprisezcontent;
}
@end
