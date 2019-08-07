//
//  MailHomePageAccountModel.h
//  WXChat
//
//  Created by WX on 2019/8/7.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MailHomePageAccountModel : NSObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, strong) NSDictionary *state;
@end

NS_ASSUME_NONNULL_END
