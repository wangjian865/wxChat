//
//  UserCompanies.h
//  login
//
//  Created by gwj on 2019/7/23.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserCompanies : NSObject
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
@property (nonatomic, copy)NSString *seanceshows;//接口上值类型为null
@end

NS_ASSUME_NONNULL_END
