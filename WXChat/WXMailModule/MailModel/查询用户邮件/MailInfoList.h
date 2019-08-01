//
//  MailAccount.h
//  WXChat
//
//  Created by gwj on 2019/7/27.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MailInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MailInfoList : NSObject
@property (nonatomic, strong)NSArray<MailInfo *> *context;
@property (nonatomic, assign) int zoCount;//用户所有邮件账户的未读邮件总数量
@property (nonatomic, assign) int inbox;//未读邮件数量
@property (nonatomic, copy) NSString *user;//用户账户
@end

NS_ASSUME_NONNULL_END
