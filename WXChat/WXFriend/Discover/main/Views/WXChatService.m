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

///获取群组会话列表
+ (NSArray *)getGroupChatConversations{
    NSMutableArray *result = [NSMutableArray array];
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    for (EMConversation *converstion in conversations) {
        EaseConversationModel *model = nil;
        model = [[EaseConversationModel alloc] initWithConversation:converstion];
        if (model){
            
        }
    }
    return [NSArray array];
}

///获取某一条群聊会话
+ (EMConversation *)getAConversationWithId: (NSString *)ID{
    return [[EMClient sharedClient].chatManager getConversation:ID type:EMConversationTypeGroupChat createIfNotExist:NO];
}
///删除一条会话
+ (void)deleteAConversationWithId: (NSString *)ID completion:(void (^)(NSString *aConversationId, EMError *aError))aCompletionBlock{
    [[EMClient sharedClient].chatManager deleteConversation:ID isDeleteMessages:NO completion:aCompletionBlock];
    
}
+ (NSString *)getGroupChatText:(EMConversation *)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = @"[音频]";
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = @"[位置]";
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = @"[视频]";
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = @"[文件]";
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}
+ (NSString *)getLastTime:(EMConversation *)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}
@end
