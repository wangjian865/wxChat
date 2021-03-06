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
#import "WXChatListTableViewCell.h"
#import "WXUsersListViewController.h"
#import "WXSearchResultViewController.h"
#import "WXAddFriendViewController.h"
#import "WXChatListHeaderCell.h"
#import "WXMessageAlertViewController.h"
#import "WXScanViewController.h"
#import "WXAccountTool.h"
#import "WXAddCompanyViewController.h"
#import "GroupModel.h"
#import "FriendModel.h"
#import "WXSearchNormalView.h"
@interface WXConversationListViewController ()<EaseConversationListViewControllerDataSource,EaseConversationListViewControllerDelegate,UISearchControllerDelegate,UISearchBarDelegate,EMContactManagerDelegate>
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
///搜索页面的推荐视图
@property (nonatomic, strong) WXSearchNormalView *searchNormalView;
///好友列表数据
@property (nonatomic, strong) NSArray<FriendModel *> *userListModel;
///群组列表数据
@property (nonatomic, strong) NSArray<GroupModel *> *groupListModel;
///顶部cell的数字
@property (nonatomic, assign) int topCount;
///顶部cell长持有
@property (nonatomic, strong) WXChatListHeaderCell *topCell;
@end

@implementation WXConversationListViewController

#pragma mark -- getter
- (UISearchController *)serachController{
    if (_serachController == nil){
        WXSearchResultViewController *resultVC = [[WXSearchResultViewController alloc] init];
        resultVC.parents = self;
        _serachController = [[UISearchController alloc] initWithSearchResultsController:resultVC];
        self.definesPresentationContext = YES;
        _serachController.view.backgroundColor = UIColor.whiteColor;
        _serachController.searchBar.placeholder = @"搜索";
        // 默认为YES,设置开始搜索时背景显示与否
        _serachController.dimsBackgroundDuringPresentation = NO;
        // 默认为YES,控制搜索时，是否隐藏导航栏
        _serachController.hidesNavigationBarDuringPresentation = YES;
        _serachController.delegate = self;
        _serachController.searchResultsUpdater = resultVC;
        //searchController.view添加提示试图
        WXSearchNormalView *normalView = [[NSBundle mainBundle] loadNibNamed:@"WXSearchNormalView" owner:nil options:nil].lastObject;
        _searchNormalView = normalView;
        resultVC.searchDefaultView = normalView;
        normalView.frame = CGRectMake(0, 100, k_screen_width, 1000);
        [_serachController.view addSubview:normalView];
        UISearchBar *bar = _serachController.searchBar;
        bar.delegate = self;
        resultVC.searchBar = bar;
        bar.barStyle = UISearchBarStyleDefault;
        [bar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        //输入框背景色
        for(UIView *subview in bar.subviews[0].subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
            {
                subview.backgroundColor = rgb(237,237,239);
                resultVC.searchBarTextField = (UITextField *)subview;
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
    [self getUserList];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isViewAppear = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    [self setupNavi];
    [self.tableView setTableHeaderView:self.serachController.searchBar];
    ///添加好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}
///好友回调
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage{
    ///此处收到好友申请  WDX
}
///获取顶部cell的展示数字
- (void)getTopCellCount{
    [MineViewModel getApprovalListWithUserID:[WXAccountTool getUserID] success:^(NSArray<ApprovalModel *> * data) {
        self.topCount = data.count;
        if (self.topCell){
            [self.topCell setBadge:data.count];
        }
    } failure:^(NSError * error) {
        
    }];
}
- (void)getUserList{
    [MineViewModel getFriendListWithNickName:@"" success:^(NSArray<FriendModel *> * list) {
        self.userListModel = list;
        [self tableViewDidTriggerHeaderRefresh];
    } failure:^(NSError * error) {
        
    }];
    [MineViewModel getChatGroupListWithSuccess:^(GroupListModel * groupList) {
        self.groupListModel = groupList.data;
        [self tableViewDidTriggerHeaderRefresh];
    } failure:^(NSError * error) {
        
    }];
}
- (void)setupNavi{
    UIImage *image = [UIImage imageNamed:@"pop_add"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarBtn:)];
}
//popMenu
- (void)clickRightBarBtn: (UIButton *)sender{
    WS(weaklf);
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"发起聊天" image:[UIImage imageNamed:@"pop_groupChat"] handler:^(YCMenuAction *action) {
        WXUsersListViewController *userListVC = [[WXUsersListViewController alloc] init];
        userListVC.doneCompletion = ^(EMGroup * _Nonnull group) {
            //跳转会话页面
            WXChatViewController *viewController = [[WXChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
            viewController.title = group.subject;
            [weaklf.navigationController pushViewController:viewController animated:YES];
        };
        userListVC.isEditing = YES;
        userListVC.isGroup = YES;
        WXPresentNavigationController *nav = [[WXPresentNavigationController alloc] initWithRootViewController:userListVC];
        [weaklf presentViewController:nav animated:YES completion:nil];
    }];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"添加好友" image:[UIImage imageNamed:@"pop_addFriend"] handler:^(YCMenuAction *action) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
        UIViewController *newAddVC = [sb instantiateViewControllerWithIdentifier:@"newAddFriendVC"];
//        WXAddFriendViewController *addVC = [[WXAddFriendViewController alloc] init];
//        addVC.type = WXAddVCTypeFriend;
        [weaklf.navigationController pushViewController:newAddVC animated:YES];
    }];
    YCMenuAction *action3 = [YCMenuAction actionWithTitle:@"加入公司" image:[UIImage imageNamed:@"pop_company"] handler:^(YCMenuAction *action) {
        WXAddCompanyViewController *addCompanyVC = [[WXAddCompanyViewController alloc] init];
        [weaklf.navigationController pushViewController:addCompanyVC animated:YES];
    }];
    YCMenuAction *action4 = [YCMenuAction actionWithTitle:@"扫一扫" image:[UIImage imageNamed:@"pop_scan"] handler:^(YCMenuAction *action) {
        WXScanViewController *scanVC = [[WXScanViewController alloc] init];
        [weaklf.navigationController pushViewController:scanVC animated:YES];
    }];
    NSArray *arr = @[action1,action2,action3,action4];
    YCMenuView *view = [YCMenuView menuWithActions:arr width:140 relyonView:sender];
    view.textFont = [UIFont systemFontOfSize:14];
    view.textColor = UIColor.whiteColor;
    view.maxDisplayCount = 7;
    [view show];
    self.menuView = view;
}
#pragma mark - 是否存在新的消息提醒
- (BOOL)existMessageAlert{
    
    return YES;
}
#pragma mark - 自定义列表cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //补充逻辑是否存在新的消息提醒
    NSInteger count = self.dataArray.count;
    if ([self existMessageAlert]){
        count += 1;
    }
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && [self existMessageAlert]){
        //我来组成头部
//        NSString *CellIdentifier = [WXChatListHeaderCell cellIdentifierWithModel:nil];
        NSString *CellIdentifier = @"topCell";
        WXChatListHeaderCell *cell = (WXChatListHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[WXChatListHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.avatarView.image = [UIImage imageNamed:@"message_alert"];
        cell.titleLabel.text = @"系统消息";
        
        _topCell = cell;
        if (_topCount){
            [cell setBadge:_topCount];
        }
        return cell;
    }

//    NSString *CellIdentifier = [WXChatListTableViewCell cellIdentifierWithModel:nil];
    NSString *CellIdentifier = @"normalCell";
    WXChatListTableViewCell *cell = (WXChatListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[WXChatListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if ([self.dataArray count] <= indexPath.row - 1) {
        return cell;
    }

    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row - 1];
    cell.model = model;

    cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:cell.detailLabel.font];

    cell.timeLabel.text = [self conversationListViewController:self latestMessageTimeForConversationModel:model];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        //跳转到消息通知页面
        [self.navigationController pushViewController:[[WXMessageAlertViewController alloc]init] animated:YES];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row - 1];
    [self conversationListViewController:self didSelectConversationModel:model];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return false;
    }
    return true;
}
- (void)deleteCellAction:(NSIndexPath *)aIndexPath
{
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:aIndexPath.row-1 inSection:aIndexPath.section];
    EaseConversationModel *model = [self.dataArray objectAtIndex:currentIndexPath.row];
    [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:nil];
    [self.dataArray removeObjectAtIndex:currentIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:aIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}
/*!
 @method
 @brief 获取会话最近一条消息内容提示
 @discussion
 @param conversationModel  会话model
 @result 返回传入会话model最近一条消息提示
 */
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = @"[音频]";
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = @"[位置]";
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = @"[视频]";
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = @"[文件]";
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}
//处理用户数据的代理
- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation{
    //用环信提供的model就可以了
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    //然后根据用户名  往上面赋值
    if (conversation.type == EMConversationTypeGroupChat){
        //群聊
        NSArray *temp = [self.groupListModel filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"seanceshowid = %@",model.conversation.conversationId]];
        if (temp.count > 0){
            model.title = ((GroupModel *)temp[0]).seanceshowname;
            //还有头像
        }
        
    }else{
//        NSDictionary *dict = conversation.lastReceivedMessage.ext;
//        if(dict[@"from_name_user"] == nil || dict[@"from_heading_user"] == nil){
//            NSDictionary *localDict = [WXAccountTool findUserInfoByUserId:conversation.conversationId];
//            model.title = [localDict objectForKey:@"from_name_user"];
//            model.avatarURLPath = [localDict objectForKey:@"from_heading_user"];
//        }
        //单聊
        NSArray *temp = [self.userListModel filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tgusetid = %@",model.conversation.conversationId]];
        if (temp.count > 0){
            model.title = ((FriendModel *)temp[0]).tgusetname;
            model.avatarURLPath = ((FriendModel *)temp[0]).tgusetimg;
        }
    }
//    model.title = @"测试标题";
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
        [self tableViewDidTriggerHeaderRefresh];
    }
}
//收到透传消息删除相关群聊
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages
{
    EMMessage *message = aCmdMessages.firstObject;
    NSString *fromID = message.from;
    [WXChatService deleteAConversationWithId:fromID completion:nil];
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
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    for (id obj in [searchBar subviews]) {
        if ([obj isKindOfClass:[UIView class]]) {
            for (id obj2 in [obj subviews]) {
                if ([obj2 isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)obj2;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
        }
    }
    return YES;
}
#pragma mark - UISearchControllerDelegate代理
//测试UISearchController的执行过程
- (void)willPresentSearchController:(UISearchController *)searchController {
    NSLog(@"willPresentSearchController");
    _searchNormalView.hidden = false;
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"didPresentSearchController");
//    self.searchVC.dataListArry = self.dataListArry;
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    NSLog(@"willDismissSearchController");
    _searchNormalView.hidden = true;
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController {
    NSLog(@"presentSearchController");
}
@end
