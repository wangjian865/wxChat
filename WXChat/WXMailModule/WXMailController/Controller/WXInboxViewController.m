//
//  WXInboxViewController.m
//  MailDemo
//
//  Created by 王坚 on 2019/6/21.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXInboxViewController.h"
#import "WXMailCell.h"
@interface WXInboxViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 * list
 */
@property (nonatomic, strong) UITableView *mailListView;
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
}
- (void)viewDidLayoutSubviews{
    [self.mailListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark -- UITableViewDelegate && Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXMailCell" forIndexPath:indexPath];
    return cell;
}
@end
