//
//  CommentInfoList.h
//  login
//
//  Created by gwj on 2019/7/24.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommentInfoList : NSObject
@property (nonatomic, strong)NSArray<CommentInfo *> *data;
@end

NS_ASSUME_NONNULL_END
