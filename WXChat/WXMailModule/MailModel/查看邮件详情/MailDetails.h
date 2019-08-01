//
//  MailDetails.h
//  WXChat
//
//  Created by gwj on 2019/7/28.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MailInfo.h"
#import "InBoxInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MailDetails : NSObject
@property (nonatomic, strong) MailInfo *context;
@property (nonatomic, strong) InBoxInfo *inbox;

@end

NS_ASSUME_NONNULL_END
