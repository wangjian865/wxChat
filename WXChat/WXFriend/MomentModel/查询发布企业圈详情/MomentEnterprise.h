//
//  Comments.h
//  login
//
//  Created by gwj on 2019/7/23.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentComent.h"

NS_ASSUME_NONNULL_BEGIN

@interface MomentEnterprise : NSObject
@property (nonatomic, copy)NSString *tgusetid;
@property (nonatomic, copy)NSString *tgusetname;
@property (nonatomic, copy)NSString *tgusetaccount;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetpassword;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetimg;
@property (nonatomic, copy)NSString *tgusetcode;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetcompany;//公司
@property (nonatomic, copy)NSString *tgusetposition;//职位
@property (nonatomic, copy)NSString *tgusetreghtdate;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetsex;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetadbox;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetsalt;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetnterprise;//接口上值类型为null
@property (nonatomic, copy)NSString *seanceshows;//接口上值为null
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *codedate;
@property (nonatomic, copy) NSString *enterprisezid;
@property (nonatomic, copy) NSString *enterprisezenterpriseid;
@property (nonatomic, copy) NSString *enterpriseztime;
@property (nonatomic, copy) NSString *enterprisezcount;
@property (nonatomic, copy) NSString *enterprisezenterpriseshowid;
@property (nonatomic, copy) NSString *enterprisezcontent;
@property (nonatomic, copy) NSString *enterprisezfujina;
@property (nonatomic, copy) NSString *enterpriseztgusetid;
@property (nonatomic, copy) NSString *friendid;
@property (nonatomic, copy) NSString *friendtgusetid;
@property (nonatomic, copy) NSString *friendfriendid;
@property (nonatomic, copy) NSString *friendaddtime;
@property (nonatomic, copy) NSString *friendrecord;
@property (nonatomic, strong) NSArray<MomentComent *> *commentVos;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int commentscount;
    
@end

NS_ASSUME_NONNULL_END
