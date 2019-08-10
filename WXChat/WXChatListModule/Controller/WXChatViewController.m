//
//  WXChatViewController.m
//  WXChat
//
//  Created by WDX on 2019/4/28.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXChatViewController.h"
#import "WXPersonInfoCell.h"
#import "WXUserMomentInfoViewController.h"
#import "WXfriendResultViewController.h"
@interface WXChatViewController ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource,UIDocumentPickerDelegate,EMCallManagerDelegate>

@end

@implementation WXChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.view.backgroundColor = rgb(240, 240, 240);
    self.tableView.backgroundColor = rgb(240, 240, 240);
    self.dataSource = self;
    //设置聊天会话样式
    [self setChatAppearance];
    //添加文件传输按钮
    [self insetItemForChatBar];
    //设置导航栏右边按钮
    [self setNaviRightButton];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
}
//设置右边按钮
- (void)setNaviRightButton{
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"椭圆4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
}
- (void)rightBtnAction{
    if (self.conversation.type == EMConversationTypeGroupChat){
        //群聊模式
        WXGroupSettingViewController *vc = [[WXGroupSettingViewController alloc] init];
        vc.groupID = self.conversation.conversationId;
        [self.navigationController pushViewController:vc animated:true];
    }else{
        //单聊
        
    }
   
}
//设置聊天会话样式
- (void)setChatAppearance{
//    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];//设置发送气泡
    
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"蓝色对话框"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];//设置发送气泡
    
//    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];//设置接收气泡
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"白色对话框"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];//设置接收气泡
    [[EaseBaseMessageCell appearance] setBubbleMaxWidth: 500];
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];//设置头像大小
    
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:20.f];//设置头像圆角
    
    [[EaseMessageCell appearance] setMessageTextFont:[UIFont systemFontOfSize:15]];//消息显示字体
    
    [[EaseMessageCell appearance] setMessageTextColor:[UIColor blackColor]];//消息显示颜色
    
    [[EaseMessageCell appearance] setMessageLocationFont:[UIFont systemFontOfSize:12]];//位置消息显示字体
    
    [[EaseMessageCell appearance] setMessageLocationColor:[UIColor whiteColor]];//位置消息显示颜色
    
    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:@[[UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_full"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_000"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_001"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_002"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_003"]]];//发送者语音消息播放图片
    
    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:@[[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing_full"],[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing000"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing001"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing002"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing003"]]];//接收者语音消息播放图片
}
- (void)insetItemForChatBar {
    
    self.chatBarMoreView.moreViewBackgroundColor = rgb(240, 240, 240);
    [self.chatBarMoreView removeItematIndex:3];
    [self.chatBarMoreView removeItematIndex:3];
    [self.chatBarMoreView updateItemWithImage:[UIImage imageNamed:@"照片"] highlightedImage:[UIImage imageNamed:@"照片"] title:@"照片" atIndex:0];
    [self.chatBarMoreView updateItemWithImage:[UIImage imageNamed:@"坐标"] highlightedImage:[UIImage imageNamed:@"坐标"] title:@"坐标" atIndex:1];
    [self.chatBarMoreView updateItemWithImage:[UIImage imageNamed:@"拍摄"] highlightedImage:[UIImage imageNamed:@"拍摄"] title:@"拍摄" atIndex:2];
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"名片"] highlightedImage:[UIImage imageNamed:@"名片"] title:@"名片"];
}

//自定义功能的回调
- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index{
    //只加了名片,所以这里无需判断index
//    if (self.conversation.type == EMConversationTypeChat) {
        WXUsersListViewController *userListVC = [[WXUsersListViewController alloc] init];
        userListVC.cardCallBack = ^(NSString * _Nonnull userID) {
            
            [MineViewModel getFriendInfoWithFriendID:userID success:^(FriendModel * model) {
                //发送名片
                [self sendInfoViewWithModel:model];
            } failure:^(NSError * error) {
                
            }];
        };
        userListVC.isEditing = YES;
        userListVC.isInfoCard = YES;
        WXPresentNavigationController *nav = [[WXPresentNavigationController alloc] initWithRootViewController:userListVC];
        [self presentViewController:nav animated:YES completion:nil];
        //私聊
        
//    }else{
        //群聊
//    }
    
    
//    [self presentDocumentPicker];
//    [EMClient sharedClient].callManager startCall:<#(EMCallType)#> remoteName:<#(NSString *)#> ext:<#(NSString *)#> completion:<#^(EMCallSession *aCallSession, EMError *aError)aCompletionBlock#>
}
- (void)sendInfoViewWithModel:(FriendModel *)model{
    NSLog(@"发送名片");
    //WDX fix
    NSDictionary *dic = @{@"userName":model.tgusetname,@"company":model.tgusetcompany,@"userIcon":model.tgusetimg,@"userID":model.tgusetid};
    [self sendTextMessage:@"[名片]" withExt:dic];

}
//重写以添加用户个人信息
- (void)sendMessage:(EMMessage *)message isNeedUploadFile:(BOOL)isUploadFile{
    NSMutableDictionary *Muext = [NSMutableDictionary dictionaryWithDictionary:message.ext];
    [Muext setObject:[WXAccountTool getUserName] forKey:@"from_name_user"];
    [Muext setObject:[WXAccountTool getUserImage] forKey:@"from_heading_user"];
    message.ext= Muext;
    [super sendMessage:message isNeedUploadFile:isUploadFile];
}
- (BOOL)messageViewController:(EaseMessageViewController *)viewController didSelectMessageModel:(id<IMessageModel>)messageModel{
    if (messageModel.bodyType == EMMessageBodyTypeText && [[messageModel text] hasPrefix:@"[名片]"]){
        NSString *ID = [NSString stringWithFormat:@"%@",messageModel.message.ext[@"userID"]];
        //可能要先判断是不是好友
        [MineViewModel judgeIsFriendWithFriendID:ID success:^(NSString * msg) {
            if ([msg isEqualToString:@"是"]){
                WXUserMomentInfoViewController * controller = [[WXUserMomentInfoViewController alloc] init];
                controller.userId = ID;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [MineViewModel getUserInfo:ID success:^(UserInfoModel * model) {
                    WXfriendResultViewController *resultVC = [[WXfriendResultViewController alloc] init];
                    resultVC.model = model;
                    [self.navigationController pushViewController:resultVC animated:true];
                } failure:^(NSError * error) {
                    
                }];
//                //不是好友// 接口不支持
//                [MineViewModel getFriendInfoWithFriendID:ID success:^(FriendModel * model) {
//                    UserInfoModel *temp = [[UserInfoModel alloc] init];
//                    temp.tgusetid = model.tgusetid;
//                    temp.tgusetname = model.tgusetname;
//                    temp.tgusetimg = model.tgusetimg;
//                    temp.tgusetcompany = model.tgusetcompany;
//                    temp.tgusetposition = model.tgusetposition;
//
//                } failure:^(NSError * error) {
//
//                }];
            }
        } failure:^(NSError * error) {
            
        }];

        return YES;
    }
    return NO;
}
//文件选择器
- (void)presentDocumentPicker {
    NSArray *types = @[@"com.apple.iwork.pages.pages",@"com.apple.iwork.numbers.numbers",@"com.apple.iwork.keynote.key"]; // 可以选择的文件类型
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:documentPicker animated:YES completion:nil];
}
//文件选择的回调
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    BOOL canAccessingResource = [url startAccessingSecurityScopedResource];
    if(canAccessingResource) {
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
            NSData *fileData = [NSData dataWithContentsOfURL:newURL];
            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath = [arr lastObject];
            NSString *desFileName = [documentPath stringByAppendingPathComponent:@"myFile"];
            [fileData writeToFile:desFileName atomically:YES];
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        if (error) {
            // error handing
        }
    } else {
        // startAccessingSecurityScopedResource fail
    }
    [url stopAccessingSecurityScopedResource];
}
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    
    //用户可以根据自己的用户体系，根据message设置用户昵称和头像
    id<IMessageModel> model = nil;
    //EaseMessageModel是环信EaseUI提供的model  直接引用就好了
    model = [[EaseMessageModel alloc] initWithMessage:message];
    
    //分两种情况  一种是当为当前用户的时候
    if ([model.nickname isEqualToString:[EMClient sharedClient].currentUsername]) {
        //默认图
//        model.avatarImage = [UIImage imageNamed:@"normal_icon"];
        model.avatarURLPath = [WXAccountTool getUserImage];
        //网络图
//        model.avatarURLPath = accInfo.pic;
    }else{//当为对方的时候
        NSString *url = [NSString stringWithFormat:@"%@",message.ext[@"from_heading_user"]];
        model.avatarURLPath = url;//网络图
    }
    model.nickname = nil;//用户昵称
    
    
    return model;
}

