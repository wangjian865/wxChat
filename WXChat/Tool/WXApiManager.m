//
//  WXApiManager.m
//  WXChat
//
//  Created by WX on 2019/7/17.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXApiManager.h"

@implementation WXApiManager
+ (NSString *)getRequestUrl: (NSString *)api{
    NSString *str = [NSString stringWithFormat:@"%@%@",MainURL,api];
    return str;
}
@end
