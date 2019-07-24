//
//  WXContactCell.m
//  WXChat
//
//  Created by WX on 2019/7/17.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXContactCell.h"

@implementation WXContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(FriendModel *)model{
    _model = model;
    
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:model.tgusetimg] placeholderImage:[UIImage imageNamed:@"normal_icon"]];
    _phoneLabel.text = model.tgusetaccount;
    _nameLabel.text = model.tgusetname;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
