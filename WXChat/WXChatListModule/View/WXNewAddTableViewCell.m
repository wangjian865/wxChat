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
}
- (IBAction)agreeAction:(UIButton *)sender {
    [MineViewModel handleFriendRequestWithIfAgree:@"1" friendId:_model.friendshowfuserid success:^(NSString * result) {
        NSLog(@"1");
        if (self.handleCallBack){
            self.handleCallBack();
        }
    } failure:^(NSError * error) {
        
    }];
}

@end
