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
#import "WXMailDetailViewController.h"
#import "WXWriteEmailViewController.h"
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
        _mailListView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _mailListView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mailListView];
    if ([_ID isEqual: @"1"]){
        self.title = @"收件箱";
        [self setNaviBar];
    }else if ([_ID isEqual: @"2"]){
        self.title = @"草稿箱";
    }else if ([_ID isEqual: @"3"]){
        self.title = @"发送箱";
    }else if ([_ID isEqual: @"4"]){
        self.title = @"垃圾箱";
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"已发送"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(writeEmail)];
}
- (void)writeEmail {
    WXWriteEmailViewController *writeVC = [[WXWriteEmailViewController alloc] init];
    writeVC.type = _type;
    writeVC.account = _account;
    
    [self.navigationController pushViewController:writeVC animated:true];
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
    WXMailDetailViewController *detailVC = [[WXMailDetailViewController alloc] init];
    MailInfo *model = _myModel.context[indexPath.row];
    detailVC.account = self.account;
    detailVC.user = _myModel.user;
    detailVC.typeName = _type;
    detailVC.categoryType = _ID;
    detailVC.emailId = model.readmailmessageid;
    [self.navigationController pushViewController:detailVC animated:true];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        MailInfo *model = _myModel.context[indexPath.row];
        [MailViewModel deleteMailWithMailAccount:_myModel.user typeName:_type categoryType:_ID emailId:model.readmailmessageid successBlock:^(NSString * _Nonnull successMessage) {
            [self getData];
        } failBlock:^(NSError * _Nonnull error) {
            
        }];
    }
}
@end
