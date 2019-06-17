//
//  SDShortVideoController.h
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/11.
//  Copyright © 2016年 GSD. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface SDShortVideoController : UIViewController

- (void)show;
- (void)hidde;

@property (nonatomic, copy) void (^cancelOperratonBlock)(void);

@property (nonatomic, assign, readonly) BOOL isRecordingVideo;

@end
