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
///公司
@property (nonatomic, copy)NSString *tgusetcCompany;
///职位
@property (nonatomic, copy)NSString *tgusetPosition;
///账号
@property (nonatomic, copy)NSString *tgusetAccount;
///头像
@property (nonatomic, copy)NSString *tgusetImg;
///用户id
@property (nonatomic, copy)NSString *tgusetId;
///用户姓名
@property (nonatomic, copy)NSString *tgusetName;




@property (nonatomic, copy)NSString *tgusetpassword;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetcode;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetreghtdate;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetsex;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetadbox;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetsalt;//接口上值类型为null
@property (nonatomic, copy)NSString *tgusetnterprise;//接口上值类型为null
@property (nonatomic, copy)NSString *seanceshows;//接口上值类型为null
@end

NS_ASSUME_NONNULL_END
