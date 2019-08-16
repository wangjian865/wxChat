//
//  WXMyMomentTableViewCell.h
//  WXChat
//
//  Created by WX on 2019/8/4.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendMomentInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface WXMyMomentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;

@property (nonatomic, strong) FriendMomentInfo *infoModel;

@end

NS_ASSUME_NONNULL_END
