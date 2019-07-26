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
///动态列表
@property (nonatomic, strong)NSArray<Enterprise *> *enterprise;
///封面图片
@property (nonatomic, copy)NSString *image;
///企业圈主人
@property (nonatomic, strong)UserCompanies *userQ;


@end

NS_ASSUME_NONNULL_END
