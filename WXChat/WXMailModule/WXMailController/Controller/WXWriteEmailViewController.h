//
//  WXWriteEmailViewController.h
//  WXChat
//
//  Created by WX on 2019/8/5.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXWriteEmailViewController : UIViewController
///邮箱
@property (nonatomic, copy) NSString *account;
///类型
@property (nonatomic, copy) NSString *type;
///转发时传入的htmlStr
@property (nonatomic, copy) NSString *htmlStr;
///邮件id 转发和回复时需要
@property (nonatomic, copy) NSString *messageID;
///主题
@property (nonatomic, copy) NSString *subjectStr;
///是否为回复  true:回复  false:转发
@property (nonatomic, assign) BOOL isReply;
///收件人
@property (nonatomic, copy) NSString *receiver;
@end

NS_ASSUME_NONNULL_END
