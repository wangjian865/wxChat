//
//  WDXUserListViewController.m
//  WXChat
//
//  Created by WX on 2019/8/4.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WDXUserListViewController.h"
#import "WDXUsersListCell.h"
#import "SearchUserModel.h"
NSString *cellID = @"userCellID";
@interface WDXUserListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
///排序后的数据源
@property (nonatomic, strong)NSMutableArray *sortedUsers;
///对应的组头数组
@property (nonatomic, strong)NSMutableArray *sectionTitles;
///选中的数据
@property (nonatomic, strong)NSMutableArray *selectArr;
@end

@implementation WDXUserListViewController
- (NSMutableArray *)sortedUsers{
    if (!_sortedUsers){
        _sortedUsers = [NSMutableArray array];
    }
    return _sortedUsers;
}
- (NSMutableArray *)sectionTitles{
    if (!_sectionTitles){
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}
- (NSMutableArray *)selectArr{
    if (!_selectArr){
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}
- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[WDXUsersListCell class] forCellReuseIdentifier:cellID];
        _tableView.rowHeight = 48;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.title = @"选择联系人";
    [self setNaviBar];
    [self _sortDataArray];
}
///设置导航栏按钮
- (void)setNaviBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"close_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_isSingle){return;}
    completeButton.size = CGSizeMake(52, 28);
    completeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    completeButton.backgroundColor = rgb(48, 134, 191);
    [completeButton setTitle:_rightTitle forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completeButton];
}
///navi事件
- (void)doneAction {
    ///传出选中值
    if (_chooseCompletion){
        _chooseCompletion(_selectArr);
    }
    [self closeAction];
}
- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
///排序  将传进来的用户数组进行排序
- (void)_sortDataArray
{
    [self.sortedUsers removeAllObjects];
    [self.sectionTitles removeAllObjects];
    
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
    ///如果数组中存在本人先将本人排除
    NSString *mineID = [WXAccountTool getUserID];
    _users = [_users filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tgusetId != %@",mineID]];
    for (SearchUserModel *model in _users) {
        if (model) {
            //            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            
            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString: model.tgusetName];
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
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(SearchUserModel *obj1, SearchUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.tgusetName];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.tgusetName];
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
    
    [self.sortedUsers addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
}
///布局
- (void)viewDidLayoutSubviews{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_sortedUsers){
        return _sortedUsers.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_sortedUsers){
        NSArray *array = _sortedUsers[section];
        return array.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WDXUsersListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    WS(weakSelf);
    cell.chooseAction = ^(NSString *buddy) {
        if ([weakSelf.selectArr containsObject:buddy]){
            [weakSelf.selectArr removeObject:buddy];
        }else{
            [weakSelf.selectArr addObject:buddy];
        }
    };
    NSArray *temp = _sortedUsers[indexPath.section];
    
    SearchUserModel *model = temp[indexPath.row];
    
    cell.coverView.hidden = ![_selectedIDS containsObject:model.tgusetId];
    cell.selectButton.hidden = self.isSingle;
    cell.wxModel = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSingle){
        NSArray *temp = _sortedUsers[indexPath.section];
        SearchUserModel *model = temp[indexPath.row];
        if (_chooseCompletion){
            _chooseCompletion(@[model.tgusetId]);
        }
        [self closeAction];
    }
}
//索引
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
@end
