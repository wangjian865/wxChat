//
//  WXResultViewCell.h
//  WXChat
//
//  Created by WDX on 2019/6/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"
#import "UserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WXResultViewCell : UITableViewCell
@property (nonatomic, strong)GroupModel *groupModel;
@property (nonatomic, strong)UserInfoModel *userModel;
@end

NS_ASSUME_NONNULL_END
