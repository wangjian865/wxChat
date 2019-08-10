//
//  MailViewModel.m
//  WXChat
//
//  Created by gwj on 2019/7/27.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "MailViewModel.h"

@implementation MailViewModel
///邮箱登录
+(void)loginMailWithMailAccount:(NSString *)account
                       password: (NSString *)password
                    accountType:(NSString *)type
                   successBlock:(void(^) (NSString *data))success
                      failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"email/loginEmail"];
    NSDictionary *params = @{@"account": account,
                             @"password": password,
                             @"typeName": type};
    [MBProgressHUD showHUD];
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
//            CompanyMoment *model = [CompanyMoment yy_modelWithJSON:responseBody[@"data"]];
            success(@"成功");
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
///邮箱退出
+(void)logoutMailWithMailAccount:(NSString *)account
                    successBlock:(void(^) (NSString *data))success
                       failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"email/deleteMail"];
    NSDictionary *params = @{@"tguseteamilaccount": account};
    [MBProgressHUD showHUD];
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            success(@"成功");
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
///获取邮件首页信息
+(void)getMailHomeDataWithSuccessBlock:(void(^) (MailPageModel *model))success
                             failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"emailS/mailHomePage"];
    NSDictionary *params = @{};
    [MBProgressHUD showHUD];
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            MailPageModel *model = [MailPageModel yy_modelWithJSON:responseBody];
            success(model);
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
///邮件查询
+(void)getMailInfoWithMailAccount:(NSString *)account
                           pushId: (NSString *)pushId
                      accountType:(NSString *)type
                     categoryType:(NSString *)categoryType
                     successBlock:(void(^) (MailInfoList *model))success
                        failBlock:(void(^) (NSError *error))failure{
    [MBProgressHUD showHUD];
    NSString *urlStr =  [WXApiManager getRequestUrl:@"emailS/emailAll"];
    //categoryType 1收件箱，2 草稿箱，3发件箱 4垃圾箱
//    @"regid": pushId,
    NSDictionary *params = @{@"account": account,
                             @"typeName": type,
                             @"id": categoryType};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            MailInfoList *model = [MailInfoList yy_modelWithJSON:responseBody[@"data"]];
            success(model);
        }else{
//            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///删除邮件
+(void)deleteMailWithMailAccount:(NSString *)account
                        typeName: (NSString *)typeName
                    categoryType:(NSString *)categoryType
                       emailId:(NSString *)emailId
                    successBlock:(void(^) (NSString *successMessage))success failBlock:(void(^) (NSError *error))failure{
    [MBProgressHUD showHUD];
    NSString *urlStr =  [WXApiManager getRequestUrl:@"emailS/emailDelete"];
    NSDictionary *params = @{@"account": account,
                             @"typeName": typeName,//邮箱类型
                             @"id": categoryType,//1收件箱，2 草稿箱，3发件箱 4垃圾箱
                             @"emailId": @[emailId]
                             };
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){

            success(@"成功");
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///发送邮件(失效)
+(void)sendMailWithMailAccount:(NSString *)account
                     mailTitle:(NSString *)title
                    receiver:(NSString *)receiver
                       content: (NSString *)content
                    attachment:(NSString *)attachment
                  successBlock:(void(^) (NSString *successMessage))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"oneemail/MailSMTP"];
    //categoryType 1收件箱，2 草稿箱，3发件箱 4垃圾箱
    NSDictionary *params = @{@"tguseteamailtgusetId": [WXAccountTool getUserID],//用户id
                             @"tguseteamailaccount": account,//邮箱账号
                             @"SendEamilTheme": title,//标题
                             @"SendEamilReceive": receiver,//收件人
                             @"SendEamilContext": content,//内容
                             @"sendemailaccessoryfile":attachment,//附件，最多3个
                             @"companyid": [WXAccountTool getUserPhone]};//登录账号（非邮箱账号）
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            success(@"成功");
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///查看邮件详情
+(void)getMailDetailWithMailAccount:(NSString *)account
                        accountType:(NSString *)type
                       categoryType:(NSString *)categoryType
                          serviceId:(NSString *)serviceId
                       successBlock:(void(^) (MailDetails *model))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"emailS/emailTd"];
    NSDictionary *params = @{@"account": account,//邮箱账号
                             @"typeName": type,//邮箱类型
                             @"id": categoryType,//1收件箱，2 草稿箱，3发件箱 4垃圾箱
                             @"messageId":serviceId,//内容
                             };
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            MailDetails *model = [MailDetails yy_modelWithJSON:responseBody[@"data"]];
            success(model);
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///发送邮件
+(void)sendMailWithMailAccount:(NSString *)account
                     mailTitle:(NSString *)title
                       receiver:(NSString *)receiver
                   accountType:(NSString *)accountType
                       content: (NSString *)content
                    attachment:(NSString *)attachment
                  successBlock:(void(^) (NSString *successMessage))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"emailT/emailSend"];
//    @"files":attachment,//附件，最多3个
    NSDictionary *params = @{@"account": account,//邮箱账号
                             @"sendeamiltheme": title,//标题
                             @"sendeamilcontext": content,//内容
                             @"sendeamilreceive": receiver,//收件人
                             @"typeName": accountType,//内容
                             };
    [WXNetWorkTool uploadFileWithUrl:urlStr imageName:@[] image:@[] parameters:params progressBlock:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } successBlock:^(id  _Nonnull responseBody) {
        //成功
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            success(responseBody[@"data"]);
        }else{
            [MBProgressHUD showError:@"发送失败"];
        }
        
    } failureBlock:^(NSError * _Nonnull error) {
        //失败
    }];
}

///回复邮件
+(void)replyMailWithMailAccount:(NSString *)account
                     serviceId:(NSString *)serviceId
                       title:(NSString *)title
                   receiver:(NSString *)receiver
                accountType:(NSString *)accountType
                    content: (NSString *)content
                   successBlock:(void(^) (NSString *successMessage))success
                      failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"emailT/emailReply"];
    NSDictionary *params = @{@"sendeamilaccount": account,//邮箱账号
                             @"messageId": serviceId,
                             @"sendeamiltheme": title,//标题
                             @"sendeamilreceive": receiver,//收件人
                             @"sendeamilcontext": content,//内容
                             @"typeName":accountType
                             };//还差一个文件
    [WXNetWorkTool uploadFileWithUrl:urlStr imageName:@[] image:@[] parameters:params progressBlock:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } successBlock:^(id  _Nonnull responseBody) {
        //成功
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            success(responseBody[@"data"]);
        }else{
            [MBProgressHUD showError:@"发送失败"];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        //失败
    }];
}

///转发邮件
+(void)forwardMailWithMailAccount:(NSString *)account
                      serviceId:(NSString *)serviceId
                          title:(NSString *)title
                       receiver:(NSString *)receiver
                    accountType:(NSString *)accountType
                        content: (NSString *)content
                   successBlock:(void(^) (NSString *successMessage))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"emailT/emailForward"];
    NSDictionary *params = @{@"sendeamilaccount": account,//邮箱账号
                             @"messageId": serviceId,
                             @"sendeamiltheme": title,//标题
                             @"sendeamilreceive": receiver,//收件人
                             @"sendeamilcontext": content,//内容
                             @"typeName":accountType
                             };//少一个文件
    [WXNetWorkTool uploadFileWithUrl:urlStr imageName:@[] image:@[] parameters:params progressBlock:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } successBlock:^(id  _Nonnull responseBody) {
        //成功
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            success(responseBody[@"data"]);
        }else{
            [MBProgressHUD showError:@"发送失败"];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        //失败
    }];
}




@end
