//
//  UIImage+ColorImage.h
//  WXChat
//
//  Created by WDX on 2019/6/3.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ColorImage)
+ (UIImage *)getImageWithColor: (UIColor *)color;
+ (UIImage *) combine:(NSArray<UIImage *> *)images;
+ (UIImage *)WX_imageWithUrlString:(NSString *)imageUrl;
@end

NS_ASSUME_NONNULL_END
