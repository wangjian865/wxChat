//
//  EMInviteGroupMemberViewController.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2019/1/17.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EMInviteGroupMemberViewController.h"

#import "EMAvatarNameCell.h"

@interface EMInviteGroupMemberViewController ()

@property (nonatomic, strong) NSArray *blocks;

@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) UILabel *selectedLabel;

@end

@implementation EMInviteGroupMemberViewController

- (instancetype)initWithBlocks:(NSArray *)aBlocks
{
    self = [super init];
    if (self) {
        _blocks = aBlocks;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectedArray = [[NSMutableArray alloc] init];
    
    [self _setupSubviews];
    [self _fetchContactsWithIsShowHUD:YES];
    self.showRefreshFooter = NO;
    self.showRefreshHeader = NO;
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    }
    
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_white"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar.layer setMasksToBounds:YES];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"close_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.size = CGSizeMake(52, 28);
    completeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    completeButton.backgroundColor = rgb(48, 134, 191);
    [completeButton setTitle:@"转让" forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completeButton];
    self.title = @"选择好友";
    
    self.view.backgroundColor = kColor_LightGray;
    self.tableView.backgroundColor = kColor_LightGray;
    self.showRefreshHeader = YES;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(80));
    }];
    
    self.selectedLabel = [[UILabel alloc] init];
    self.selectedLabel.font = [UIFont systemFontOfSize:17];
    self.selectedLabel.textColor = [UIColor blackColor];
    self.selectedLabel.numberOfLines = 2;
    self.selectedLabel.text = @"已选择 ( 0 )";
    [bottomView addSubview:self.selectedLabel];
    [self.selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(10);
        make.left.equalTo(bottomView).offset(10);
        make.right.equalTo(bottomView).offset(-10);
        make.bottom.lessThanOrEqualTo(bottomView).offset(-10);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (tableView == self.tableView) {
//
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger count = 0;
    if (tableView == self.tableView) {
        count = [self.dataArray count];
    } else {
        count = [self.searchResults count];
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EMAvatarNameCell";
    EMAvatarNameCell *cell = (EMAvatarNameCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EMAvatarNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
        checkButton.tag = 100;
        [checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [checkButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        checkButton.userInteractionEnabled = NO;
        cell.accessoryView = checkButton;
    }
    
//    [cell.avatarView sd_setImageWithURL:[NSURL URLWithString:]]
    UIButton *checkButton = (UIButton *)cell.accessoryView;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMAvatarNameCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *checkButton = (UIButton *)cell.accessoryView;
    self.selectedLabel.text = [NSString stringWithFormat:@"已选择 ( %@ )", @([self.selectedArray count])];
}

#pragma mark - EMSearchBarDelegate

- (void)searchBarCancelButtonAction:(EMSearchBar *)searchBar
{
    [super searchBarCancelButtonAction:searchBar];
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(NSString *)aString
{
    [self.view endEditing:YES];
}

- (void)searchTextDidChangeWithString:(NSString *)aString
{
    if (!self.isSearching) {
        return;
    }
    
    __weak typeof(self) weakself = self;
    [[EMRealtimeSearch shared] realtimeSearchWithSource:self.dataArray searchText:aString collationStringSelector:nil resultBlock:^(NSArray *results) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.searchResults removeAllObjects];
            [weakself.searchResults addObjectsFromArray:results];
            [weakself.searchResultTableView reloadData];
        });
    }];
}

#pragma mark - Data

- (void)_fetchContactsWithIsShowHUD:(BOOL)aIsShowHUD
{
    //逻辑补充
    //1.去掉黑名单用户
    //2.通过id获取用户详细数据(头像昵称等)
    [self showHudInView:self.view hint:@"获取联系人..."];
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        [weakself hideHud];
        if (!aError) {
            if ([weakself.blocks count] > 0) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSString *user in aList) {
                    if (![weakself.blocks containsObject:user]) {
                        [array addObject:user];
                    }
                }
                [weakself.dataArray addObjectsFromArray:array];
            } else {
                [weakself.dataArray addObjectsFromArray:aList];
            }
            
            [weakself.tableView reloadData];
        }
    }];
}

- (void)tableViewDidTriggerHeaderRefresh
{
    
}

#pragma mark - Action

- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction
{
    if (_doneCompletion) {
        _doneCompletion(self.selectedArray);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Network

@end
