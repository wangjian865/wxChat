//
//  WDXUsersListCell.h
//  WXChat
//
//  Created by WX on 2019/8/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDXUsersListCell : UITableViewCell
/**
 * 头像
 */
@property (nonatomic, strong) UIImageView *avatarView;
/**
 * 名字
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 * editMode下存在选中框
 */
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIView *coverView;

//复用时修改选中状态
@property (nonatomic, copy) void (^chooseAction)(NSString *buddy);
@property (nonatomic, assign) BOOL CellSelected;
@property (nonatomic, assign) SearchUserModel *wxModel;
@end

NS_ASSUME_NONNULL_END
