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
@property (nonatomic, copy) NSString *readeamilid;//第几封邮件
@property (nonatomic, copy) NSString *readeamiltheme;//邮件主题
@property (nonatomic, copy) NSString *readeamilcontet;//内容
@property (nonatomic, copy) NSString *readeamilsendtugset;//发件人邮箱
@property (nonatomic, copy) NSString *readeamilshowtugset;//收件人邮箱
@property (nonatomic, copy) NSString *readeamiltime;//最早发送时间
@property (nonatomic, assign) BOOL readeamilstate;//是否已读
@property (nonatomic, assign) BOOL readeamilattachment;//是否有附件
@property (nonatomic, copy) NSString *readmailmessageid;//邮件服务id
@property (nonatomic, copy) NSString *fileUrl;//附件url
@property (nonatomic, copy) NSString *fileName;//附件名
@end

NS_ASSUME_NONNULL_END
