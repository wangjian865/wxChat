//
//  WDXUserListViewController.h
//  WXChat
//
//  Created by WX on 2019/8/4.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDXUserListViewController : UIViewController
///rightNavBtnTitle
@property (nonatomic, copy)NSString *rightTitle;
///传入的用户数组
@property (nonatomic, strong)NSArray *users;
///已被选中的用户
@property (nonatomic, strong)NSArray *selectedIDS;
///返回选中的
@property (nonatomic, copy) void (^chooseCompletion)(NSArray <NSString *>*IDS);
@end

NS_ASSUME_NONNULL_END
