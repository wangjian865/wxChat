//
//  WXUsersListViewController.m
//  WXChat
//
//  Created by WDX on 2019/5/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXUsersListViewController.h"
#import "UIImage+ColorImage.h"
#import "WXUsersListCell.h"
#import "WXChatViewController.h"
@interface WXUsersListViewController ()<EMUserListViewControllerDelegate,EMUserListViewControllerDataSource,UISearchControllerDelegate>
/**
 * 搜索框
 */
@property (nonatomic, strong) UISearchController *serachController;
@property (nonatomic, strong) NSMutableArray *contactArr;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

/**
 * 编辑模式下存储选中的数据模型
 */
@property (nonatomic, strong) NSMutableArray *selectedModelArray;

///回去后台的用户列表数据,用以匹配头像和名字
@property (nonatomic, strong) NSArray<FriendModel *> *myList;
@end

@implementation WXUsersListViewController
#pragma mark -- getter
- (UISearchController *)serachController{
    if (_serachController == nil){
//        UIViewController *resultVC = [[UIViewController alloc] init];
//        resultVC.view.backgroundColor = UIColor.redColor;
//        _serachController = [[UISearchController alloc] initWithSearchResultsController:resultVC];
        _serachController = [[UISearchController alloc] init];
        self.definesPresentationContext = YES;
        _serachController.view.backgroundColor = UIColor.whiteColor;
        _serachController.searchBar.placeholder = @"搜索";
        // 默认为YES,设置开始搜索时背景显示与否
        _serachController.dimsBackgroundDuringPresentation = YES;
        // 默认为YES,控制搜索时，是否隐藏导航栏
        _serachController.hidesNavigationBarDuringPresentation = YES;
        _serachController.delegate = self;
        UISearchBar *bar = _serachController.searchBar;
        bar.barStyle = UISearchBarStyleDefault;
        [bar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        //输入框背景色
        for(UIView *subview in bar.subviews[0].subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
            {
                subview.backgroundColor = rgb(237,237,239);
                break;
            }
        }
    }
    return _serachController;
}
- (NSMutableArray *)selectedModelArray{
    if (_selectedModelArray == nil){
        _selectedModelArray = [NSMutableArray array];
    }
    return _selectedModelArray;
}
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload{
    //处理数据
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _sortDataArray:self.dataArray];
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.showRefreshHeader = YES;
    
    _sectionTitles = [NSMutableArray array];
    _contactArr = [NSMutableArray array];
    [self _getMyFriendsListRequest];
    self.dataSource = self;
    self.delegate = self;
    [self.tableView setTableHeaderView:self.serachController.searchBar];
    self.tableView.rowHeight = 48;
    if (_isEditing){//选取模式下才有
        [self _setNaviBar];
    }
    
}
//从我们后台获取
- (void)_getMyFriendsListRequest{
    [MineViewModel getFriendListWithNickName:@"" success:^(NSArray<FriendModel *> * list) {
        self.myList = list;
//        for (<#type *object#> in self.contactArr) {
//            <#statements#>
//        }
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
    }];
}
- (void)_setNaviBar{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"close_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    if (self.isInfoCard){return;}
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.size = CGSizeMake(52, 28);
    completeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    completeButton.backgroundColor = rgb(48, 134, 191);
    [completeButton setTitle:@"确认" forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completeButton];
    self.title = @"选择好友";
}
- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)doneAction
{
    if (_isGroup){
        [MineViewModel createChatGroupWithUserIds:self.selectedModelArray success:^(NSString * model) {
            NSLog(@"1");
            //成功了
            EMGroup *group = [EMGroup groupWithId:model];
            WS(wSelf);
            [self dismissViewControllerAnimated:YES completion:^{
                __strong typeof(wSelf) sSelf = wSelf;
                if (sSelf.doneCompletion){
                    sSelf.doneCompletion(group);
                }
            }];
        } failure:^(NSError * error) {
            
        }];
//        EMError *error = nil;
//        EMGroupOptions *setting = [[EMGroupOptions alloc] init];
//        setting.maxUsersCount = 500;
//        setting.IsInviteNeedConfirm = NO; //邀请群成员时，是否需要发送邀请通知.若NO，被邀请的人自动加入群组
//        setting.style = EMGroupStylePublicOpenJoin;// 创建不同类型的群组，这里需要才传入不同的类型
//        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:@"群组" description:@"群组描述" invitees:self.selectedModelArray message:@"邀请您加入群组" setting:setting error:&error];
//        if(!error){
//            NSLog(@"创建成功 -- %@",group);
//            WS(wSelf);
//            [self dismissViewControllerAnimated:YES completion:^{
//                __strong typeof(wSelf) sSelf = wSelf;
//                if (sSelf.doneCompletion){
//                    sSelf.doneCompletion(group);
//                }
//            }];
//        }else{
//            [self showHint:@"创建失败"];
//        }
    }else{
        WS(wSelf);
        [self dismissViewControllerAnimated:YES completion:^{
            __strong typeof(wSelf) sSelf = wSelf;
            if (sSelf.chooseCompletion){
                sSelf.chooseCompletion(sSelf.selectedModelArray);
            }
        }];

        
        
    }
    
}
#pragma mark -- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.contactArr == nil){
        return 0;
    }else{
       return self.contactArr.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.contactArr[section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [WXUsersListCell cellIdentifierWithModel:nil];
    WXUsersListCell *cell = (WXUsersListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[WXUsersListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    id<IUserModel> model = self.contactArr[indexPath.section][indexPath.row];
    if (_hasIDs && [_hasIDs containsObject:model.buddy]){
        cell.showCoverView = YES;
    }
    if (model) {
        cell.model = model;
    }
    cell.CellSelected = [self.selectedModelArray containsObject:model];
    cell.isEditing = self.isEditing && !(self.isInfoCard);
    WS(weakSelf);
    cell.chooseAction = ^(NSString *buddy) {
        if ([weakSelf.selectedModelArray containsObject:buddy]){
            [weakSelf.selectedModelArray removeObject:buddy];
        }else{
            [weakSelf.selectedModelArray addObject:buddy];
        }
    };
    return cell;
}
- (NSArray *)sectionTitlesAtIndexes:(NSIndexSet *)indexes{
    return self.sectionTitles;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = rgb(48, 134, 191);
    label.font = [UIFont systemFontOfSize:13];
    label.left = 14;
    label.top = 0;
    label.height = 31;
    label.width = 200;
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(section)]];
    [contentView addSubview:label];
    //底部线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 30, k_screen_width, 1)];
    line.backgroundColor = rgb(224, 224, 224);
    [contentView addSubview:line];
    return contentView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}
// delegate
//- (void)userListViewController:(EaseUsersListViewController *)userListViewController
//            didSelectUserModel:(id<IUserModel>)userModel{
//    
//}
// dataSource
//- (NSInteger)numberOfRowInUserListViewController:(EaseUsersListViewController *)userListViewController;{
//    return 2;
//}
//- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
//                   userModelForIndexPath:(NSIndexPath *)indexPath{
//
//}
//根据buddy,即id  从后台获取相关信息
- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                           modelForBuddy:(NSString *)buddy
{
    //用户可以根据自己的用户体系，根据buddy设置用户昵称和头像
    id<IUserModel> model = nil;
    model = [[EaseUserModel alloc] initWithBuddy:buddy];
    if (_myList){
        NSArray *tempList = [_myList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tgusetid = %@",model.buddy]];
        FriendModel *temp = tempList.firstObject;
        model.avatarURLPath = temp.tgusetimg;
        model.nickname = temp.tgusetname;
    }
    return model;
}

#pragma mark -- SerachController Delegate
- (void)willPresentSearchController:(UISearchController *)searchController{
    
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    NSLog(@"didPresentSearchController");
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    NSLog(@"didDismissSearchController");
}

// Called after the search controller's search bar has agreed to begin editing or when 'active' is set to YES. If you choose not to present the controller yourself or do not implement this method, a default presentation is performed on your behalf.
- (void)presentSearchController:(UISearchController *)searchController{
    NSLog(@"presentSearchController");
}

#pragma mark - private data

- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.sectionTitles removeAllObjects];
    [self.contactArr removeAllObjects];
    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    NSInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //按首字母分组
    for (EaseUserModel *model in buddyList) {
        if (model) {
//            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            
            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString: model.nickname];
            if (!firstLetter){
                firstLetter = @"xxx";
            }
            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            
            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [array addObject:model];
        }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.nickname];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.nickname];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    
    [self.contactArr addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
}

