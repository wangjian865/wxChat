//
//  WXNewMomentMessageViewCell.h
//  WXChat
//
//  Created by WX on 2019/7/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface WXNewMomentMessageViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIconView;
@property (weak, nonatomic) IBOutlet UIImageView *momentImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong)CommentInfo *model;
@end

NS_ASSUME_NONNULL_END
