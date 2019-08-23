//
//  MomentComent.h
//  WXChat
//
//  Created by gwj on 2019/7/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MomentComent : NSObject
///评论id
@property (nonatomic, assign)int commentsId;
///是否已经查看评论
@property (nonatomic, assign)int commentsTgusetIfcheck;
///评论时间
@property (nonatomic, copy)NSString *commentsDatetime;
///是否是回复评论人 (0不是,1是)
@property (nonatomic, assign)int commentsReply;
///评论人名字
@property (nonatomic, copy)NSString *commentsTgusetName;
///少一个评论人id
//@property (nonatomic, copy)NSString *commentsTgusetId;
///回复人id
@property (nonatomic, copy)NSString *commentsTgusetHFId;
///回复人姓名
@property (nonatomic, copy)NSString *commentsTgusetHFName;
///   什么意思?
@property (nonatomic, copy)NSString *commentszId;
///评论人id
@property (nonatomic, copy)NSString *commentsTguset;
///评论内容
@property (nonatomic, copy)NSString *commentsContext;
///账号
@property (nonatomic, copy)NSString *tgusetAccount;
///评论人头像
@property (nonatomic, copy)NSString *tgusetImg;



@end

NS_ASSUME_NONNULL_END
