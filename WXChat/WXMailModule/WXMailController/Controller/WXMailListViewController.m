//
//  WXMailListViewController.m
//  MailDemo
//
//  Created by WDX on 2019/6/18.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMailListViewController.h"
#import "WXMailListHeaderView.h"
#import "Masonry.h"
#import "WXMailListSectionCell.h"
#import "WXMailListSubCell.h"
#import "WXMailBottomCell.h"
#import "WXInboxViewController.h"
#import "WXMailLoginViewController.h"
#import "WXChooseMailTypeTableViewController.h"
#import "MailViewModel.h"
@interface WXMailListViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 * list
 */
@property (nonatomic, strong) UITableView *mailListView;
//header
@property (nonatomic, strong) WXMailListHeaderView *headerView;
//
@property (nonatomic, assign) NSInteger openIndex;
///临时count
@property (nonatomic, assign) NSInteger count;
//展开后的title
@property (nonatomic, strong) NSArray *subTitleArray;

@property (nonatomic, strong) MailPageModel *pageModel;
@end

@implementation WXMailListViewController
- (NSArray *)subTitleArray{
    if (_subTitleArray == nil){
        _subTitleArray = @[@"收件箱",@"草稿箱",@"已发送",@"垃圾邮件"];
    }
    return _subTitleArray;
}
- (UITableView *)mailListView{
    if (_mailListView == nil){
        _mailListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mailListView.frame = self.view.bounds;
        _mailListView.delegate = self;
        _mailListView.dataSource = self;
        _headerView = [[WXMailListHeaderView alloc] initWithFrame:CGRectMake(0, 0, 375, 47)];
        _mailListView.tableHeaderView = _headerView;
        [_mailListView registerClass:[WXMailListSectionCell class] forCellReuseIdentifier:@"WXMailListSectionCell"];
        [_mailListView registerClass:[WXMailListSubCell class] forCellReuseIdentifier:@"WXMailListSubCell"];
        [_mailListView registerClass:[WXMailBottomCell class] forCellReuseIdentifier:@"WXMailBottomCell"];
        _mailListView.tableFooterView = [[UIView alloc] init];
    }
    return _mailListView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 3;
    _openIndex = -1;
    [self.view addSubview:self.mailListView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getHomePageData];
}
- (void)getHomePageData{
    [MailViewModel getMailHomeDataWithSuccessBlock:^(MailPageModel * _Nonnull model) {
        self.pageModel = model;
        [self.mailListView reloadData];
        self.headerView.countLabel.text = [NSString stringWithFormat:@"%d",model.data.unreadNumber];
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //底部多两个
    if (self.pageModel != nil){
        return self.pageModel.data.email.count + 2;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //底部俩
    if (section > _count - 1){
        return 1;
    }
    if (section == _openIndex){
        return 5;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 40;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    //底部
    if (indexPath.section > self.pageModel.data.email.count - 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"WXMailBottomCell" forIndexPath:indexPath];
        NSString *title = (indexPath.section == _count) ? @"添加邮箱":@"删除邮箱";
        [(WXMailBottomCell *)cell setTitle:title];
        return cell;
    }
    //常规显示
    if (indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"WXMailListSectionCell" forIndexPath:indexPath];
        WXMailListSectionCell *temp = (WXMailListSectionCell *)cell;
        MailHomePageAccountModel *accountModel = self.pageModel.data.email[indexPath.row].accountMail;
        int junk = [NSString stringWithFormat:@"%@",accountModel.state[@"junk"][@"Emailunreadcount"]].intValue;
        int drafts = [NSString stringWithFormat:@"%@",accountModel.state[@"drafts"][@"Emailunreadcount"]].intValue;
        int inbox = [NSString stringWithFormat:@"%@",accountModel.state[@"inbox"][@"Emailunreadcount"]].intValue;
        int send = [NSString stringWithFormat:@"%@",accountModel.state[@"send"][@"Emailunreadcount"]].intValue;
        temp.accountLabel.text = accountModel.account;
        temp.countLabel.text = [NSString stringWithFormat:@"%d",junk+drafts+inbox+send];
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"WXMailListSubCell" forIndexPath:indexPath];
        [(WXMailListSubCell *)cell setTitle:self.subTitleArray[indexPath.row - 1]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section > self.pageModel.data.email.count - 1){
        if (indexPath.section == _count){
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WXChooseMailTypeTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"chooseMailTypeVC"];
            [self.navigationController pushViewController:vc animated:true];
        }else{
            //删除邮箱
        }
        return;
    }
    //点击subCell
    if (indexPath.row > 0){
        if (indexPath.row == 1){
            //收件箱
            WXInboxViewController *inboxVC = [[WXInboxViewController alloc] init];
            MailHomePageAccountModel *accountModel = self.pageModel.data.email[indexPath.row - 1].accountMail;
            inboxVC.account = accountModel.account;
            NSString *temp = [accountModel.account componentsSeparatedByString:@"@"].lastObject;
            NSString *type = [temp componentsSeparatedByString:@"."].firstObject;
            inboxVC.type = type;
            inboxVC.ID = [NSString stringWithFormat:@"%d",indexPath.row];
            [self.navigationController pushViewController:inboxVC animated:YES];
        }
        return;
    }
    //点击section
    if (indexPath.section == _openIndex){
        _openIndex = -1;
    }else{
        _openIndex = indexPath.section;
    }
    [tableView reloadData];
}

@end
