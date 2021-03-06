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
///登出
+ (void)logout;
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
///获取用户名
+ (NSString *)getUserName;
///获取头像
+ (NSString *)getUserImage;
///获取职位
+ (NSString *)getUserPosition;
///获取公司
+ (NSString *)getUserXCompany;
///获取免打扰状态
+ (BOOL)getDisturbState;
/**
 本地保存对方聊天信息
 
 @param userId 环信账号
 @param userName 用户名
 @param avatarURLPath 头像
 */
+ (void)saveToUserInfo:(NSString *)userId name:(NSString *)userName avatarURLPath:(NSString *)avatarURLPath;


/**
 查找本地用户信息
 
 @param userId 环信账号
 @return 信息字典
 */
+ (NSDictionary *)findUserInfoByUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
