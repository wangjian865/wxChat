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
#import "XTPopView.h"
@interface WXConversationListViewController ()<EaseConversationListViewControllerDataSource,EaseConversationListViewControllerDelegate,selectIndexPathDelegate>
/**
 * 用户数据模型,从自身数据库获取
 */
@property (nonatomic, strong) NSArray *imageAndNameArray;

@property (nonatomic) BOOL isViewAppear;
@property (nonatomic) BOOL isNeedReload;
@property (nonatomic) BOOL isNeedReloadSorted;
@end

@implementation WXConversationListViewController
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
}
- (void)setupNavi{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"add" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarBtn)];
}
- (void)clickRightBarBtn{
    CGPoint point = CGPointMake(k_screen_width-25, k_top_height+2);
    XTPopView *myView = [[XTPopView alloc] initWithOrigin:point Width:k_current_Width(100) Height:k_current_Height(40)*4 Type:XTTypeOfUpRight Color:[UIColor whiteColor]];
    myView.dataArray = @[@"创建群组",@"新建会议",@"添加联系人",@"扫一扫"];
    myView.images = @[@"message_group",@"message_meeting",@"message_contack",@"message_scan"];
    myView.fontSize = k_current_Width(14);
    myView.row_height = k_current_Width(40);
    myView.titleTextColor = UIColor.blackColor;
    myView.delegate = self;
    [myView popView];
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
