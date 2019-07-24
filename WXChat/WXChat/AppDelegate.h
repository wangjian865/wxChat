//
//  AppDelegate.h
//  WXChat
//
//  Created by WDX on 2019/4/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 用于记录当前点击的评论frame
@property (nonatomic, assign) CGRect convertRect;

+ (AppDelegate *)sharedInstance;
- (void)loginStateChange: (BOOL)isLogin huanxinID:(NSString *)ID;
@end

