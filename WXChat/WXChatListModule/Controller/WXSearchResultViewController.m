//
//  WXSearchResultViewController.m
//  WXChat
//
//  Created by WDX on 2019/6/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXSearchResultViewController.h"
#import "WXResultViewCell.h"
#import "WXResultSectionHeaderView.h"
#import "WXResultBottomCell.h"
@interface WXSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 * 搜索结果展示按钮
 */
@property (nonatomic, strong) UITableView *resultView;

@end

@implementation WXSearchResultViewController

- (UITableView *)resultView{
    if (_resultView == nil){
        _resultView = [[UITableView alloc] initWithFrame:CGRectMake(1, 1, 1, 1) style:UITableViewStyleGrouped];
        _resultView.delegate = self;
        _resultView.dataSource = self;
        [_resultView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_resultView registerClass:[WXResultViewCell class] forCellReuseIdentifier:@"searchResultCell"];
        [_resultView registerClass:[WXResultBottomCell class] forCellReuseIdentifier:@"searchBottomCell"];
    }
    return _resultView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.resultView];
}
- (void)endEditTap{
    [_searchBar endEditing:YES];
}
- (void)viewDidLayoutSubviews{
    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@-44);
    }];
}
#pragma mark -- UITableViewDelegate && Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= 2){
        WXResultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
        return cell;
    }else{
        WXResultBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchBottomCell"];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  36;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= 2){
        return 66;
    }
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[WXResultSectionHeaderView alloc] init];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld",indexPath.row);
    //可尝试更改resultView
    [UIView animateWithDuration:0.2 animations:^{
        self.searchBarTextField.left = self.searchBarTextField.left + 40;
        self.searchBarTextField.width = self.searchBarTextField.width - 40;
    }];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchBar endEditing:YES];
}

@end
