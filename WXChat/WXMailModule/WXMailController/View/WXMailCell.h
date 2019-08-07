//
//  WXMailCell.h
//  MailDemo
//
//  Created by 王坚 on 2019/6/21.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface WXMailCell : UITableViewCell
@property (nonatomic, strong)MailInfo *model;
@end

NS_ASSUME_NONNULL_END
