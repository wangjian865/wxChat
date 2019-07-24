//
//  WXApiManager.h
//  WXChat
//
//  Created by WX on 2019/7/17.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXApiManager : NSObject
+ (NSString *)getRequestUrl: (NSString *)api;
@end

NS_ASSUME_NONNULL_END
