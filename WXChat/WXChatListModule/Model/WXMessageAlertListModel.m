//
//  WXMessageAlertListModel.m
//  WXChat
//
//  Created by WX on 2019/7/28.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMessageAlertListModel.h"

@implementation WXMessageAlertListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[WXMessageAlertModel class]};
}
@end
