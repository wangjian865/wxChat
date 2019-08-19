//
//  WXSingleViewController.h
//  WXChat
//
//  Created by WX on 2019/8/5.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendMomentInfo.h"
#import "WXPersonMomentViewController.h"
#import "WXNewMomentMessageViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface WXSingleViewController : UIViewController
@property (nonatomic,strong) FriendMomentInfo *model;
@property (nonatomic, weak) WXPersonMomentViewController *parents;
@property (nonatomic, weak) WXNewMomentMessageViewController *anoParents;
@end

NS_ASSUME_NONNULL_END
