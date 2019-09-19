//
//  MMImageListView.m
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMImageListView.h"
#import "MMImagePreviewView.h"

#pragma mark - ------------------ 小图List显示视图 ------------------

@interface MMImageListView ()<UUActionSheetDelegate>

// 图片视图数组
@property (nonatomic, strong) NSMutableArray * imageViewsArray;
// 预览视图
@property (nonatomic, strong) MMImagePreviewView * previewView;
// 长按保存的图片
@property (nonatomic, strong) UIImage *longPressImg;
@end

@implementation MMImageListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 小图(九宫格)
        _imageViewsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 9; i++) {
            MMImageView * imageView = [[MMImageView alloc] initWithFrame:CGRectZero];
            imageView.tag = 1000 + i;
            [imageView setClickHandler:^(MMImageView *imageView){
                [self singleTapSmallViewCallback:imageView];
                if (self.singleTapHandler) {
                    self.singleTapHandler(imageView);
                }
            }];
            [_imageViewsArray addObject:imageView];
            [self addSubview:imageView];
        }
        // 预览视图
        _previewView = [[MMImagePreviewView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];      
    }
    return self;
}
#pragma mark - wxsetter
- (void)setImageArr:(NSArray *)imageArr{
    _imageArr = imageArr;
    for (MMImageView * imageView in _imageViewsArray) {
        imageView.hidden = YES;
    }
    // 图片区
    NSInteger count = [imageArr count];
    if (count == 0) {
        self.size = CGSizeZero;
        return;
    }
    // 更新视图数据
    _previewView.pageNum = count;
    _previewView.scrollView.contentSize = CGSizeMake(_previewView.width*count, _previewView.height);
    // 添加图片
    MMImageView * imageView = nil;
    for (NSInteger i = 0; i < count; i++)
    {
        NSInteger rowNum = i / 3;
        NSInteger colNum = i % 3;
        if(count == 4) {
            rowNum = i / 2;
            colNum = i % 2;
        }
        CGFloat imageX = colNum * (kImageWidth + kImagePadding);
        CGFloat imageY = rowNum * (kImageWidth + kImagePadding);
        CGRect frame = CGRectMake(imageX, imageY, kImageWidth, kImageWidth);
        
        // 单张图片需计算实际显示size
        if (count == 1) {
            CGSize singleSize = [Utility getMomentImageSize:CGSizeMake(500 , 302)];
            frame = CGRectMake(0, 0, singleSize.width, singleSize.height);
        }
        imageView = [self viewWithTag:1000+i];
        imageView.hidden = NO;
        imageView.frame = frame;
        // 赋值
//        MPicture * picture = [imageArr objectAtIndex:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[i]]
                     placeholderImage:nil];
    }
    self.width = kTextWidth;
    self.height = imageView.bottom;
}
#pragma mark - Setter
- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    for (MMImageView * imageView in _imageViewsArray) {
        imageView.hidden = YES;
    }
    // 图片区
    NSInteger count = [moment.pictureList count];
    if (count == 0) {
        self.size = CGSizeZero;
        return;
    }
    // 更新视图数据
    _previewView.pageNum = count;
    _previewView.scrollView.contentSize = CGSizeMake(_previewView.width*count, _previewView.height);
    // 添加图片
    MMImageView * imageView = nil;
    for (NSInteger i = 0; i < count; i++)
    {
        NSInteger rowNum = i / 3;
        NSInteger colNum = i % 3;
        if(count == 4) {
            rowNum = i / 2;
            colNum = i % 2;
        }
        CGFloat imageX = colNum * (kImageWidth + kImagePadding);
        CGFloat imageY = rowNum * (kImageWidth + kImagePadding);
        CGRect frame = CGRectMake(imageX, imageY, kImageWidth, kImageWidth);
        
        // 单张图片需计算实际显示size
        if (count == 1) {
            CGSize singleSize = [Utility getMomentImageSize:CGSizeMake(moment.singleWidth, moment.singleHeight)];
            frame = CGRectMake(0, 0, singleSize.width, singleSize.height);
        }
        imageView = [self viewWithTag:1000+i];
        imageView.hidden = NO;
        imageView.frame = frame;
        // 赋值
        MPicture * picture = [moment.pictureList objectAtIndex:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:picture.thumbnail]
                     placeholderImage:nil];
    }
    self.width = kTextWidth;
    self.height = imageView.bottom;
}

