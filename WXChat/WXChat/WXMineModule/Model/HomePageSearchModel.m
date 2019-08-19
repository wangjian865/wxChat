//
//  HomePageSearchModel.m
//  WXChat
//
//  Created by WX on 2019/8/19.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "HomePageSearchModel.h"

@implementation HomePageSearchModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"seanceshows":[GroupModel class],@"friends":[UserInfoModel class]};
}
@end
