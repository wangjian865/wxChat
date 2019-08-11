//
//  UIImage+WXGroup.h
//  WXChat
//
//  Created by WX on 2019/8/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (WXGroup)
+ (UIImage *)groupIconWith:(NSArray *)array bgColor:(UIColor *)bgColor;
+ (void)groupIconWithURLArray:(NSArray *)URLArray bgColor:(UIColor *)bgColor successBlock:(void(^) (UIImage *image))success;
@end

NS_ASSUME_NONNULL_END
