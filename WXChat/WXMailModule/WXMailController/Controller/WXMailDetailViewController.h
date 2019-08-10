//
//  WXMailDetailViewController.h
//  WXChat
//
//  Created by WX on 2019/8/9.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface WXMailDetailViewController : UIViewController
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *categoryType;
@property (nonatomic, copy) NSString *emailId;
@end

NS_ASSUME_NONNULL_END
