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
@interface WXConversationListViewController ()<EaseConversationListViewControllerDataSource,EaseConversationListViewControllerDelegate,UISearchControllerDelegate>
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
        WXSearchResultViewController *resultVC = [[WXSearchResultViewController alloc] init];
//        resultVC.view.backgroundColor = UIColor.whiteColor;
        _serachController = [[UISearchController alloc] initWithSearchResultsController:resultVC];
        self.definesPresentationContext = YES;
        _serachController.view.backgroundColor = UIColor.whiteColor;
        _serachController.searchBar.placeholder = @"搜索";
        // 默认为YES,设置开始搜索时背景显示与否
        _serachController.dimsBackgroundDuringPresentation = YES;
        // 默认为YES,控制搜索时，是否隐藏导航栏
        _serachController.hidesNavigationBarDuringPresentation = YES;
        _serachController.delegate = self;
        //searchController.view添加提示试图
        UISearchBar *bar = _serachController.searchBar;
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
//popMenu
- (void)clickRightBarBtn: (UIButton *)sender{
    WS(weaklf);
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"发起聊天" image:[UIImage imageNamed:@"pop_groupChat"] handler:^(YCMenuAction *action) {
//        EMInviteGroupMemberViewController *inviteGroupVC = [[EMInviteGroupMemberViewController alloc] init];
//        WXPresentNavigationController *nav = [[WXPresentNavigationController alloc] initWithRootViewController:inviteGroupVC];
//        [weaklf presentViewController:nav animated:YES completion:nil];
        WXUsersListViewController *userListVC = [[WXUsersListViewController alloc] init];
        userListVC.doneCompletion = ^(EMGroup * _Nonnull group) {
            //跳转会话页面
            WXChatViewController *viewController = [[WXChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
            viewController.title = group.subject;
            [weaklf.navigationController pushViewController:viewController animated:YES];
        };
        userListVC.isEditing = YES;
        WXPresentNavigationController *nav = [[WXPresentNavigationController alloc] initWithRootViewController:userListVC];
        [weaklf presentViewController:nav animated:YES completion:nil];
    }];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"添加好友" image:[UIImage imageNamed:@"pop_addFriend"] handler:^(YCMenuAction *action) {
        WXAddFriendViewController *addVC = [[WXAddFriendViewController alloc] init];
        addVC.type = WXAddVCTypeFriend;
        [weaklf.navigationController pushViewController:addVC animated:YES];
    }];
    YCMenuAction *action3 = [YCMenuAction actionWithTitle:@"加入公司" image:[UIImage imageNamed:@"pop_company"] handler:^(YCMenuAction *action) {
        WXAddFriendViewController *addVC = [[WXAddFriendViewController alloc] init];
        addVC.type = WXAddVCType;
        [weaklf.navigationController pushViewController:addVC animated:YES];
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
        NSString *CellIdentifier = [WXChatListHeaderCell cellIdentifierWithModel:nil];
        WXChatListHeaderCell *cell = (WXChatListHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[WXChatListHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.avatarView.image = [UIImage imageNamed:@"message_alert"];
        cell.titleLabel.text = @"系统消息";
        return cell;
    }

    NSString *CellIdentifier = [WXChatListTableViewCell cellIdentifierWithModel:nil];
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
