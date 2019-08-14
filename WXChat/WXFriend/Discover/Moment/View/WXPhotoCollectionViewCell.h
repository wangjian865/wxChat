//
//  WXPhotoCollectionViewCell.h
//  WXChat
//
//  Created by WX on 2019/7/12.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (copy, nonatomic) void (^deletePhotoAction)(void);
- (void)beginShake;
- (void)stopShake;
@end

NS_ASSUME_NONNULL_END
