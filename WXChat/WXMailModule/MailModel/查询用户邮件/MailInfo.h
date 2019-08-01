//
//  MailInfo.h
//  WXChat
//
//  Created by gwj on 2019/7/27.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MailInfo : NSObject
@property (nonatomic, copy) NSString *reademailid;//第几封邮件
@property (nonatomic, copy) NSString *reademailtheme;//邮件主题
@property (nonatomic, copy) NSString *reademailcontent;//内容
@property (nonatomic, copy) NSString *reademailsendtugset;//发件人邮箱
@property (nonatomic, copy) NSString *reademailshowtugset;//收件人邮箱
@property (nonatomic, copy) NSString *reademailtime;//最早发送时间
@property (nonatomic, assign) BOOL reademailstate;//是否已读
@property (nonatomic, assign) BOOL reademailattachment;//是否有附件
@property (nonatomic, copy) NSString *reademailmessageid;//邮件服务id
@end

NS_ASSUME_NONNULL_END
