//
//  SDEyeAnimationView.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/11.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "SDEyeAnimationView.h"

static const CGFloat kEyeImageViewWidth = 65.0f;
static const CGFloat kEyeImageViewHeight = 44.0f;

@implementation SDEyeAnimationView
{
    UIImageView *_eyeImageView;
    CGFloat _originalY;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _eyeImageView = [UIImageView new];
    _eyeImageView.image = [UIImage imageNamed:@"icon_sight_capture_mask"];
    [self addSubview:_eyeImageView];
    
    _eyeImageView.sd_layout
    .widthIs(kEyeImageViewWidth)
    .heightIs(kEyeImageViewHeight)
    .centerXEqualToView(self)
    .centerYEqualToView(self);
    self.progress = 0.0;
}

- (void)progressAnimationWithProgress:(CGFloat)progress
{
    
    CGFloat eyeViewProgress = MIN(progress, 1);
    CGFloat w = kEyeImageViewWidth * eyeViewProgress;
    CGFloat h = kEyeImageViewHeight;
    if (w < h) {
        h = w;
    }
    CGFloat x = (kEyeImageViewWidth - w) * 0.5;
    CGFloat y = (kEyeImageViewHeight - h) * 0.5;
    CGRect rect = CGRectMake(x, y, w, h);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.path = path.CGPath;
    
    _eyeImageView.layer.mask = mask;
    _eyeImageView.alpha = progress;
    
    
    
    if (_originalY == 0) {
        _originalY = self.top;
    }
    
    CGFloat move = 30 * progress;
    self.top = _originalY + move;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self progressAnimationWithProgress:progress];
}

@end
