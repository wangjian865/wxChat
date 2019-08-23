//
//  CompanyMomentInfo.h
//  login
//
//  Created by gwj on 2019/7/24.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentUser.h"
#import "MomentEnterprise.h"
NS_ASSUME_NONNULL_BEGIN

@interface CompanyMomentInfo : NSObject
@property (nonatomic, strong)NSArray<MomentEnterprise *> *enterprise;//文档单词拼错了
@property (nonatomic, strong) MomentUser *user;
    
@end

NS_ASSUME_NONNULL_END