#pragma mark - 小图单击
- (void)singleTapSmallViewCallback:(MMImageView *)imageView
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    // 解除隐藏
    [window addSubview:_previewView];
    [window bringSubviewToFront:_previewView];
    // 清空
    [_previewView.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加子视图
    NSInteger index = imageView.tag - 1000;
    NSInteger count = [_imageArr count];
    CGRect convertRect;
    if (count == 1) {
        [_previewView.pageControl removeFromSuperview];
    }
    for (NSInteger i = 0; i < count; i ++)
    {
        // 转换Frame
        MMImageView *pImageView = (MMImageView *)[self viewWithTag:1000+i];
        convertRect = [[pImageView superview] convertRect:pImageView.frame toView:window];
        // 添加
        MMScrollView *scrollView = [[MMScrollView alloc] initWithFrame:CGRectMake(i*_previewView.width, 0, _previewView.width, _previewView.height)];
        scrollView.tag = 100+i;
        scrollView.maximumZoomScale = 2.0;
        scrollView.image = pImageView.image;
        scrollView.contentRect = convertRect;
        // 单击
        [scrollView setTapBigView:^(MMScrollView *scrollView){
            [self singleTapBigViewCallback:scrollView];
        }];
        // 长按
        
        [scrollView setLongPressBigView:^(MMScrollView *scrollView){
            [self longPresssBigViewCallback:scrollView];
        }];
        [_previewView.scrollView addSubview:scrollView];
        if (i == index) {
            [UIView animateWithDuration:0.3 animations:^{
                _previewView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
                _previewView.pageControl.hidden = NO;
                [scrollView updateOriginRect];
            }];
        } else {
            [scrollView updateOriginRect];
        }
    }
    // 更新offset
    CGPoint offset = _previewView.scrollView.contentOffset;
    offset.x = index * k_screen_width;
    _previewView.scrollView.contentOffset = offset;
}

#pragma mark - 大图单击||长按
- (void)singleTapBigViewCallback:(MMScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        _previewView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _previewView.pageControl.hidden = YES;
        scrollView.contentRect = scrollView.contentRect;
        scrollView.zoomScale = 1.0;
    } completion:^(BOOL finished) {
        [_previewView removeFromSuperview];
    }];
}

- (void)longPresssBigViewCallback:(MMScrollView *)scrollView
{
    self.longPressImg = scrollView.imageView.image;
    UUActionSheet *sheet = [[UUActionSheet alloc] initWithTitle:@"保存图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"存入相册",nil];
    sheet.tag = 1001;
    [sheet showInView:self.window];
}
- (void)actionSheet:(UUActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    ///存储图片到相册
    if (buttonIndex == 0){
        UIImageWriteToSavedPhotosAlbum(self.longPressImg, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
//    UIImageWriteToSavedPhotosAlbum(self.img.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil); }];
}
#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo
{
    
    [MBProgressHUD showSuccess:@"保存成功"];
//    NSString *message = @"提示";
//    if(!error) {
//        message =@"成功保存到相册";
//        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {  }];
//
//        [alertControl addAction:action];
//
//        [self presentViewController:alertControl animated:YES completion:nil];
//
//    }else
//
//    {
//        message = [error description];
//
//        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {   }];
//
//        [alertControl addAction:action];
//
//        [self presentViewController:alertControl animated:YES completion:nil];
//
//    }
    
}
@end

#pragma mark - ------------------ 单个小图显示视图 ------------------
@implementation MMImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds  = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCallback:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleTapGestureCallback:(UIGestureRecognizer *)gesture
{
    if (self.clickHandler) {
        self.clickHandler(self);
    }
}

@end
