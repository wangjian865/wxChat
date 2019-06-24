//
//  WXMailListHeaderView.m
//  MailDemo
//
//  Created by WDX on 2019/6/19.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMailListHeaderView.h"
#import "Masonry.h"

@implementation WXMailListHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"所有未读";
    label.textColor = rgb(48,134,191);
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont systemFontOfSize:14];
    _countLabel.text = @"999";
    _countLabel.textColor = rgb(48,134,191);
    
    [self addSubview:label];
    [self addSubview:_countLabel];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@15);
    }];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-19);
        make.centerY.equalTo(self);
    }];
}
@end
