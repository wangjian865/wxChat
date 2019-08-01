//
//  WXMessageAlertListModel.h
//  WXChat
//
//  Created by WX on 2019/7/28.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXMessageAlertModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WXMessageAlertListModel : NSObject
@property (nonatomic, strong) NSArray<WXMessageAlertModel *> *data;
@end

NS_ASSUME_NONNULL_END
