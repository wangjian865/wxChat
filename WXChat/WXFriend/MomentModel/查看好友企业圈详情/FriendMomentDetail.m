//
//  FriendMomentDetail.m
//  WXChat
//
//  Created by gwj on 2019/7/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "FriendMomentDetail.h"

@implementation FriendMomentDetail
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cmments":[MomentComent class],@"user":[MomentUser class]};
}
@end
