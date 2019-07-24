//
//  WXAccountTool.h
//  WXChat
//
//  Created by WDX on 2019/6/6.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXAccountTool : NSObject
//判断用户是否登录
+ (BOOL)isLogin;
//获取token
+ (NSString *)getToken;
//获取手机号
+ (NSString *)getUserPhone;
//获取用户ID
+ (NSString *)getUserID;
//获取环信ID  登录后存在
+ (NSString *)getHuanXinID;

@end

NS_ASSUME_NONNULL_END
