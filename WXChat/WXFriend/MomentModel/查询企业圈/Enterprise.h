//
//  Enterprise.h
//  login
//
//  Created by gwj on 2019/7/23.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Enterprise : NSObject
@property (nonatomic, copy)NSString *tgusetid;//用户id
@property (nonatomic, copy)NSString *tgusetname;
@property (nonatomic, copy)NSString *tgusetaccount;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetpassword;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetimg;
@property (nonatomic, copy)NSString *tgusetcode;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetcompany;
@property (nonatomic, copy)NSString *tgusetposition;
@property (nonatomic, copy)NSString *tgusetreghtdate;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetsex;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetadbox;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetsalt;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetnterprise;//接口上值类型为null
@property (nonatomic, copy)NSString *seanceshows;//接口上值类型为null
@property (nonatomic, copy)NSString *enterprisezid;//发布的企业圈id
@property (nonatomic, copy)NSString *enterprisezenterpriseid;//企业圈id
@property (nonatomic, strong)NSDate *enterpriseztime;//发布时间 接口是int应该要转
@property (nonatomic, assign) int enterprisezcount;//接口上值类型为null
@property (nonatomic, copy)NSString *enterprisezenterpriseshowid;//null
@property (nonatomic, copy)NSString *enterprisezcontent;//发布内容
@property (nonatomic, copy)NSString *enterprisezfujina;//视频或者图片url
@property (nonatomic, copy)NSString *enterpriseztgusetid;//用户id
@property (nonatomic, copy)NSString *friendid;//null
@property (nonatomic, copy)NSString *friendtgusetid;//null
@property (nonatomic, copy)NSString *friendfriendid;//null
@property (nonatomic, copy)NSString *friendaddtime;//null
@property (nonatomic, copy)NSString *friendrecord;//备注（好友或者自己的备注）
@property (nonatomic, assign) int count;//点赞数量
@property (nonatomic, assign) int commentscount;//评论数量
@end

NS_ASSUME_NONNULL_END
