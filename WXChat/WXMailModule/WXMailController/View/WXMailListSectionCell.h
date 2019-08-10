//
//  WXMailListSectionCell.h
//  MailDemo
//
//  Created by WDX on 2019/6/19.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXMailListSectionCell : UITableViewCell
/**
 * accountlLabel
 */
@property (nonatomic, strong) UILabel *accountLabel;
/**
 * countLabel
 */
@property (nonatomic, strong) UILabel *countLabel;
/**
 * icon箭头
 */
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, assign) BOOL isShow;
@end

NS_ASSUME_NONNULL_END
