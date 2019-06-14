//
//  WXAddFriendViewController.h
//  WXChat
//
//  Created by WDX on 2019/6/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,WXAddVCType){
    WXAddVCTypeFriend = 0,//添加好友
    WXAddVCTypeGroup//加入群组
};
NS_ASSUME_NONNULL_BEGIN

@interface WXAddFriendViewController : UIViewController
@property (nonatomic, assign) WXAddVCType type;
@end

NS_ASSUME_NONNULL_END
