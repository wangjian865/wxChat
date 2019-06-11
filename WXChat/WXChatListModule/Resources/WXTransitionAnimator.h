//
//  WXTransitionAnimator.h
//  WXChat
//
//  Created by WDX on 2019/6/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
- (instancetype)initWithTargetEdge:(UIRectEdge)targetEdge;

@property (nonatomic, readwrite) UIRectEdge targetEdge;
@end

NS_ASSUME_NONNULL_END
