//
//  WXNewAddTableViewCell.m
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXNewAddTableViewCell.h"

@implementation WXNewAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(WXMessageAlertModel *)model{
    _model = model;
    _timeLabel.text = [Utility getMomentTime:model.friendshowktime];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.tgusetImg]];
    _nameLabel.text = model.tgusetName;
    _contentLabel.text = model.friendshowcontext;
    // 48 134 191
    if ([model.friendshowifconsend isEqualToString:@"0"]){
        _agreeBtn.enabled = YES;
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        _agreeBtn.borderWithColor = rgb(48, 134, 191);
    }else if ([model.friendshowifconsend isEqualToString:@"1"]){
        _agreeBtn.enabled = NO;
        [_agreeBtn setTitle:@"已添加" forState:UIControlStateDisabled];
        _agreeBtn.borderWithColor = UIColor.lightGrayColor;
    }else {
        _agreeBtn.enabled = NO;
        [_agreeBtn setTitle:@"已拒绝" forState:UIControlStateDisabled];
        _agreeBtn.borderWithColor = UIColor.lightGrayColor;
    }
}
- (IBAction)agreeAction:(UIButton *)sender {
    [MineViewModel handleFriendRequestWithIfAgree:@"1" showId:_model.friendshowid success:^(NSString * result) {
        [MBProgressHUD showText:result];
        if (self.handleCallBack){
            self.handleCallBack();
        }
    } failure:^(NSError * error) {
        
    }];
}

@end
