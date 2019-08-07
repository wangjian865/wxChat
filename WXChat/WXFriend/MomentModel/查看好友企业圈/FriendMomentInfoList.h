//
//  FriendMomentInfoList.h
//  login
//
//  Created by gwj on 2019/7/24.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendMomentInfo.h"
#import "UserCompanies.h"
NS_ASSUME_NONNULL_BEGIN
@interface FriendMomentInfoList : NSObject
@property (nonatomic, strong)NSMutableArray<FriendMomentInfo *> *enterprise;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong)UserCompanies *user;
@end

NS_ASSUME_NONNULL_END
