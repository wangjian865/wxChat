//
//  MBProgressHUD+NJ.m
//  NJWisdomCard
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import "MBProgressHUD+NJ.h"

@implementation MBProgressHUD (NJ)

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    [self hideHUDForView:view];
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.color = [UIColor blackColor];
    
    hud.labelColor = [UIColor whiteColor];
    hud.opacity = 0.8;
    hud.labelText = text;
    hud.labelFont = [UIFont systemFontOfSize:16];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 0.8秒之后再消失
    
    [hud hide:(BOOL)YES afterDelay:0.8];
}
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}


+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:nil view:view];
}

+ (void)showText:(NSString *)text toView:(UIView *)view{
    [self show:text icon:nil view:view];
}
+ (void)showText:(NSString *)text{
    [self showText:text toView:nil];
}

+(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}

+ (void)showTestWithJudgeView:(UIViewController *)controller text:(NSString *)text{
    
    if ([self isCurrentViewControllerVisible:controller]) {
        [self showText:text];
    }
}

+ (void)showHUD{
    [self showLoding:nil];
}
+ (void)showLoding:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.backgroundColor = [UIColor clearColor];
}
+ (void)showLodingText:(NSString *)text toView:(UIView *)view{
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.backgroundColor = [UIColor blackColor];
    hud.labelColor = [UIColor whiteColor];
    hud.labelText = text;
    hud.labelFont = [UIFont systemFontOfSize:16];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
}


+ (void)hideHUD{
    [self hideHUDForView:nil];
}
+ (void)hideHUDForView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [self hideHUDForView:view animated:YES];
}

@end
