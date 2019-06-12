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
    
}
@end
