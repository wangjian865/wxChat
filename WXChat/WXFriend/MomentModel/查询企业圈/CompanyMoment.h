//
//  CompanyMoment.h
//  login
//
//  Created by gwj on 2019/7/23.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enterprise.h"
#import "UserCompanies.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyMoment : NSObject
   @property (nonatomic, strong)NSArray<Enterprise *> *enterprise;
   @property (nonatomic, strong)UserCompanies *userQ;//用户企业圈


@end

NS_ASSUME_NONNULL_END
