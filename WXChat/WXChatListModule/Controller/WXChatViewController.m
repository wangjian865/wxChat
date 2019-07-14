//
//  WXChatViewController.m
//  WXChat
//
//  Created by WDX on 2019/4/28.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXChatViewController.h"

@interface WXChatViewController ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource,UIDocumentPickerDelegate,EMCallManagerDelegate>

@end

@implementation WXChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    //设置聊天会话样式
//    [self setChatAppearance];
    //添加文件传输按钮
//    [self insetItemForChatBar];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
}
//设置聊天会话样式
- (void)setChatAppearance{
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];//设置发送气泡
    
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];//设置接收气泡
    
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];//设置头像大小
    
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:20.f];//设置头像圆角
    
    [[EaseMessageCell appearance] setMessageTextFont:[UIFont systemFontOfSize:15]];//消息显示字体
    
    [[EaseMessageCell appearance] setMessageTextColor:[UIColor blackColor]];//消息显示颜色
    
    [[EaseMessageCell appearance] setMessageLocationFont:[UIFont systemFontOfSize:12]];//位置消息显示字体
    
    [[EaseMessageCell appearance] setMessageLocationColor:[UIColor whiteColor]];//位置消息显示颜色
    
    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:@[[UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_full"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_000"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_001"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_002"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_003"]]];//发送者语音消息播放图片
    
    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:@[[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing_full"],[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing000"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing001"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing002"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing003"]]];//接收者语音消息播放图片
}
//- (void)insetItemForChatBar {
//    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"tabbar_maillist_sel"] highlightedImage:[UIImage imageNamed:@"tabbar_maillist_sel"] title:@"文件传输"];
//}
//自定义功能的回调
- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index{
//    [self presentDocumentPicker];
//    [EMClient sharedClient].callManager startCall:<#(EMCallType)#> remoteName:<#(NSString *)#> ext:<#(NSString *)#> completion:<#^(EMCallSession *aCallSession, EMError *aError)aCompletionBlock#>
}
//文件选择器
- (void)presentDocumentPicker {
    NSArray *types = @[]; // 可以选择的文件类型
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
        model.avatarImage = [UIImage imageNamed:@"DefaultImg"];
        //网络图
//        model.avatarURLPath = accInfo.pic;
    }else{//当为对方的时候
//        model.avatarURLPath = _imageUrl;//网络图
        model.avatarImage =  [UIImage imageNamed:@"DefaultImg"];
    }
    model.nickname = nil;//用户昵称
    return model;
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
