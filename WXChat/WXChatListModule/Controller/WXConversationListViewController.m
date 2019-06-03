//
//  WXConversationListViewController.m
//  WXChat
//
//  Created by WDX on 2019/4/28.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXConversationListViewController.h"
#import "NSDate+Category.h"
#import "WXChatViewController.h"
#import "YCMenuView.h"
#import "EMInviteGroupMemberViewController.h"
#import "WXPresentNavigationController.h"
#import "WXUsersListViewController.h"
#import "UIImage+ColorImage.h"
@interface WXConversationListViewController ()<EaseConversationListViewControllerDataSource,EaseConversationListViewControllerDelegate>
/**
 * 用户数据模型,从自身数据库获取
 */
@property (nonatomic, strong) NSArray *imageAndNameArray;
@property (nonatomic, strong) YCMenuView *menuView;
@property (nonatomic) BOOL isViewAppear;
@property (nonatomic) BOOL isNeedReload;
@property (nonatomic) BOOL isNeedReloadSorted;
/**
 * 搜索框
 */
@property (nonatomic, strong) UISearchController *serachController;
@end

@implementation WXConversationListViewController

#pragma mark -- getter
- (UISearchController *)serachController{
    if (_serachController == nil){
        UIViewController *resultVC = [[UIViewController alloc] init];
        resultVC.view.backgroundColor = UIColor.redColor;
        _serachController = [[UISearchController alloc] initWithSearchResultsController:resultVC];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self tableViewDidTriggerHeaderRefresh];
    _isViewAppear = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isViewAppear = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    [self setupNavi];
    [self.tableView setTableHeaderView:self.serachController.searchBar];
}
- (void)setupNavi{
    UIImage *image = [UIImage imageNamed:@"pop_add"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarBtn:)];
}
- (void)clickRightBarBtn: (UIButton *)sender{
    WS(weaklf);
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"发起聊天" image:[UIImage imageNamed:@"pop_groupChat"] handler:^(YCMenuAction *action) {
        EMInviteGroupMemberViewController *inviteGroupVC = [[EMInviteGroupMemberViewController alloc] init];
        WXPresentNavigationController *nav = [[WXPresentNavigationController alloc] initWithRootViewController:inviteGroupVC];
        [weaklf presentViewController:nav animated:YES completion:nil];
    }];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"添加好友" image:[UIImage imageNamed:@"pop_addFriend"] handler:^(YCMenuAction *action) {
        
    }];
    YCMenuAction *action3 = [YCMenuAction actionWithTitle:@"加入公司" image:[UIImage imageNamed:@"pop_company"] handler:^(YCMenuAction *action) {
        
    }];
    YCMenuAction *action4 = [YCMenuAction actionWithTitle:@"扫一扫" image:[UIImage imageNamed:@"pop_scan"] handler:^(YCMenuAction *action) {
        
    }];
    NSArray *arr = @[action1,action2,action3,action4];
    YCMenuView *view = [YCMenuView menuWithActions:arr width:140 relyonView:sender];
    view.textFont = [UIFont systemFontOfSize:14];
    view.textColor = UIColor.whiteColor;
    view.maxDisplayCount = 7;
    [view show];
    self.menuView = view;
}
//处理用户数据的代理
- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation{
    //用环信提供的model就可以了
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    //然后根据用户名  往上面赋值
    //self.imageAndNameArray为自定义的数组，其中存储的是从自己服务器上请求下来的数据
    //可用自己的服务器存储某些信息
    return model;
}
- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel{
        NSString *latestMessageTime = @"";
        EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
        if (lastMessage) {
            latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
        }
        return latestMessageTime;
}
//点击进入会话页面的代理
//自定义会话页面需要
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController didSelectConversationModel:(id<IConversationModel>)conversationModel{
    EaseConversationModel *model = (EaseConversationModel *)conversationModel;
    //自定义点击cell推出的viewcontroller
    WXChatViewController *viewController = [[WXChatViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type];
    viewController.title = model.title;
    [self.navigationController pushViewController:viewController animated:YES];

}
#pragma mark - EMChatManagerDelegate

- (void)conversationListDidUpdate:(NSArray *)aConversationList
{
    if (!self.isViewAppear) {
        self.isNeedReloadSorted = YES;
    } else {
//        [self refreshAndSortView];
        [self tableViewDidTriggerHeaderRefresh];
    }
}

- (void)messagesDidReceive:(NSArray *)aMessages
{
    if (self.isViewAppear) {
        if (!self.isNeedReload) {
            self.isNeedReload = YES;
            [self performSelector:@selector(_reSortedConversationModelsAndReloadView) withObject:nil afterDelay:0.8];
        }
    } else {
        self.isNeedReload = YES;
    }
}
- (void)_reSortedConversationModelsAndReloadView
{
    NSArray *sorted = [self.dataArray sortedArrayUsingComparator:^(EaseConversationModel *obj1, EaseConversationModel *obj2) {
        EMMessage *message1 = [obj1.conversation latestMessage];
        EMMessage *message2 = [obj2.conversation latestMessage];
        if(message1.timestamp > message2.timestamp) {
            return(NSComparisonResult)NSOrderedAscending;
        } else {
            return(NSComparisonResult)NSOrderedDescending;
        }}];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:sorted];
    [self.tableView reloadData];
    
    self.isNeedReload = NO;
}
#pragma mark - selectIndexPathDelegate
- (void)selectIndexPathRow:(NSInteger)index {
    NSLog(@"%ld",index);
}

@end
