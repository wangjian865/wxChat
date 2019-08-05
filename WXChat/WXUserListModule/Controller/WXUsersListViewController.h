//
//  WXUsersListViewController.h
//  WXChat
//
//  Created by WDX on 2019/5/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "EaseUsersListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXUsersListViewController : EaseUsersListViewController
//编辑模式下存在
//group用于业务逻辑中直接跳转群组会话页面
@property (nonatomic, copy) void (^doneCompletion)(EMGroup *group);
@property (nonatomic, copy) void (^chooseCompletion)(NSArray <NSString *>*IDS);
@property (nonatomic, assign) BOOL isEditing;
//是否为创建群组
@property (nonatomic, assign) BOOL isGroup;
@end

NS_ASSUME_NONNULL_END
