//
//  WXChatListHeaderCell.m
//  WXChat
//
//  Created by WDX on 2019/6/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXChatListHeaderCell.h"

@implementation WXChatListHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

- (void)_setupTitleLabelConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarView);
        make.left.equalTo(self.avatarView.mas_right).offset(10);
    }];
}
@end
