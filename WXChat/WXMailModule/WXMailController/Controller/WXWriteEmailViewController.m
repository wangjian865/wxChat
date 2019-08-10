//
//  WXWriteEmailViewController.m
//  WXChat
//
//  Created by WX on 2019/8/5.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXWriteEmailViewController.h"
#import "WXInboxViewController.h"
@interface WXWriteEmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *receiverTF;
@property (weak, nonatomic) IBOutlet UITextField *subjectTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTVHeight;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *yuanWenLabel;
@property (weak, nonatomic) IBOutlet UIWebView *emailView;

@end

@implementation WXWriteEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviBar];
    ///监听tv
    [_contentTV addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    if (!_htmlStr){
        _emailViewHeight.constant = 0;
        _yuanWenLabel.hidden = YES;
    }else{
        [_emailView loadHTMLString:_htmlStr baseURL:nil];
        _emailView.scrollView.bounces = NO;
        [_emailView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        if (_isReply){
            _subjectTF.text = [NSString stringWithFormat:@"Re:%@",_subjectStr];
            _receiverTF.text = _receiver;
        }else{
            _subjectTF.text = [NSString stringWithFormat:@"Fw:%@",_subjectStr];
        }
        
    }
    
}
- (void)setupNaviBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"已发送"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(messageRequest)];
}
- (void)messageRequest {
    
    ///确保输入完成
    if (!(_receiverTF.text.length > 0 && _subjectTF.text.length > 0 && _contentTV.text.length > 0)){
        return;
    }
    //区分发邮件的类型
    [MBProgressHUD showHUD];
    if (!_htmlStr){
        [self sendMailRequest];
    }else{
        if (_isReply){
            [self replyEmailRequest];
        }else{
            [self zhuanfaEmailRequest];
        }
    }
}
///send mail request
- (void)sendMailRequest {
    [MailViewModel sendMailWithMailAccount:_account mailTitle:_subjectTF.text receiver:_receiverTF.text accountType:_type content:_contentTV.text attachment:@"" successBlock:^(NSString * _Nonnull successMessage) {
        [self showHint:@"发送成功"];
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[WXInboxViewController class]]){
                [self.navigationController popToViewController:vc animated:true];
                return;
            }
        }
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
///回复
- (void)replyEmailRequest {
    [MailViewModel replyMailWithMailAccount:_account serviceId:_messageID title:_subjectTF.text receiver:_receiverTF.text accountType:_type content:_contentTV.text successBlock:^(NSString * _Nonnull successMessage) {
        [self showHint:@"发送成功"];
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[WXInboxViewController class]]){
                [self.navigationController popToViewController:vc animated:true];
                return;
            }
        }
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
///转发
- (void)zhuanfaEmailRequest {
    [MailViewModel forwardMailWithMailAccount:_account serviceId:_messageID title:_subjectTF.text receiver:_receiverTF.text accountType:_type content:_contentTV.text successBlock:^(NSString * _Nonnull successMessage) {
        [self showHint:@"发送成功"];
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[WXInboxViewController class]]){
                [self.navigationController popToViewController:vc animated:true];
                return;
            }
        }
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
//监听webview高度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (![object isKindOfClass:[UITextView class]]){
           self.emailViewHeight.constant = self.emailView.scrollView.contentSize.height;
        }else{
            CGFloat height = self.contentTV.contentSize.height;
            if (height > 120){
                self.contentTVHeight.constant = height;
            }else{
                self.contentTVHeight.constant = 120;
            }
        }
    }
}
@end
