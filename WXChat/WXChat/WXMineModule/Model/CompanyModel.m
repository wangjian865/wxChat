//
//  CompanyModel.m
//  WXChat
//
//  Created by WX on 2019/7/21.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "CompanyModel.h"
#import "FriendModel.h"
@implementation CompanyModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"users":[FriendModel class]};
}
@end
