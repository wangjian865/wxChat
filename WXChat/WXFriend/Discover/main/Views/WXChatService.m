//
//  WXChatService.m
//  WXChat
//
//  Created by WX on 2019/7/15.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXChatService.h"

@implementation WXChatService

+ (void)getAllAddFriendRequestSuccessBlock:(void (^)(WXMessageAlertListModel * _Nonnull))success failBlock:(void (^)(NSError * _Nonnull))failure{
    NSString *urlStr =  [WXApiManager getRequestUrl:@"userFriend/selectUserFriendConSend"];
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:@{} successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            WXMessageAlertListModel *model = [WXMessageAlertListModel yy_modelWithJSON:responseBody];
            success(model);
        }else{
            [MBProgressHUD showError: responseBody[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//+ (void)getFriendListRequestSuccessBlock:(void (^)(WXMessageAlertListModel * _Nonnull))success failBlock:(void (^)(NSError * _Nonnull))failure{

//    NSString *urlStr = [WXApiManager getRequestUrl:@"manKeepToken/userFriends"];
//    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:@{} successBlock:^(id  _Nonnull responseBody) {
//        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
//        if ([code isEqualToString:@"200"]){
//            WXMessageAlertListModel *model = [WXMessageAlertListModel yy_modelWithJSON:responseBody];
//            success(model);
//        }else{
//            [MBProgressHUD showError: responseBody[@"msg"]];
//        }
//    } failureBlock:^(NSError * _Nonnull error) {
//        failure(error);
//    }];
    
//}

@end
