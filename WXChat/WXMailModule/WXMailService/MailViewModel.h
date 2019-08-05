//
//  MailViewModel.h
//  WXChat
//
//  Created by gwj on 2019/7/27.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MailDetails.h"
#import "MailInfoList.h"
NS_ASSUME_NONNULL_BEGIN

@interface MailViewModel : NSObject
///邮箱登录
+(void)loginMailWithMailAccount:(NSString *)account
                       password: (NSString *)password
                    accountType:(NSString *)type
                   successBlock:(void(^) (NSString *data))success
                      failBlock:(void(^) (NSError *error))failure;
///获取邮箱首页信息
+(void)getMailHomeDataWithSuccessBlock:(void(^) (MailInfoList *model))success
                             failBlock:(void(^) (NSError *error))failure;
///邮件查询
+(void)getMailInfoWithMailAccount:(NSString *)account
                           pushId: (NSString *)pushId
                      accountType:(NSString *)type
                     categoryType:(NSString *)categoryType
                     successBlock:(void(^) (MailInfoList *model))success
                        failBlock:(void(^) (NSError *error))failure;

///删除邮件 ==>不确定参数对不对
+(void)deleteMailWithMailAccount:(NSString *)account
                        typeName: (NSString *)typeName
                    categoryType:(NSString *)categoryType
                     accountType:(NSString *)type
                       serviceId:(NSString *)serviceId
                    successBlock:(void(^) (NSString *successMessage))success failBlock:(void(^) (NSError *error))failure;

///发送邮件
+(void)sendMailWithMailAccount:(NSString *)account
                     mailTitle:(NSString *)title
                      receiver:(NSString *)receiver
                       content: (NSString *)content
                    attachment:(NSString *)attachment
                  successBlock:(void(^) (NSString *successMessage))success failBlock:(void(^) (NSError *error))failure;

///查看邮件详情
+(void)getMailDetailWithMailAccount:(NSString *)account
                        accountType:(NSString *)type
                       categoryType:(NSString *)categoryType
                          serviceId:(NSString *)serviceId
                       successBlock:(void(^) (MailDetails *model))success failBlock:(void(^) (NSError *error))failure;

///发送邮件（回复邮件）
+(void)sendMailWithMailAccount:(NSString *)account
                     mailTitle:(NSString *)title
                      receiver:(NSString *)receiver
                   accountType:(NSString *)accountType
                       content: (NSString *)content
                    attachment:(NSString *)attachment
                  successBlock:(void(^) (NSString *successMessage))success failBlock:(void(^) (NSError *error))failure;

///回复邮件
+(void)replyMailWithMailAccount:(NSString *)account
                      serviceId:(NSString *)serviceId
                          title:(NSString *)title
                       receiver:(NSString *)receiver
                        content: (NSString *)content
                   successBlock:(void(^) (NSString *successMessage))success failBlock:(void(^) (NSError *error))failure;

///转发邮件
+(void)forwardMailWithMailAccount:(NSString *)account
                        serviceId:(NSString *)serviceId
                            title:(NSString *)title
                         receiver:(NSString *)receiver
                          content: (NSString *)content
                     successBlock:(void(^) (NSString *successMessage))success failBlock:(void(^) (NSError *error))failure;
@end


NS_ASSUME_NONNULL_END
