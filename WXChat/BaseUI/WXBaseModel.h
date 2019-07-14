//
//  WXBaseModel.h
//  WXChat
//
//  Created by WX on 2019/7/14.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXBaseModel : NSObject
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, strong)NSDictionary *data;
@property (nonatomic, copy)NSString *code;
@end

NS_ASSUME_NONNULL_END
