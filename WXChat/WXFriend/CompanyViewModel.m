//
//  MomentViewModel.m
//  WXChat
//
//  Created by gwj on 2019/7/24.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "CompanyViewModel.h"

//需要声明类变量 userid和username

@implementation CompanyViewModel

//获取简问上的企业圈===》ok
+(void)getMomentsWithPage:(int)page successBlock:(void(^) (CompanyMoment *model))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"enterprisez/tupshipshow"];
    NSDictionary *params = @{@"page": [[NSNumber alloc] initWithInt:page]};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            CompanyMoment *model = [CompanyMoment yy_modelWithJSON:responseBody[@"data"]];
            success(model);
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//更换企业圈背景图
+(void)changeBackgroundImage: (UIImage *)image imageName: (NSString *)imageName successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"mEnter/background"];
    NSDictionary *params = @{@"enterpriseidtguset":WXAccountTool.getUserID};
    [WXNetWorkTool uploadFileWithUrl:urlStr imageName:@[imageName] image:@[image] parameters:params progressBlock:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } successBlock:^(id  _Nonnull responseBody) {
        //成功
        success(responseBody[@"data"]);
    } failureBlock:^(NSError * _Nonnull error) {
        //失败
    }];
    
}

//查询发布企业圈详情 ==》ok
+(void)getMomentsDetailWithPriseid:(NSString *)enterpriseId successBlock:(void(^) (Enterprise *model))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"enterprisez/MEnterpricezSelectDan"];//后面一个单词可能有错
    NSDictionary *params = @{@"enterprisezid":enterpriseId,};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            Enterprise *model = [Enterprise yy_modelWithJSON:responseBody[@"data"][@"enterprise"]];
            success(model);
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
///查看某人企业圈详情
+ (void)getPersonMomentDataWithUserIdL:(NSString *)userId successBlock:(void(^) (UserMomentInfoModel *model))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"manKeepToken/selectUserFriendE"];
    NSDictionary *params = @{@"tgusetid":userId};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            UserMomentInfoModel *model = [UserMomentInfoModel yy_modelWithJSON:responseBody[@"data"]];
            success(model);
        }else{
//            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
//查看好友企业圈(或者自己的企业圈==非简问里的企业圈)==》ok
+(void)getMomentsListWithUserid:(NSString *)userId page:(NSString *)page successBlock:(void(^) (FriendMomentInfoList *model))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"enterprisez/menterpriceSelectFriend"];
    NSDictionary *params = @{@"userId":userId,@"page": page};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            FriendMomentInfoList *model = [FriendMomentInfoList yy_modelWithJSON:responseBody[@"data"]];
            success(model);
        }else{
//            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//查看好友企业圈详情==>ok
+(void)getFriendMomentInfoWithPriseid:(NSString *)enterpriseId successBlock:(void(^) (FriendMomentDetail *model))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"enterprisez/menterDanFriend"];//后面一个单词可能有错
    NSDictionary *params = @{@"enterprisezid":enterpriseId};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            FriendMomentDetail *model = [FriendMomentDetail yy_modelWithJSON:responseBody[@"data"]];
            success(model);
        }else{
//            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//点赞 ==》ok。替换userid和username
+(void)likeMomentWithPriseid:(NSString *)enterpriseId successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"enterlike/enterpriselikeadd"];
    
    NSDictionary *params = @{@"enterpriselikeenterid":enterpriseId,@"enterpriseliketid": WXAccountTool.getUserID,@"enterpricelikename": [WXAccountTool getUserName]};
    
//    NSDictionary *params = @{@"enterprisezid":enterpriseId,@"enterpriseliketid": WXAccountTool.getUserID,@"enterpricelikename": [WXAccountTool getUserName]};//后两位参数就是userid和username
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            success(responseBody[@"msg"]);
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//取消点赞===ok 替换userid和username
+(void)deleteLikeMomentWithPriseid:(NSString *)enterpriseId successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"enterlike/enterpriseliked"];//后面一个单词可能有错
    NSDictionary *params = @{@"enterpriselikeenterid":enterpriseId,@"enterpriseliketid": WXAccountTool.getUserID};//最后参数就是userid
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            success(@"删除成功");
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//发布评论 参数： 评论内容 + 圈子id ==》ok / 替换userid和username
+(void)commentWithContent:(NSString *)content priseid:(NSString *)priseid successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"comments/commentadd"];
    NSDictionary *params = @{@"commentszid": priseid,@"commentstguset": WXAccountTool.getUserID,@"commentscontext": content,@"commentstgusetname": [WXAccountTool getUserName]};//2和4是userid和name
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            success(@"success");
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/// 发表对评论的评论
+ (void)commentToPersonWithContent:(NSString *)content commentOwnerId: (NSString *)ownerId priseid: (NSString *)priseid beCommentId:(NSString *)beCommentId beCommentName: (NSString *)name successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"comments/addHFComment"];
    NSDictionary *params = @{@"commentszid": priseid,@"commentstgusethfid": beCommentId,@"commentstgusethfname": name,@"commentscontext": content,@"commentsTguset": ownerId};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            success(@"success");
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
//删除评论 参数： 评论id ==》ok       //删除别人的评论？
+(void)deleteCommentWithContentId:(NSString *)contentid successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"comments/commentdel"];
    NSDictionary *params = @{@"commentsid": contentid};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            success(@"success");
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//删除发布的企业圈 参数： 圈子id===》ok
+(void)deleteMomentWithPriseid:(NSString *)priseid successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"enterprisez/denterpriseDel"];
    NSDictionary *params = @{@"enterprisezid": priseid};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            success(@"success");
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//企业圈-查询消息列表  /替换userid  ==>ok
+(void)getMomentMessageListWithPage:(int )page SuccessBlock:(void(^) (MomentMessageList *model))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"comments/commentsListLook"];
    NSDictionary *params = @{@"commentstguset":WXAccountTool.getUserID,@"page":[NSNumber numberWithInt:page]};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            MomentMessageList *model = [MomentMessageList yy_modelWithJSON:responseBody];
            success(model);
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//====================
//企业圈-删除消息列表 ==》 400 ok？？
+(void)deleteMomentsMessageListWithCommentId:(NSString *)commentId successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"comments/commentDM"];
    NSDictionary *params = @{@"commentsid": commentId};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            success(@"删除成功");
        }else{
//            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//====================
//发布企业圈  /替换account 用户id
+(void)publicMomentsMessage:(NSString *)message files:(NSArray *)files fileNames: (NSArray *)fileNames successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"enterprisez/tupship"];
    NSDictionary *params = @{@"enterprisezcontent": message,@"EnterprisezEnterpriseId": @""};
    
    [WXNetWorkTool uploadFileWithUrl:urlStr imageName:fileNames image:files parameters:params progressBlock:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } successBlock:^(id  _Nonnull responseBody) {
        success(@"成功");
        //成功
    } failureBlock:^(NSError * _Nonnull error) {
        //失败
    }];

//    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
//        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
//        if ([code isEqualToString:@"200"]){
//            //成功
//            success(@"发布成功");
//        }else{
//            [MBProgressHUD showError: responseBody[@"msg"]];
//        }
//    } failureBlock:^(NSError * _Nonnull error) {
//        failure(error);
//    }];
}
@end
