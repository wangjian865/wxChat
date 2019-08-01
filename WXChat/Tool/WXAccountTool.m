//
//  WXAccountTool.m
//  WXChat
//
//  Created by WDX on 2019/6/6.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXAccountTool.h"

@implementation WXAccountTool
+ (BOOL)isLogin{
    if ([WXAccountTool getToken] != nil){
        return true;
    }
    return false;
}
+ (NSString *)getToken{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault stringForKey:@"token"];
}
+ (NSString *)getUserPhone{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault stringForKey:@"account"];
}
+ (NSString *)getUserID{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault stringForKey:@"userID"];
}
+ (NSString *)getHuanXinID{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault stringForKey:@"huanxinID"];
}
+ (NSString *)getUserName{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault stringForKey:@"userName"];
}
@end
