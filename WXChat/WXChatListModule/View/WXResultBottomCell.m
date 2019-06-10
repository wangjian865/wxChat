//
//  WXResultBottomCell.m
//  WXChat
//
//  Created by WDX on 2019/6/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXResultBottomCell.h"
@interface WXResultBottomCell ()
/**
 * 查看更多
 */
@property (nonatomic, strong) UILabel *moreLabel;
@end
@implementation WXResultBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    _moreLabel = [[UILabel alloc] init];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"查看更多 >"];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:12.0f] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:48.0f/255.0f green:134.0f/255.0f blue:191.0f/255.0f alpha:1.0f] range:NSMakeRange(0, attributedString.length)];
    _moreLabel.attributedText = attributedString;
    [self.contentView addSubview:_moreLabel];
    [_moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
    }];
}
@end

