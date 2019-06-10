//
//  WXResultSectionHeaderView.m
//  WXChat
//
//  Created by WDX on 2019/6/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXResultSectionHeaderView.h"

@implementation WXResultSectionHeaderView

- (instancetype)init{
    self = [super init];
    if (self){
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.backgroundColor = UIColor.redColor;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"section Title";
    _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12.0f];
    _titleLabel.textColor = rgb(102,102,102);
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@14);
        make.bottom.equalTo(@-8);
    }];
}
@end