//自定义cell
- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel{
    if (messageModel.bodyType == EMMessageBodyTypeText && [[messageModel text] hasPrefix:@"[名片]"]){
        NSString *cellid = [WXPersonInfoCell cellIdentifierWithModel:messageModel];
        WXPersonInfoCell *infoCell = (WXPersonInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
        infoCell.hasRead.hidden = true;
        if (!infoCell){
            infoCell = [[WXPersonInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid model:messageModel];
        }
        infoCell.model = messageModel;
        return infoCell;
    }
    return nil;
}
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController heightForMessageModel:(id<IMessageModel>)messageModel withCellWidth:(CGFloat)cellWidth{
    if (messageModel.bodyType == EMMessageBodyTypeText && [[messageModel text] hasPrefix:@"[名片]"]){
        return [WXPersonInfoCell cellHeightWithModel:messageModel];
    }
    return 0;
}
//easeUI中未实现群组语音方法
- (void)moreViewCommunicationAction:(EaseChatBarMoreView *)moreView{
    [self.chatToolbar endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CALL_MAKECONFERENCE object:@{CALL_TYPE:@(EMConferenceTypeLargeCommunication), CALL_MODEL:self.conversation, NOTIF_NAVICONTROLLER:self.navigationController}];
}

- (void)moreViewLiveAction:(EaseChatBarMoreView *)moreView{
    [self.chatToolbar endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CALL_MAKECONFERENCE object:@{CALL_TYPE:@(EMConferenceTypeLive), CALL_MODEL:self.conversation, NOTIF_NAVICONTROLLER:self.navigationController}];
}
@end
