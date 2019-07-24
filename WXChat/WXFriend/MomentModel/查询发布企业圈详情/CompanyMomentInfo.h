//
//  CompanyMomentInfo.h
//  login
//
//  Created by gwj on 2019/7/24.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enterprise.h"
#import "Comments.h"
NS_ASSUME_NONNULL_BEGIN

@interface CompanyMomentInfo : NSObject
@property (nonatomic, strong)NSArray<Comments *> *comments;//文档单词拼错了
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Enterprise *user;
    
@end

NS_ASSUME_NONNULL_END
