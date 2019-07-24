
//
//  CompanyUsersModel.m
//  WXChat
//
//  Created by WX on 2019/7/22.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "CompanyUsersModel.h"

@implementation CompanyUsersModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"users":[FriendModel class]};
}
@end
