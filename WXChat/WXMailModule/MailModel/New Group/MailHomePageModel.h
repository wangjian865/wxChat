//
//  MailHomePageModel.h
//  WXChat
//
//  Created by WX on 2019/8/7.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MailHomePageAModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MailHomePageModel : NSObject
@property (nonatomic, strong)NSArray<MailHomePageAModel *> *email;
@property (nonatomic, assign)int unreadNumber;
@end

NS_ASSUME_NONNULL_END
