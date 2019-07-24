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

//发布朋友圈动态
@interface WXNewMomentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) YYTextView *textTF;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, weak) UIView *myAlertView;

@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation WXNewMomentViewController

- (UIImagePickerController *)imagePicker{
    if (_imagePicker == nil){
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}
- (NSMutableArray *)photos{
    if (_photos == nil){
        _photos = [NSMutableArray array];
    }
    return _photos;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
- (void)setupUI{
    self.view.backgroundColor = kColor_LightGray;
    //tf
    self.textTF = [YYTextView new];
    self.textTF.textColor = [UIColor darkTextColor];
    self.textTF.font = [UIFont systemFontOfSize:12];
    self.textTF.placeholderFont = [UIFont systemFontOfSize:12];
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
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WXPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    if (indexPath.row < self.photos.count){
        cell.myImageView.image = _photos[indexPath.row];
        //照片
    }else if(indexPath.row == self.photos.count){
        //加号
        cell.myImageView.backgroundColor = UIColor.yellowColor;
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count + 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //当点击添加图片时
    if (indexPath.row == self.photos.count){
        WXTwoBottomChooseView *alertView = (WXTwoBottomChooseView *)([[NSBundle mainBundle] loadNibNamed:@"WXBottomChooseView" owner:nil options:nil].lastObject);
        [alertView.firstBtn addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
        [alertView.secondBtn addTarget:self action:@selector(openAlbun) forControlEvents:UIControlEventTouchUpInside];
        _myAlertView = alertView;
        [self.view.window addSubview:alertView];
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
    UIImage *image = (UIImage *)info[UIImagePickerControllerEditedImage];
    [self.photos addObject:image];
    [_collectionView reloadData];
    NSLog(@"拿到了编辑后的图片");
}
@end
