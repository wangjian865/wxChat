//
//  WXTransitionDelegate.m
//  WXChat
//
//  Created by WDX on 2019/6/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXTransitionDelegate.h"
#import "WXInteractiveTransition.h"
#import "WXAnimatedTransitioning.h"
#import "WXTransitionAnimator.h"
@implementation WXTransitionDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[WXTransitionAnimator alloc] initWithTargetEdge:self.targetEdge];
}


//| ----------------------------------------------------------------------------
//  The system calls this method on the presented view controller's
//  transitioningDelegate to retrieve the animator object used for animating
//  the dismissal of the presented view controller.  Your implementation is
//  expected to return an object that conforms to the
//  UIViewControllerAnimatedTransitioning protocol, or nil if the default
//  dismissal animation should be used.
//
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[WXTransitionAnimator alloc] initWithTargetEdge:self.targetEdge];
}


//| ----------------------------------------------------------------------------
//  If a <UIViewControllerAnimatedTransitioning> was returned from
//  -animationControllerForPresentedController:presentingController:sourceController:,
//  the system calls this method to retrieve the interaction controller for the
//  presentation transition.  Your implementation is expected to return an
//  object that conforms to the UIViewControllerInteractiveTransitioning
//  protocol, or nil if the transition should not be interactive.
//
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    // You must not return an interaction controller from this method unless
    // the transition will be interactive.
    if (self.gestureRecognizer)
        return [[WXInteractiveTransition alloc] initWithGestureRecognizer:self.gestureRecognizer edgeForDragging:self.targetEdge];
    else
        return nil;
}


//| ----------------------------------------------------------------------------
//  If a <UIViewControllerAnimatedTransitioning> was returned from
//  -animationControllerForDismissedController:,
//  the system calls this method to retrieve the interaction controller for the
//  dismissal transition.  Your implementation is expected to return an
//  object that conforms to the UIViewControllerInteractiveTransitioning
//  protocol, or nil if the transition should not be interactive.
//
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    // You must not return an interaction controller from this method unless
    // the transition will be interactive.
    if (self.gestureRecognizer)
        return [[WXInteractiveTransition alloc] initWithGestureRecognizer:self.gestureRecognizer edgeForDragging:self.targetEdge];
    else
        return nil;
}
@end