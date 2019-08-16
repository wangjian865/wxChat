//
//  WXUsersListCell.h
//  WXChat
//
//  Created by WDX on 2019/6/6.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXUsersListCell : UITableViewCell<IModelCell>
/** @brief 用户model */
@property (strong, nonatomic) id<IUserModel> model;
//复用时修改选中状态
@property (nonatomic, assign) BOOL CellSelected;
//是否编辑状态
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, copy) void (^chooseAction)(NSString *buddy);

///是否显示遮盖
@property (nonatomic, assign) BOOL showCoverView;

///wdxuserlist
@property (nonatomic, assign) SearchUserModel *wxModel;
@end

NS_ASSUME_NONNULL_END
