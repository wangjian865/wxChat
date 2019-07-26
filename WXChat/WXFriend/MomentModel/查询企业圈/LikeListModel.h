//
//  LikeListModel.h
//  WXChat
//
//  Created by WX on 2019/7/26.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///   什么意思?
@interface LikeListModel : NSObject
@property (nonatomic, copy) NSString *enterpriselikeid;
@property (nonatomic, copy) NSString *enterpriselikeenterid;
@property (nonatomic, copy) NSString *enterpriseliketid;
@property (nonatomic, copy) NSString *enterpricelikename;
@property (nonatomic, copy) NSString *enterpriseliketime;

@end

NS_ASSUME_NONNULL_END
