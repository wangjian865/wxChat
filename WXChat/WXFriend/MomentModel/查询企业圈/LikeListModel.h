//
//  LikeListModel.h
//  WXChat
//
//  Created by WX on 2019/7/26.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///   什么意思?
@interface LikeListModel : NSObject
///点赞id
@property (nonatomic, copy) NSString *enterpriselikeid;
//点赞的发布朋友圈
@property (nonatomic, copy) NSString *enterpriselikeenterid;
///点赞人id
@property (nonatomic, copy) NSString *enterpriseliketid;
///点赞人名字
@property (nonatomic, copy) NSString *enterpricelikename;
///点赞时间
@property (nonatomic, copy) NSString *enterpriseliketime;

@end

NS_ASSUME_NONNULL_END
