//
//  MomentMessage.h
//  WXChat
//
//  Created by gwj on 2019/7/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentComent.h"

NS_ASSUME_NONNULL_BEGIN

@interface MomentMessageList : NSObject
@property (nonatomic, strong)NSArray<MomentComent *> *data;
@end

NS_ASSUME_NONNULL_END