//- (void)userListViewController:(EaseUsersListViewController *)userListViewController didSelectUserModel:(id<IUserModel>)userModel {
//    if (_isInfoCard && self.cardCallBack != nil){
//        self.cardCallBack(userModel.buddy);
//        [self dismissViewControllerAnimated:true completion:nil];
//    }
//    //不跳转
////    WXChatViewController *viewController = [[WXChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
////    viewController.title = userModel.nickname;
////    [self.navigationController pushViewController:viewController animated:YES];
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    id<IUserModel> model = self.contactArr[indexPath.section][indexPath.row];
    if (_isInfoCard && self.cardCallBack != nil){
        self.cardCallBack(model.buddy);
        [self dismissViewControllerAnimated:true completion:nil];
    }
    
}
/*
 *
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
 id<IUserModel> model = nil;
 if (_dataSource && [_dataSource respondsToSelector:@selector(userListViewController:userModelForIndexPath:)]) {
 model = [_dataSource userListViewController:self userModelForIndexPath:indexPath];
 }
 else {
 model = [self.dataArray objectAtIndex:indexPath.row];
 }
 
 if (model) {
 if (_delegate && [_delegate respondsToSelector:@selector(userListViewController:didSelectUserModel:)]) {
 [_delegate userListViewController:self didSelectUserModel:model];
 } else {
 EaseMessageViewController *viewController = [[EaseMessageViewController alloc] initWithConversationChatter:model.buddy conversationType:EMConversationTypeChat];
 viewController.title = model.nickname;
 [self.navigationController pushViewController:viewController animated:YES];
 }
 }}
 */
@end
