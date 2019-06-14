//
//  WXMessageAlertModel.h
//  WXChat
//
//  Created by WDX on 2019/6/14.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXMessageAlertModel : NSObject
//头像
@property (nonatomic, copy) NSString *avatarUrl;
//姓名
@property (nonatomic, copy) NSString *name;
//描述
@property (nonatomic, copy) NSString *descriptionText;
//状态
@property (nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
