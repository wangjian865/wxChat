//
//  WXTransitionDelegate.h
//  WXChat
//
//  Created by WDX on 2019/6/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate>
//! If this transition will be interactive, this property is set to the
//! gesture recognizer which will drive the interactivity.
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *gestureRecognizer;

@property (nonatomic, readwrite) UIRectEdge targetEdge;
@end

NS_ASSUME_NONNULL_END
