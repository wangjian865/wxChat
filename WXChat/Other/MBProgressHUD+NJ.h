//
//  MBProgressHUD+NJ.h
//  NJWisdomCard
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (NJ)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text toView:(UIView *)view;

+ (void)showLoding:(UIView *)view;

+ (void)showLodingText:(NSString *)str toView:(UIView *)view;
+ (void)showHUD;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
