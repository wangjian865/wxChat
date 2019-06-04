//
//  WXUsersListService.h
//  WXChat
//
//  Created by WDX on 2019/6/4.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXUsersListService : NSObject
/**
 * 获取联系人列表
 * 优化体验需提前获取,需做本地缓存
 */
+ (NSArray *)getUsersList;
@end

NS_ASSUME_NONNULL_END
