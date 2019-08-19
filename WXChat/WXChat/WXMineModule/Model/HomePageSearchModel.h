//
//  HomePageSearchModel.h
//  WXChat
//
//  Created by WX on 2019/8/19.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupModel.h"
#import "UserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomePageSearchModel : NSObject
@property (nonatomic, strong) NSArray <GroupModel *> *seanceshows;
@property (nonatomic, strong) NSArray <UserInfoModel *> *friends;
@end

NS_ASSUME_NONNULL_END
