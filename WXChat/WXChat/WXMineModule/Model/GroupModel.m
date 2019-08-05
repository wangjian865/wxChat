//
//  GroupModel.m
//  WXChat
//
//  Created by WX on 2019/8/1.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tgusets":[FriendModel class]};
}
@end
