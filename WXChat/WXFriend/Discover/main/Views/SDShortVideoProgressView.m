//
//  SDShortVideoProgressView.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/12.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import "SDShortVideoProgressView.h"

@implementation SDShortVideoProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _progressLine = [UIView new];
    _progressLine.backgroundColor = Global_tintColor;
    [self addSubview:_progressLine];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    if (progress >= 0 && progress <= 1.0) {
        [self updateProgressLineWithProgress:progress];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _progressLine.frame = self.bounds;
}

- (void)updateProgressLineWithProgress:(CGFloat)Progress
{
    if (_progressLine.width > self.width) {
        _progressLine.frame = self.bounds;
        _progressLine.transform = CGAffineTransformIdentity;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat x = MIN((1 - Progress), 1);
        _progressLine.transform = CGAffineTransformMakeScale(x, 1);
        [_progressLine setNeedsDisplay];
    });
}

@end

