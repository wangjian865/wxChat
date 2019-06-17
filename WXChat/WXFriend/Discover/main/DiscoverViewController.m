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
@end

@implementation DiscoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titles = [NSArray arrayWithObjects:
                   @[@"企业圈"],@[@"企业查询"],
                   @[@"简问百科",@"竹简招聘"],
                   @[@"购物",@"外卖"], nil];
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
        [self performEyeViewAnimation];
    }
    
    CGPoint point = [pan translationInView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    
    if (self.tableViewIsHidden && ![self.shortVideoController isRecordingVideo]) {
        CGFloat tabBarTop = self.navigationController.tabBarController.tabBar.top;
        CGFloat maxTabBarY = [UIScreen mainScreen].bounds.size.height + self.tableView.height;
        if (!(tabBarTop > maxTabBarY && point.y > 0)) {
            self.tableView.top += point.y;
            self.navigationController.tabBarController.tabBar.top += point.y;
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.tableView.contentOffset.y < - (64 + kCraticalProgressHeight) && !self.tableViewIsHidden) {
            [self startTableViewAnimationWithHidden:YES];
        } else if (self.tableViewIsHidden) {
            BOOL shouldHidde = NO;
            if (self.tableView.top > [UIScreen mainScreen].bounds.size.height - 150) {
                shouldHidde = YES;
            }
            [self startTableViewAnimationWithHidden:shouldHidde];
        }
        
    }
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.titles objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MomentCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MomentCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"discover_%ld_%ld",indexPath.section,indexPath.row]];
    cell.textLabel.text = [[self.titles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MomentViewController * controller = [[MomentViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section == 1){
        //跳转天眼通
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sky20170605://"]];
    }else if (indexPath.section == 2){
        if (indexPath.row == 0){
            //百度
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"com.baidu.BaiduMobile://"]];
        }else{
            //智联
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alisdkZhaopin://"]];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0){
            //淘宝
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"taobao://"]];
        }else{
            //外卖
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"eleme://"]];
        }
        
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
