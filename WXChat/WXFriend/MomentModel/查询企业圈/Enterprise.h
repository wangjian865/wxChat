//
//  Enterprise.h
//  login
//
//  Created by gwj on 2019/7/23.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentComent.h"
#import "LikeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface Enterprise : NSObject
///点赞数量
@property (nonatomic, assign) int count;
///评论数量
@property (nonatomic, assign) int commentsCount;
///评论数组
@property (nonatomic, strong) NSArray<MomentComent *> *commes;
///点赞数组
@property (nonatomic, strong) NSArray<LikeListModel *> *namelike;
///用户id
@property (nonatomic, copy)NSString *enterprisezId;
///   什么意思?
@property (nonatomic, copy)NSString *enterprisezEnterpriseId;
///职位
@property (nonatomic, copy)NSString *tgusetPosition;
///公司
@property (nonatomic, copy)NSString *tgusetCompany;
///用户备注
@property (nonatomic, copy)NSString *friendRecord;
///发动态的时间
@property (nonatomic, copy)NSString *enterprisezTime;
///动态文字内容
@property (nonatomic, copy)NSString *enterprisezContent;
///   什么意思?
@property (nonatomic, copy)NSString *enterprisezTgusetId;
///该动态发的图片
@property (nonatomic, copy)NSString *enterprisezfujina;
///该动态用户账号
@property (nonatomic, copy)NSString *tgusetAccount;
///该动态用户头像
@property (nonatomic, copy)NSString *tgusetImg;
///该动态用户id
@property (nonatomic, copy)NSString *tgusetId;
///该动态用户姓名
@property (nonatomic, copy)NSString *tgusetName;

///缓存行高
@property (nonatomic, assign) CGFloat rowHeight;
@end

NS_ASSUME_NONNULL_END
