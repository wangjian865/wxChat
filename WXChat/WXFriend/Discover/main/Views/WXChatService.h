//
//  WXChatService.h
//  WXChat
//
//  Created by WX on 2019/7/15.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXMessageAlertListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WXChatService : NSObject
///人脉-查询所有添加好友申请
+(void)getAllAddFriendRequestSuccessBlock:(void(^) (WXMessageAlertListModel *model))success failBlock:(void(^) (NSError *error))failure;
///人脉-获取好友列表
+(void)getFriendListRequestSuccessBlock:(void(^) (WXMessageAlertListModel *model))success failBlock:(void(^) (NSError *error))failure;

///获取群组会话列表
+ (NSArray *)getGroupChatConversations;
///获取某一条会话
+ (EMConversation *)getAConversationWithId: (NSString *)ID;
///删除某条会话
+ (void)deleteAConversationWithId: (NSString *)ID completion:(void (^)(NSString *aConversationId, EMError *aError))aCompletionBlock;
///获取最近的聊天文本
+ (NSString *)getGroupChatText:(EMConversation *)conversationModel;
///获取最近聊天的时间
+ (NSString *)getLastTime:(EMConversation *)conversationModel;
@end

NS_ASSUME_NONNULL_END
