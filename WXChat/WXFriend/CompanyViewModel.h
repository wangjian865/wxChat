//
//  MomentViewModel.h
//  WXChat
//
//  Created by gwj on 2019/7/24.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyMoment.h"
#import "CompanyMomentInfo.h"
#import "FriendMomentInfoList.h"
#import "FriendMomentDetail.h"
#import "MomentMessageList.h"
#import "UserMomentInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CompanyViewModel : NSObject
///获取简问上的企业圈
+(void)getMomentsWithPage:(int)page successBlock:(void(^) (CompanyMoment *model))success failBlock:(void(^) (NSError *error))failure;

///更换企业圈背景图
+(void)changeBackgroundImage: (UIImage *)image imageName: (NSString *)imageName successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure;

///查询发布企业圈详情
+(void)getMomentsDetailWithPriseid:(NSString *)enterpriseId successBlock:(void(^) (Enterprise *model))success failBlock:(void(^) (NSError *error))failure;

///查看某人企业圈详情
+ (void)getPersonMomentDataWithUserIdL:(NSString *)userId successBlock:(void(^) (UserMomentInfoModel *model))success failBlock:(void(^) (NSError *error))failure;
//列表
///查看好友企业圈(或者自己的企业圈==非简问里的企业圈)
+(void)getMomentsListWithUserid:(NSString *)userId page:(NSString *)page successBlock:(void(^) (FriendMomentInfoList *model))success failBlock:(void(^) (NSError *error))failure;

///查看好友企业圈详情
+(void)getFriendMomentInfoWithPriseid:(NSString *)enterpriseId successBlock:(void(^) (FriendMomentDetail *model))success failBlock:(void(^) (NSError *error))failure;

///点赞
+(void)likeMomentWithPriseid:(NSString *)enterpriseId successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure;

///取消点赞
+(void)deleteLikeMomentWithPriseid:(NSString *)enterpriseId successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure;

///发布评论 参数： 评论内容 + 圈子id
+(void)commentWithContent:(NSString *)content priseid:(NSString *)priseid successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure;
///发布对评论的评论
+ (void)commentToPersonWithContent:(NSString *)content commentOwnerId: (NSString *)ownerId priseid: (NSString *)priseid beCommentId:(NSString *)beCommentId beCommentName: (NSString *)name successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure;
///删除评论 参数： 评论id 删除别人的评论？
+(void)deleteCommentWithContentId:(NSString *)contentid successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure;

///删除发布的企业圈 参数： 圈子id
+(void)deleteMomentWithPriseid:(NSString *)priseid successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure;

///企业圈-查询消息列表  /替换userid
+(void)getMomentMessageListSuccessBlock:(void(^) (MomentMessageList *model))success failBlock:(void(^) (NSError *error))failure;

///企业圈-删除消息列表
+(void)deleteMomentsMessageListWithCommentId:(NSArray *)commentId successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure;

///发布企业圈  /替换account 用户id
+(void)publicMomentsMessage:(NSString *)message files:(NSArray *)files fileNames: (NSArray *)fileNames successBlock:(void(^) (NSString *successMsg))success failBlock:(void(^) (NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
