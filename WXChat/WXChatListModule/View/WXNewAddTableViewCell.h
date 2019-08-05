//
//  WXNewAddTableViewCell.h
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXNewAddTableViewCell : UITableViewCell
@property (nonatomic, strong) WXMessageAlertModel *model;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (copy, nonatomic) void (^handleCallBack)(void);
@end

NS_ASSUME_NONNULL_END
