//
//  FriendMomentInfoList.m
//  login
//
//  Created by gwj on 2019/7/24.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import "FriendMomentInfoList.h"

@implementation FriendMomentInfoList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"enterprise":[FriendMomentInfo class],@"user":[UserCompanies class]};
}
@end
