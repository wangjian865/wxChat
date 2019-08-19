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
@class ApprovalModel;
@interface WXMessageAlertViewCell : UITableViewCell
- (void)setModel: (WXMessageAlertModel *)model;
@property (nonatomic, strong) ApprovalModel *comModel;

@property (nonatomic, copy) void (^makeSureAction)(void);
@end

NS_ASSUME_NONNULL_END
