//
//  FriendMomentDetail.h
//  WXChat
//
//  Created by gwj on 2019/7/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentComent.h"
#import "MomentUser.h"


NS_ASSUME_NONNULL_BEGIN

@interface FriendMomentDetail : NSObject
@property (nonatomic, strong)NSArray<MomentComent *> *cmments;//文档单词拼错了
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) MomentUser *user;

@end

NS_ASSUME_NONNULL_END
