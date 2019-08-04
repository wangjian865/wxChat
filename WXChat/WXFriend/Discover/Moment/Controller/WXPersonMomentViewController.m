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

@interface WXPersonMomentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MMTableView * tableView;
@property (nonatomic, strong) UIView * tableHeaderView;
@property (nonatomic, strong) MMImageView * coverImageView;
@property (nonatomic, strong) MMImageView * avatarImageView;

@property (nonatomic, strong) FriendMomentInfoList *myModel;
@end

@implementation WXPersonMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getData];
}
- (void)getData {
    [CompanyViewModel getMomentsListWithUserid:self.userId page:@"1" successBlock:^(FriendMomentInfoList * _Nonnull model) {
        self.myModel = model;
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
    self.avatarImageView = imageView;
    // 表头
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, 270)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = UIColor.whiteColor;
    [view addSubview:self.coverImageView];
    [view addSubview:self.avatarImageView];
    self.tableHeaderView = view;
    // 表格
    MMTableView * tableView = [[MMTableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height-k_top_height)];
    tableView.estimatedRowHeight = 40;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerNib:[UINib nibWithNibName:@"WXMyMomentTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    tableView.showsVerticalScrollIndicator = false;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView = self.tableHeaderView;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_myModel != nil) {
        return _myModel.data.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMyMomentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.infoModel = _myModel.data[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RelationViewController" bundle:nil];
    WXMomentDetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"momentDetailVC"];
    FriendMomentInfo *model = _myModel.data[indexPath.row];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:true];
}
@end
