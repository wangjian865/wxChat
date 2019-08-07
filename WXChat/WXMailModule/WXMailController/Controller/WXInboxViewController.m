//
//  WXInboxViewController.m
//  MailDemo
//
//  Created by 王坚 on 2019/6/21.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXInboxViewController.h"
#import "WXMailCell.h"
#import "MailInfoList.h"
@interface WXInboxViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 * list
 */
@property (nonatomic, strong) UITableView *mailListView;
/**
 * MailInfoList
 */
@property (nonatomic, strong) MailInfoList *myModel;
@end

@implementation WXInboxViewController
- (UITableView *)mailListView{
    if (_mailListView == nil){
        _mailListView = [[UITableView alloc] initWithFrame:CGRectMake(1, 1, 1, 1)  style:UITableViewStylePlain];
        _mailListView.delegate = self;
        _mailListView.dataSource = self;
        _mailListView.rowHeight = UITableViewAutomaticDimension;
        _mailListView.estimatedRowHeight = 75;
        [_mailListView registerClass:[WXMailCell class] forCellReuseIdentifier:@"WXMailCell"];
    }
    return _mailListView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mailListView];
    [self setNaviBar];
    [self getData];
}
- (void)getData {
    [MailViewModel getMailInfoWithMailAccount:self.account pushId:@"" accountType:self.type categoryType:self.ID successBlock:^(MailInfoList * _Nonnull model) {
        self.myModel = model;
        [self.mailListView reloadData];
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
- (void)setNaviBar {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(writeEmail) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"发邮件" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
- (void)writeEmail {
    NSLog(@"写邮件啦");
}
- (void)viewDidLayoutSubviews {
    [self.mailListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark -- UITableViewDelegate && Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.myModel){
        return self.myModel.context.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXMailCell" forIndexPath:indexPath];
    MailInfo *model = _myModel.context[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
@end
