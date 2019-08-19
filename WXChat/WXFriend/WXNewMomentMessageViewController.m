//
//  WXNewMomentMessageViewController.m
//  WXChat
//
//  Created by WX on 2019/7/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXNewMomentMessageViewController.h"
#import "WXNewMomentMessageViewCell.h"
#import "CompanyViewModel.h"
#import "FriendMomentInfo.h"
#import "WXSingleViewController.h"
@interface WXNewMomentMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *myView;
@property (nonatomic, strong) MomentMessageList *listModel;

@property (nonatomic, assign) int page;
@end

@implementation WXNewMomentMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    _page = 1;
    UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanBtn.backgroundColor = UIColor.clearColor;
    cleanBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cleanBtn setTitle:@"清空" forState:UIControlStateNormal];
    [cleanBtn addTarget:self action:@selector(cleanAll) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cleanBtn];
    [self setupUI];
    [self getMessageList];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_refreshFlag){
        _page = 1;
        [self getMessageList];
        _refreshFlag = NO;
    }
}
- (void)cleanAll{
    NSLog(@"清空消息列表");
    [self clearMessage];
}

- (void)setupUI{
    _myView = [[UITableView alloc] init];
    [self.view addSubview:_myView];
    [_myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _myView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _myView.delegate = self;
    _myView.dataSource = self;
    _myView.rowHeight = 83;
    [_myView registerNib:[UINib nibWithNibName:@"WXNewMomentMessageViewCell" bundle:nil] forCellReuseIdentifier:@"newMomentMessageCell"];
    WS(wSelf);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wSelf.page = 1;
        [wSelf getMessageList];
    }];
    [header setTitle:@"立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在获取数据" forState:MJRefreshStateRefreshing];
    self.myView.mj_header = header;
    // 上拉加载更多
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [wSelf getMessageList];
    }];
    [footer.arrowView setImage:[UIImage imageNamed:@"refresh_pull"]];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松手加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已加载全部" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    self.myView.mj_footer = footer;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXNewMomentMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newMomentMessageCell" forIndexPath:indexPath];
    CommentInfo *model = _listModel.data[indexPath.row];
    cell.model = model;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_listModel != nil){
        return _listModel.data.count;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    CommentInfo *model = _listModel.data[indexPath.row];
    FriendMomentInfo *temp = [[FriendMomentInfo alloc] init];
    temp.enterprisezid = model.commentszId;
    WXSingleViewController *singleVC = [[WXSingleViewController alloc] init];
    singleVC.model = temp;
    singleVC.anoParents = self;
    [self.navigationController pushViewController:singleVC animated:true];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        [self deleteSingleMessage:(int)indexPath.row];
    }
}
#pragma mark -- REQUEST
- (void)getMessageList {
    [CompanyViewModel getMomentMessageListWithPage:_page SuccessBlock:^(MomentMessageList * _Nonnull model) {
        [self.myView.mj_header endRefreshing];
        [self.myView.mj_footer endRefreshing];
        if (self.page == 1){
           self.listModel = model;
        }else{
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.listModel.data];
            [temp addObjectsFromArray:model.data];
            self.listModel.data = temp.copy;
        }
        [self.myView reloadData];
        self.page += 1;
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
//单删
- (void)deleteSingleMessage:(int )index {
    CommentInfo *model = _listModel.data[index];
    [CompanyViewModel deleteMomentsMessageListWithCommentId:model.commentsId successBlock:^(NSString * _Nonnull successMsg) {
        NSLog(@"删除单条成功");
        self.page = 1;
        [self getMessageList];
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
//清空
- (void)clearMessage {
    [CompanyViewModel deleteMomentsMessageListWithCommentId:@"" successBlock:^(NSString * _Nonnull successMsg) {
        NSLog(@"全部删除成功");
        self.page = 1;
        [self getMessageList];
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
@end
