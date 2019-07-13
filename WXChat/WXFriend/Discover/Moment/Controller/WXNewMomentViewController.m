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
@interface WXNewMomentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) YYTextView *textTF;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation WXNewMomentViewController

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
        make.height.mas_equalTo(350);
        make.top.equalTo(self.textTF.mas_bottom).offset(22);
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WXPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //添加新照片的逻辑
}

@end
