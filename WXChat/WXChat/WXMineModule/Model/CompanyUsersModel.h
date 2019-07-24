//
//  CompanyUsersModel.h
//  WXChat
//
//  Created by WX on 2019/7/22.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CompanyUsersModel : NSObject
@property (nonatomic, strong)NSArray<FriendModel *> *users;
@end

NS_ASSUME_NONNULL_END
