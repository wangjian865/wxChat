//
//  WXPhotoCollectionViewCell.m
//  WXChat
//
//  Created by WX on 2019/7/12.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXPhotoCollectionViewCell.h"

@implementation WXPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteAction:(UIButton *)sender {
    if (_deletePhotoAction){
        _deletePhotoAction();
    }
}
- (void)beginShake
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.duration = 0.2;
    anim.repeatCount = MAXFLOAT;
    anim.values = @[@(-0.03),@(0.03),@(-0.03)];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anim forKey:@"shake"];
}
- (void)stopShake
{
    [self.layer removeAllAnimations];
}
@end
