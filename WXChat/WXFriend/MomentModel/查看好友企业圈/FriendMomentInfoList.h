//
//  FriendMomentInfoList.h
//  login
//
//  Created by gwj on 2019/7/24.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendMomentInfo.h"

NS_ASSUME_NONNULL_BEGIN
@interface FriendMomentInfoList : NSObject
@property (nonatomic, strong)NSMutableArray<FriendMomentInfo *> *data;
@end

NS_ASSUME_NONNULL_END
