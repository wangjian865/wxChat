//
//  WXAccountTool.m
//  WXChat
//
//  Created by WDX on 2019/6/6.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXAccountTool.h"

@implementation WXAccountTool
+ (void)logout{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"token"];
    [userDefault removeObjectForKey:@"account"];
    [userDefault removeObjectForKey:@"userID"];
    [userDefault removeObjectForKey:@"huanxinID"];
    [userDefault removeObjectForKey:@"userName"];
    [userDefault removeObjectForKey:@"userImage"];
}
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
    NSString *name = [userDefault stringForKey:@"userName"];
    if (name == nil){
        name = @"奥特曼";
    }
    return name;
}
///获取职位
+ (NSString *)getUserPosition{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *position = [userDefault stringForKey:@"userPosition"];
    return position;
}
///获取公司
+ (NSString *)getUserXCompany{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *company = [userDefault stringForKey:@"userCompany"];
    return company;
}
+ (NSString *)getUserImage{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *img = [userDefault stringForKey:@"userImage"];
    if (img == nil){
        img = @"奥特曼";
    }
    return img;
}
+ (void)saveToUserInfo:(NSString *)userId name:(NSString *)userName avatarURLPath:(NSString *)avatarURLPath {
    
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"messageList.plist"];
    
    NSMutableArray *array =[[NSMutableArray alloc] initWithContentsOfFile:filePatch];
    
    if (!array) {
        array = [NSMutableArray array];
    }
    
    NSDictionary *toDict = @{@"from_id_user":userId,
                             @"from_name_user":userName,
                             @"from_heading_user":avatarURLPath
                             };
    
    if (![array containsObject:toDict]) {
        [array addObject:toDict];
        [array writeToFile:filePatch atomically:true];
    }
    
}

+ (NSDictionary *)findUserInfoByUserId:(NSString *)userId {
    
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"messageList.plist"];
    
    NSMutableArray *array =[[NSMutableArray alloc] initWithContentsOfFile:filePatch];
    
    NSDictionary *tempDict;
    for (NSDictionary *dict in array) {
        if ([dict[@"from_id_user"] isEqualToString:userId]) {
            tempDict = dict;
            break;
        }
    }
    return tempDict;
}

@end
