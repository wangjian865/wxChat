//
//  WXChatViewController.m
//  WXChat
//
//  Created by WDX on 2019/4/28.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXChatViewController.h"

@interface WXChatViewController ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource,UIDocumentPickerDelegate>

@end

@implementation WXChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    //添加文件传输按钮
    [self addFileTransferbButton];
}
- (void)addFileTransferbButton {
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"tabbar_maillist_sel"] highlightedImage:[UIImage imageNamed:@"tabbar_maillist_sel"] title:@"文件传输"];
}
//自定义功能的回调
- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index{
    [self presentDocumentPicker];
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

@end
