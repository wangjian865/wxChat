//
//  WXDiscoverViewCell.h
//  WXChat
//
//  Created by WDX on 2019/6/17.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXDiscoverViewCell : UITableViewCell
/**
 * icon
 */
@property (nonatomic, strong) UIImageView *iconView;
/**
 * title
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 * 底部线
 */
@property (nonatomic, strong) UIView *line;
/**
 * countLabel
 */
@property (nonatomic, strong) UILabel *countLabel;
/**
 * countLabel
 */
@property (nonatomic, strong) UIImageView *unreadIcon;
@end

NS_ASSUME_NONNULL_END
