//
//  WXPersonMomentViewController.h
//  WXChat
//
//  Created by WX on 2019/7/15.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXPersonMomentViewController : UIViewController
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) BOOL refreshFlag;
@end

NS_ASSUME_NONNULL_END
