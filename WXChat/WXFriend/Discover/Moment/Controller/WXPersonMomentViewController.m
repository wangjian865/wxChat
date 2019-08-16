//
//  WXPersonMomentViewController.m
//  WXChat
//
//  Created by WX on 2019/7/15.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXPersonMomentViewController.h"
#import "MMImageListView.h"
#import "CompanyViewModel.h"
#import "WXMyMomentTableViewCell.h"
#import "WXSingleViewController.h"
@interface WXPersonMomentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MMTableView * tableView;
@property (nonatomic, strong) UIView * tableHeaderView;
@property (nonatomic, strong) MMImageView * coverImageView;
@property (nonatomic, strong) MMImageView * avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) FriendMomentInfoList *myModel;
@property (nonatomic, assign) int page;
@end

@implementation WXPersonMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self setupUI];
    [self getData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:false];
    UIImage *image = [UIImage getImageWithColor:rgb(48,134,191)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor clearColor]}];
    [self.navigationController.navigationBar setTranslucent:true];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}
- (void)getData {
    [CompanyViewModel getMomentsListWithUserid:self.userId page:[NSString stringWithFormat:@"%d",_page] successBlock:^(FriendMomentInfoList * _Nonnull model) {
        if (self.myModel == nil){
            self.myModel = model;
            [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.user.tgusetImg]];
            self.nameLabel.text = model.user.tgusetName;
            self.companyLabel.text = model.user.tgusetCompany;
        }else{
            [self.myModel.enterprise addObjectsFromArray:model.enterprise];
        }
        self.page += 1;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    // 封面
    MMImageView * imageView = [[MMImageView alloc] initWithFrame:CGRectMake(0, -k_top_height, k_screen_width, 270)];
    imageView.image = [UIImage imageNamed:@"moment_cover"];
    self.coverImageView = imageView;
    // 用户头像
    imageView = [[MMImageView alloc] initWithFrame:CGRectMake(k_screen_width-85, self.coverImageView.bottom-40, 75, 75)];
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageView.layer.borderWidth = 2;
    imageView.image = [UIImage imageNamed:@"moment_head"];
    imageView.cornerRadius = 75/2;
    self.avatarImageView = imageView;
    //用户名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"z奥特曼";
    nameLabel.textColor = rgb(255, 255, 255);
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.width = 200;
    nameLabel.height = 17;
    nameLabel.right = imageView.left - 14;
    nameLabel.bottom = self.coverImageView.bottom - 5;
    nameLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel = nameLabel;
    //公司
    UILabel *companyLabel = [[UILabel alloc] init];
    companyLabel.text = @"这是某某某o";
    companyLabel.textColor = rgb(153, 153, 153);
    companyLabel.width = 250;
    companyLabel.right = imageView.left - 15;
    companyLabel.font = [UIFont systemFontOfSize:14];
    companyLabel.top = self.coverImageView.bottom + 4;
    companyLabel.height = 14;
    companyLabel.textAlignment = NSTextAlignmentRight;
    self.companyLabel = companyLabel;
    // 表头
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, 270)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = UIColor.whiteColor;
    [view addSubview:self.coverImageView];
    [view addSubview:self.avatarImageView];
    [view addSubview:self.companyLabel];
    [view addSubview:self.nameLabel];
    self.tableHeaderView = view;
    // 表格
    MMTableView * tableView = [[MMTableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height)];
    tableView.estimatedRowHeight = 40;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerNib:[UINib nibWithNibName:@"WXMyMomentTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    tableView.showsVerticalScrollIndicator = false;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView = self.tableHeaderView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // 上拉加载更多
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    [footer.arrowView setImage:[UIImage imageNamed:@"refresh_pull"]];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松手加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已加载全部" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    self.tableView.mj_footer = footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_myModel != nil) {
        return _myModel.enterprise.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMyMomentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.infoModel = _myModel.enterprise[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RelationViewController" bundle:nil];
//    WXMomentDetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"momentDetailVC"];
    FriendMomentInfo *model = _myModel.enterprise[indexPath.row];
//    detailVC.model = model;
//    [self.navigationController pushViewController:detailVC animated:true];
    WXSingleViewController *singleVC = [[WXSingleViewController alloc] init];
    singleVC.model = model;
    
    [self.navigationController pushViewController:singleVC animated:true];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [kNotificationCenter postNotificationName:@"ResetMenuView" object:nil];
    NSLog(@"%f",self.tableView.contentOffset.y);
    CGFloat offsetY = self.tableView.contentOffset.y;
    if (offsetY < 80){
        //透明
        [self.navigationController.navigationBar setTranslucent:true];
        UIImage *image = [UIImage getImageWithColor:UIColor.clearColor];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor clearColor]}];
    }else if (offsetY > 120){
        //完全显示
        [self.navigationController.navigationBar setTranslucent:true];
        UIImage *image = [UIImage getImageWithColor:rgb(48,134,191)];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }else{
        //        暂定变换区间未80-120
        [self.navigationController.navigationBar setTranslucent:true];
        CGFloat scale = (offsetY - 80)/40;
        UIImage *image = [UIImage getImageWithColor:RGB(48,134,191,scale)];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
}
@end
