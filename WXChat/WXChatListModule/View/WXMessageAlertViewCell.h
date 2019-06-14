//
//  WXMessageAlertViewCell.h
//  WXChat
//
//  Created by WDX on 2019/6/12.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WXMessageAlertModel;
@interface WXMessageAlertViewCell : UITableViewCell
- (void)setModel: (WXMessageAlertModel *)model;
@end

NS_ASSUME_NONNULL_END
