//
//  WXContactCell.h
//  WXChat
//
//  Created by WX on 2019/7/17.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectionIcon;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) FriendModel *model;
@end

NS_ASSUME_NONNULL_END
