//
//  DiscoverViewController.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "DiscoverViewController.h"
#import "MomentViewController.h"
#import "SDEyeAnimationView.h"
#import "SDShortVideoController.h"
#import "WXDiscoverViewCell.h"
#import "WXPersonMomentViewController.h"
#import "WXScanViewController.h"
#define kCraticalProgressHeight 80
const CGFloat kHomeTableViewAnimationDuration = 0.25;
@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) MMTableView * tableView;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, weak) SDEyeAnimationView *eyeAnimationView;
@property (nonatomic, strong) SDShortVideoController *shortVideoController;

@property (nonatomic, assign) CGFloat tabBarOriginalY;
@property (nonatomic, assign) CGFloat tableViewOriginalY;
@property (nonatomic, assign) BOOL tableViewIsHidden;
@property (nonatomic, strong) NSDictionary *unreadDic;
@end

@implementation DiscoverViewController

- (NSDictionary *)unreadDic{
    if (!_unreadDic){
        _unreadDic = [[NSDictionary alloc] init];
    }
    return _unreadDic;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.titles = [NSArray arrayWithObjects:
//                   @[@"企业圈"],@[@"企业查询"],
//                   @[@"简问百科",@"竹简招聘"],
//                   @[@"购物",@"外卖"], nil];
    self.titles = [NSArray arrayWithObjects:
                   @[@"企业圈",@"自己圈"],@[@"扫一扫"],
                   @[@"竹简协议",@"隐私政策"], nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = k_background_color;
    [self.view addSubview:self.tableView];
    if (!self.eyeAnimationView) {
        [self setupEyeAnimationView];
        self.tabBarOriginalY = self.navigationController.tabBarController.tabBar.top;
        self.tableViewOriginalY = self.tableView.top;
    }
    
    if (!self.shortVideoController) {
        self.shortVideoController = [SDShortVideoController new];
        [self.tableView.superview insertSubview:self.shortVideoController.view atIndex:0];
        __weak typeof(self) weakSelf = self;
        [self.shortVideoController setCancelOperratonBlock:^{
            [weakSelf startTableViewAnimationWithHidden:NO];
        }];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CompanyViewModel getMomentUnreadMessageWithSuccessBlock:^(NSDictionary * _Nonnull unreadDic) {
        self.unreadDic = unreadDic;
        [self.tableView reloadData];
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)setupEyeAnimationView
{
    SDEyeAnimationView *view = [SDEyeAnimationView new];

    view.bounds = CGRectMake(0, 0, 65, 44);
    view.center = CGPointMake(self.view.bounds.size.width * 0.5, 70);
    [self.tableView.superview insertSubview:view atIndex:1];
    self.eyeAnimationView = view;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    pan.delegate = self;
    [self.tableView.superview addGestureRecognizer:pan];
    
}
- (void)panView:(UIPanGestureRecognizer *)pan
{
    
    if (self.tableView.contentOffset.y < -64) {
//        [self performEyeViewAnimation];
    }
    
//    CGPoint point = [pan translationInView:pan.view];
//    [pan setTranslation:CGPointZero inView:pan.view];
//    
//    if (self.tableViewIsHidden && ![self.shortVideoController isRecordingVideo]) {
//        CGFloat tabBarTop = self.navigationController.tabBarController.tabBar.top;
//        CGFloat maxTabBarY = [UIScreen mainScreen].bounds.size.height + self.tableView.height;
//        if (!(tabBarTop > maxTabBarY && point.y > 0)) {
//            self.tableView.top += point.y;
//            self.navigationController.tabBarController.tabBar.top += point.y;
//        }
//    }
//    
//    if (pan.state == UIGestureRecognizerStateEnded) {
//        if (self.tableView.contentOffset.y < - (64 + kCraticalProgressHeight) && !self.tableViewIsHidden) {
//            [self startTableViewAnimationWithHidden:YES];
//        } else if (self.tableViewIsHidden) {
//            BOOL shouldHidde = NO;
//            if (self.tableView.top > [UIScreen mainScreen].bounds.size.height - 150) {
//                shouldHidde = YES;
//            }
//            [self startTableViewAnimationWithHidden:shouldHidde];
//        }
//        
//    }
}
- (void)performEyeViewAnimation
{
    CGFloat height = kCraticalProgressHeight;
    CGFloat progress = -(self.tableView.contentOffset.y + 64) / height;
    if (progress > 0) {
        self.eyeAnimationView.progress = progress;
    }
    
}
#pragma mark - scrollview delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (scrollView.contentOffset.y <= 64){
        self.eyeAnimationView.progress = 0;
    }
}
- (void)startTableViewAnimationWithHidden:(BOOL)hidden
{
    CGFloat tableViewH = self.tableView.height;
    CGFloat tabBarY = 0;
    CGFloat tableViewY = 0;
    if (hidden) {
        tabBarY = tableViewH + self.tabBarOriginalY;
        tableViewY = tableViewH + self.tableViewOriginalY;
    } else {
        tabBarY = self.tabBarOriginalY;
        tableViewY = self.tableViewOriginalY;
    }
    [UIView animateWithDuration:kHomeTableViewAnimationDuration animations:^{
        self.tableView.top = tableViewY;
        self.navigationController.tabBarController.tabBar.top = tabBarY;
        self.navigationController.navigationBar.alpha = (hidden ? 0 : 1);
    } completion:^(BOOL finished) {
        self.eyeAnimationView.hidden = hidden;
        
    }];
    if (!hidden) {
        [self.shortVideoController hidde];
    } else {
        [self.shortVideoController show];
    }
    self.tableViewIsHidden = hidden;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[MMTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titles count];
//    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.titles objectAtIndex:section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXDiscoverViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MomentCell"];
    if (!cell) {
        cell = [[WXDiscoverViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MomentCell"];
        
    }
    cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"discover_%ld_%ld",indexPath.section,indexPath.row]];
    cell.titleLabel.text = [[self.titles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0){
        int count = [NSString stringWithFormat:@"%@",self.unreadDic[@"count"]].intValue;
        if (count > 0){
            cell.countLabel.hidden = NO;
            cell.unreadIcon.hidden = NO;
            cell.countLabel.text = [NSString stringWithFormat:@"%@",self.unreadDic[@"count"]];
            [cell.unreadIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.unreadDic[@"image"]]]];
        }else{
            cell.countLabel.hidden = YES;
            cell.unreadIcon.hidden = YES;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 52;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0){
            //企业圈
            MomentViewController * controller = [[MomentViewController alloc] init];
            if (self.unreadDic){
                controller.unreadDic = self.unreadDic;
            }
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            //我的企业圈
            WXPersonMomentViewController *vc = [[WXPersonMomentViewController alloc] init];
            vc.userId = [WXAccountTool getUserID];
            [self.navigationController pushViewController:vc animated:true];
        }
        
    }else if(indexPath.section == 1 ){
        //扫一扫
        WXScanViewController *scanVC = [[WXScanViewController alloc] init];
        [self.navigationController pushViewController:scanVC animated:YES];
    }else{
        if (indexPath.row == 0){
            //竹简服务协议
            WXWebViewController *webVC = [[WXWebViewController alloc] init];
            webVC.title = @"竹简服务协议";
            [self.navigationController pushViewController:webVC animated:true];
        }else{
            //隐私政策
            WXWebViewController *webVC = [[WXWebViewController alloc] init];
            webVC.title = @"隐私策略";
            [self.navigationController pushViewController:webVC animated:true];
        }
    }
//    }else if (indexPath.section == 1){
//        //跳转天眼通
//        BOOL canOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sky20170605://"]];
//        if (!canOpen){
//            [MBProgressHUD showError:@"您尚未安装天眼通"];
////            NSString *appID = @"1048918751";
////            NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", appID];
////            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//        }
//    }else if (indexPath.section == 2){
//        if (indexPath.row == 0){
//            //百度
//            BOOL canOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"s3AgCR5i5L28k0lRVe0hsXMoYbcHPwCX://"]];
//            if (!canOpen){
//                [MBProgressHUD showError:@"您尚未安装手机百度"];
////                NSString *appID = @"382201985";
////                 NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", appID];
////                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//            }
//        }else{
//            //智联
//            BOOL canOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alisdkZhaopin://"]];
//            if (!canOpen){
//                [MBProgressHUD showError:@"您尚未安装智联招聘"];
////                NSString *appID = @"488033535";
////                NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", appID];
////                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//            }
//        }
//    }else if (indexPath.section == 3){
//        if (indexPath.row == 0){
//            //淘宝
//            BOOL canOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"taobao://"]];
//            if (!canOpen){
//                [MBProgressHUD showError:@"您尚未安装淘宝"];
////                NSString *appID = @"387682726";
////                NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", appID];
////                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//            }
//        }else{
//            //外卖
//            BOOL canOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"eleme://"]];
//            if (!canOpen){
//                [MBProgressHUD showError:@"您尚未安装饿了么"];
////                NSString *appID = @"507161324";
////                NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", appID];
////                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//            }
//        }
    
//    }
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
