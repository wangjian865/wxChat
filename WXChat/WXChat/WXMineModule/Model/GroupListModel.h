//
//  GroupListModel.h
//  WXChat
//
//  Created by WX on 2019/8/1.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupListModel : NSObject
///群组列表
@property (nonatomic, copy) NSArray<GroupModel *> *data;

@end

NS_ASSUME_NONNULL_END
