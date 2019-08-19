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
#import "HomePageSearchModel.h"
#import "WXChatViewController.h"
@interface WXSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 * 搜索结果展示按钮
 */
@property (nonatomic, strong) UITableView *resultView;
/**
 * 模型
 */
@property (nonatomic, strong) HomePageSearchModel *myModel;
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
    return 2;
//    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_myModel){
        return 0;
    }
    if (section == 0 && _myModel.seanceshows.count > 0){
//        if (_myModel.seanceshows.count > 3){
//            return 4;
//        }
        return _myModel.seanceshows.count;
    }else if (section == 1 && _myModel.friends.count > 0){
//        if (_myModel.friends.count > 3){
//            return 4;
//        }
        return _myModel.friends.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
//        if (indexPath.row <= _myModel.seanceshows.count - 1){
            GroupModel *model = _myModel.seanceshows[indexPath.row];
            WXResultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
            [cell setGroupModel:model];
            return cell;
//        }else{
//            WXResultBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchBottomCell"];
//            return cell;
//        }
    }else{
//        if (indexPath.row <= _myModel.friends.count - 1){
            WXResultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
            UserInfoModel *userModel = _myModel.friends[indexPath.row];
            [cell setUserModel:userModel];
            return cell;
//        }else{
//            WXResultBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchBottomCell"];
//            return cell;
//        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && _myModel.seanceshows.count > 0){
        return 36;
    }else if (section == 1 && _myModel.friends.count > 0){
        return 36;
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && _myModel.seanceshows.count > 0){
        if (indexPath.row <= _myModel.seanceshows.count - 1){
            return 66;
        }
    }else if (indexPath.section == 1 && _myModel.friends.count > 0){
        if (indexPath.row <= _myModel.friends.count - 1){
            return 66;
        }
    }
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WXResultSectionHeaderView *headerView = [[WXResultSectionHeaderView alloc] init];
    if (section == 0 && _myModel.seanceshows.count > 0){
        headerView.titleLabel.text = @"群聊";
        return headerView;
    }else if (section == 1 && _myModel.friends.count > 0){
        headerView.titleLabel.text = @"联系人";
        return headerView;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        if (indexPath.row <= _myModel.seanceshows.count - 1){
            
            GroupModel *model = _myModel.seanceshows[indexPath.row];
            WXChatViewController *viewController = [[WXChatViewController alloc] initWithConversationChatter:model.seanceshowid conversationType:EMConversationTypeGroupChat];
            viewController.title = model.seanceshowname;
            [self.parents.navigationController pushViewController:viewController animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row <= _myModel.friends.count - 1){
            UserInfoModel *model = _myModel.friends[indexPath.row];
            WXChatViewController *viewController = [[WXChatViewController alloc] initWithConversationChatter:model.tgusetid conversationType:EMConversationTypeChat];
            viewController.title = model.tgusetname;
            [self.parents.navigationController pushViewController:viewController animated:YES];
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchBar endEditing:YES];
}
#pragma mark - UISearchResultsUpdating
//每输入一个字符都会执行一次
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    self.searchDefaultView.hidden = !(self.searchBarTextField.text.length == 0);
    [MineViewModel homePageSearchRequestWithKeyword:self.searchBarTextField.text success:^(HomePageSearchModel * model) {
        self.myModel = model;
        [self.resultView reloadData];
    } failure:^(NSError * error) {
        
    }];
}
@end
