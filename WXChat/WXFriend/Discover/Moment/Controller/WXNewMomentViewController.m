//
//  WXNewMomentViewController.m
//  WXChat
//
//  Created by WX on 2019/7/12.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXNewMomentViewController.h"
#import <YYText.h>
#import "WXPhotoCollectionViewCell.h"
#import "MBProgressHUD+NJ.h"
#import "CompanyViewModel.h"
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
//发布朋友圈动态
@interface WXNewMomentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) YYTextView *textTF;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, weak) UIView *myAlertView;
///是否抖动
@property (nonatomic, assign) BOOL isItemShake;
///记录选中的图片
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation WXNewMomentViewController

- (UIImagePickerController *)imagePicker{
    if (_imagePicker == nil){
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
- (NSMutableArray *)photos{
    if (_photos == nil){
        _photos = [NSMutableArray array];
    }
    return _photos;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:false];
    UIImage *image = [UIImage getImageWithColor:rgb(48,134,191)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isItemShake = NO;
    [self setupNavi];
    [self setupUI];
}
- (void)setupNavi{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.backgroundColor = UIColor.clearColor;
    rightBtn.size = CGSizeMake(54, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    rightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    rightBtn.layer.borderWidth = 1.0;
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
- (void)rightButtonAction{
    if (!((self.photos.count > 0) || (self.textTF.text.length > 0))){
        [MBProgressHUD showError:@"您还未输入"];
        return;
    }
    NSMutableArray *names = [NSMutableArray array];
    for (UIImage *image in self.photos) {
        [names addObject:@"files"];
    }
    [CompanyViewModel publicMomentsMessage:self.textTF.text files:self.photos fileNames:names successBlock:^(NSString * _Nonnull successMsg) {
        if (self.parentVC){
            self.parentVC.isNeedRefresh = YES;
        }
        [self.navigationController popViewControllerAnimated:true];
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
- (void)setupUI{
    self.view.backgroundColor = kColor_LightGray;
    //tf
    self.textTF = [YYTextView new];
    self.textTF.textColor = [UIColor darkTextColor];
    self.textTF.font = [UIFont systemFontOfSize:16];
    self.textTF.placeholderFont = [UIFont systemFontOfSize:16];
    self.textTF.placeholderTextColor = [UIColor darkGrayColor];
    self.textTF.placeholderText = @"输入这一刻的想法...";
    [self.view addSubview:self.textTF];
    [self.textTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(21);
        make.height.mas_equalTo(130);
    }];
    
    //col
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 7;
    layout.minimumInteritemSpacing = 7;
    CGFloat all = (CGFloat)(k_screen_width - 30 - 14);
    CGFloat width = all/3.0;
    layout.itemSize = CGSizeMake(width, width);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = kColor_LightGray;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"WXPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"photoCell"];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textTF);
        make.height.mas_equalTo(400);
        make.top.equalTo(self.textTF.mas_bottom).offset(22);
    }];
    [self addRecognize];
}
- (void)addRecognize
{
    UILongPressGestureRecognizer *recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    //设置长按响应时间为0.5秒
    recognize.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:recognize];
}
- (void)addGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.collectionView addGestureRecognizer:tap];
}
- (void)tapGestureAction: (UITapGestureRecognizer *)tapGes{
    _isItemShake = NO;
    [self.collectionView reloadData];
    [self.collectionView removeGestureRecognizer:tapGes];
    [self addRecognize];
}
// 长按抖动手势方法
- (void)longPressGestureAction:(UILongPressGestureRecognizer *)longGesture {
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            // 移除长按手势
            [self.collectionView removeGestureRecognizer:longGesture];
            
            // 为collectionView添加单击手势
            [self addGesture];
            
            // 用一个BOOL类型的全局变量，记录collectionView是否为抖动状态，YES：抖动，NO：停止抖动
            _isItemShake = YES;
            [self.collectionView reloadData];
        }
            break;
        case UIGestureRecognizerStateChanged: {}
            break;
        case UIGestureRecognizerStateEnded: {}
            break;
        default:
            break;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WXPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    if (indexPath.row < self.photos.count){
        cell.myImageView.image = _photos[indexPath.row];
        cell.myImageView.contentMode = UIViewContentModeScaleAspectFill;
        WS(wSelf);
        cell.deletePhotoAction = ^{
            [wSelf deleteImage:(int)indexPath.row];
        };
        if (self.isItemShake){
            [cell beginShake];
            cell.closeButton.hidden = NO;
        }else{
            [cell stopShake];
            cell.closeButton.hidden = YES;
        }
        //照片
    }else if(indexPath.row == self.photos.count){
        //加号
        cell.myImageView.image = [UIImage imageNamed:@"plus_moment"];
        cell.myImageView.contentMode = UIViewContentModeScaleToFill;
        cell.closeButton.hidden = YES;
    }
    return cell;
}
///给cell中的删除按钮实现删除方法
- (void)deleteImage:(int )index {
    [self.photos removeObjectAtIndex:index];
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.photos.count > 8){
        return 9;
    }
    return self.photos.count + 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:true];
    //当点击添加图片时
    if (indexPath.row == self.photos.count){
        
        ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
        
        // 相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
        int maxCount = (int)(9 - self.photos.count);
        ac.configuration.maxSelectCount = maxCount;
        ac.configuration.maxPreviewCount = 10;
        ac.configuration.allowSelectGif = NO;
        ac.configuration.allowRecordVideo = NO;
        ac.configuration.allowSelectVideo = NO;
        //如调用的方法无sender参数，则该参数必传
        ac.sender = self;
        // 选择回调
        WS(wSelf);
        [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            [wSelf.photos addObjectsFromArray:images];
            [self.collectionView reloadData];
        }];
        
        // 调用相册
        [ac showPreviewAnimated:YES];
        
//        WXTwoBottomChooseView *alertView = (WXTwoBottomChooseView *)([[NSBundle mainBundle] loadNibNamed:@"WXBottomChooseView" owner:nil options:nil].lastObject);
//        [alertView.firstBtn addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
//        [alertView.secondBtn addTarget:self action:@selector(openAlbun) forControlEvents:UIControlEventTouchUpInside];
//        _myAlertView = alertView;
//        [self.view.window addSubview:alertView];
//        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.height.left.right.equalTo(self.view.window);
//
//        }];
        return;
    }
    //点击看大图模式
    
}

- (void)openCamera {
    [_myAlertView removeFromSuperview];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"暂无相机权限"];
    }
}
- (void)openAlbun {
    [_myAlertView removeFromSuperview];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"暂无相册权限"];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [_imagePicker dismissViewControllerAnimated:true completion:nil];
    UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
    [self.photos addObject:image];
    [_collectionView reloadData];
    
}
@end
