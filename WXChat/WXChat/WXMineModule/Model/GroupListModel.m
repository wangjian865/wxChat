//
//  GroupListModel.m
//  WXChat
//
//  Created by WX on 2019/8/1.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "GroupListModel.h"

@implementation GroupListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[GroupModel class]};
}
@end
