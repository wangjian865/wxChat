//
//  UIImage+ColorImage.m
//  WXChat
//
//  Created by WDX on 2019/6/3.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "UIImage+ColorImage.h"

@implementation UIImage (ColorImage)
+ (UIImage *)getImageWithColor: (UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIImage *)WX_imageWithUrlString:(NSString *)imageUrl
{
    UIImageView * imageView = [[UIImageView alloc] init];
    NSURL * url = [NSURL URLWithString:imageUrl];
    [imageView sd_setImageWithURL:url placeholderImage:nil];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    BOOL existBool = [manager diskImageExistsForURL:url];//判断是否有缓存
    UIImage * image;
    if (existBool) {
        image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
    }else{
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
    }
    return image;
}

+ (UIImage *) combine:(NSArray<UIImage *> *)images
{
    CGSize offScreenSize = CGSizeMake(200, 200);
    
    UIGraphicsBeginImageContext(offScreenSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);//图片背景色
    CGContextFillRect(context, CGRectMake(0, 0, 200, 200));
    //确定拼接图片的宽度
    CGFloat imageWidth = [self generateImageWidthWithImageCount:images.count];
    
    switch (images.count) {
            
        case 2:
        {
            CGFloat row_1_origin_y = (200 - imageWidth) / 2;
            [self generatorMatrix:images beginOriginY:row_1_origin_y];
        }
            break;
        case 3:
        {
            CGFloat row_1_origin_y = (200 - imageWidth * 2) / 3;
            
            UIImage* image_1 = images[0];
            CGRect rect_1 = CGRectMake((200 - imageWidth) / 2, row_1_origin_y, imageWidth, imageWidth);
            [image_1 drawInRect:rect_1];
            [self generatorMatrix:images beginOriginY:row_1_origin_y + imageWidth + 10];
        }
            break;
        case 4:
        {
            CGFloat row_1_origin_y = (200 - imageWidth * 2) / 3;
            [self generatorMatrix:images beginOriginY:row_1_origin_y];
        }
            break;
        case 5:
        {
            CGFloat row_1_origin_y = (200 - imageWidth * 2 - 10) / 2;
            
            UIImage* image_1 = images[0];
            CGRect rect_1 = CGRectMake((200 - 2 * imageWidth - 10) / 2, row_1_origin_y, imageWidth, imageWidth);
            [image_1 drawInRect:rect_1];
            
            UIImage* image_2 = images[1];
            CGRect rect_2 = CGRectMake(rect_1.origin.x + imageWidth + 10, row_1_origin_y, imageWidth, imageWidth);
            [image_2 drawInRect:rect_2];
            
            [self generatorMatrix:images beginOriginY:row_1_origin_y + imageWidth + 10];
        }
            break;
        case 6:
        {
            CGFloat row_1_origin_y = (200 - imageWidth * 2 - 10) / 2;
            
            [self generatorMatrix:images beginOriginY:row_1_origin_y];
        }
            break;
        case 7:
        {
            CGFloat row_1_origin_y = (200 - imageWidth * 3) / 4;
            
            UIImage* image_1 = images[0];
            CGRect rect_1 = CGRectMake((200 - imageWidth) / 2, row_1_origin_y, imageWidth, imageWidth);
            [image_1 drawInRect:rect_1];
            [self generatorMatrix:images beginOriginY:row_1_origin_y + imageWidth + 10];
        }
            break;
        case 8:
        {
            CGFloat row_1_origin_y = (200 - imageWidth * 3) / 4;
            
            UIImage* image_1 = images[0];
            CGRect rect_1 = CGRectMake((200 - 2 * imageWidth - 10) / 2, row_1_origin_y, imageWidth, imageWidth);
            [image_1 drawInRect:rect_1];
            UIImage* image_2 = images[1];
            CGRect rect_2 = CGRectMake(rect_1.origin.x + imageWidth + 10, row_1_origin_y, imageWidth, imageWidth);
            [image_2 drawInRect:rect_2];
            [self generatorMatrix:images beginOriginY:row_1_origin_y + imageWidth + 10];
        }
            break;
        case 9:
        {
            CGFloat row_1_origin_y = (200 - imageWidth * 3) / 4;
            [self generatorMatrix:images beginOriginY:row_1_origin_y];
        }
            break;
        default:
            break;
    }
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imagez;
}

+ (void)generatorMatrix:(NSArray *)images beginOriginY:(CGFloat)beginOriginY {
    int count = (int)images.count;
    
    int cellCount;
    int maxRow;
    int maxColumn;
    int ignoreCountOfBegining;
    
    if (count <= 4)
    {
        maxRow = 2;
        maxColumn = 2;
        ignoreCountOfBegining = count % 2;
        cellCount = 4;
    }
    else
    {
        maxRow = 3;
        maxColumn = 3;
        ignoreCountOfBegining = count % 3;
        cellCount = 9;
    }
    CGFloat imageWidth = [self generateImageWidthWithImageCount:images.count];
    
    for (int i = 0; i < cellCount; i++) {
        if (i > images.count - 1) break;
        if (i < ignoreCountOfBegining) continue;
        
        int row = floor((float)(i - ignoreCountOfBegining) / maxRow);
        int column = (i - ignoreCountOfBegining) % maxColumn;
        
        CGFloat origin_x = 10 + imageWidth * column + 10 * column;
        CGFloat origin_y = beginOriginY + imageWidth * row + 10 * row;
        
        CGRect rect = CGRectZero;
        rect = CGRectMake(origin_x, origin_y, imageWidth, imageWidth);
        [images[i] drawInRect:rect];
    }
}

+ (CGFloat)generateImageWidthWithImageCount:(NSInteger)count {
    CGFloat sideLength = 0.0f;
    
    if (count >=2 && count <=4) {
        sideLength = (200 - 10 * 3) / 2;
    } else {
        sideLength = (200 - 10 * 4) / 3;
    }
    
    return sideLength;
}
@end
