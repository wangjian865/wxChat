//
//  WXSingleMomentViewController.h
//  WXChat
//
//  Created by WX on 2019/8/5.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMOperateMenuView.h"
#import "MMImageListView.h"
#import "Moment.h"
#import "Comment.h"
#import "Enterprise.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXSingleMomentViewController : UIViewController
// 头像
@property (nonatomic, strong) MMImageView * avatarImageView;
// 时间
@property (nonatomic, strong) UILabel * timeLabel;
// 名称
@property (nonatomic, strong) UIButton * nicknameBtn;
//公司
@property (nonatomic, strong) UILabel * companyLabel;
// 位置
@property (nonatomic, strong) UIButton * locationBtn;
// 时间
@property (nonatomic, strong) UIButton * deleteBtn;
// 全文
@property (nonatomic, strong) UIButton * showAllBtn;
// 内容
@property (nonatomic, strong) MLLinkLabel * linkLabel;
// 图片
@property (nonatomic, strong) MMImageListView * imageListView;
// 赞和评论视图
@property (nonatomic, strong) UIView * commentView;
// 赞和评论视图背景
@property (nonatomic, strong) UIImageView * bgImageView;
// 操作视图
@property (nonatomic, strong) MMOperateMenuView * menuView;
// 长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer * longPress;
// 拷贝Menu
@property (nonatomic, strong) UIMenuController * menuController;


@property (nonatomic, strong) FriendMomentInfo *model;
@end

NS_ASSUME_NONNULL_END
