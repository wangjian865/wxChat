//
//  CommentInfo.h
//  login
//
//  Created by gwj on 2019/7/24.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentInfo : NSObject
@property (nonatomic, copy)NSString *tgusetid;
@property (nonatomic, copy)NSString *tgusetname;
@property (nonatomic, copy)NSString *tgusetaccount;
@property (nonatomic, copy)NSString *tgusetpassword;
@property (nonatomic, copy)NSString *tgusetimg;
@property (nonatomic, copy)NSString *tgusetcode;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetcompany;//公司
@property (nonatomic, copy)NSString *tgusetposition;//职位
@property (nonatomic, copy)NSString *tgusetreghtdate;//
@property (nonatomic, copy)NSString *tgusetsex;
@property (nonatomic, copy)NSString *tgusetadbox;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetsalt;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetnterprise;//接口上值类型为null
@property (nonatomic, copy)NSString *seanceshows;//接口上值类型为
@property (nonatomic, assign) int commentsid;
@property (nonatomic, copy)NSString *commentszid;
@property (nonatomic, copy)NSString *commentstguset;
@property (nonatomic, copy)NSString *commentscontext;
@property (nonatomic, copy)NSString *commentsdatetime;
@property (nonatomic, assign)BOOL commentsreply;
@property (nonatomic, copy)NSString *commentstgusetname;//null
@property (nonatomic, copy)NSString *commentstgusethfid;//null
@property (nonatomic, copy)NSString *commentstgusethname;//null
@property (nonatomic, copy)NSString *enterprisezid;//发布的企业圈id
@property (nonatomic, copy)NSString *enterprisezenterpriseid;//企业圈id
@property (nonatomic, strong)NSDate *enterpriseztime;//发布时间 接口是int应该要转
@property (nonatomic, assign) int enterprisezcount;
@property (nonatomic, copy)NSString *enterprisezenterpriseshowid;
@property (nonatomic, copy)NSString *enterprisezcontent;//发布内容
@property (nonatomic, copy)NSString *enterprisezfujina;//视频或者图片
@property (nonatomic, copy)NSString *enterpriseztgusetid;
@property (nonatomic, assign) int commentstgusetifcheck;
@end

NS_ASSUME_NONNULL_END
