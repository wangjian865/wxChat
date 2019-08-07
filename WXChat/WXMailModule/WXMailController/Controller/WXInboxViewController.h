//
//  WXInboxViewController.h
//  MailDemo
//
//  Created by 王坚 on 2019/6/21.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXInboxViewController : UIViewController
///邮箱
@property (nonatomic, copy) NSString *account;
///类型
@property (nonatomic, copy) NSString *type;
///id 1 收件箱 2 草稿箱 3 发送箱 4 垃圾箱
@property (nonatomic, copy) NSString *ID;
@end

NS_ASSUME_NONNULL_END
