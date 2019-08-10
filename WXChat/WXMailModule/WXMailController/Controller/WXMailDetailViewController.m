//
//  WXMailDetailViewController.m
//  WXChat
//
//  Created by WX on 2019/8/9.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMailDetailViewController.h"
#import "WXWriteEmailViewController.h"
@interface WXMailDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@property (strong, nonatomic) UIAlertController *alertView;
@property (weak, nonatomic) IBOutlet UIView *fistView;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailSenderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderEmail;
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverEmail;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIStackView *bottomView;

///模型
@property (nonatomic, strong) MailDetails *model;
@end

@implementation WXMailDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.webView.delegate = self;
    self.webView.scrollView.bounces = false;
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self getDetailData];
    if (![_categoryType isEqualToString:@"1"]){
        _bottomView.hidden = true;
    }
}

- (void)getDetailData {
    [MailViewModel getMailDetailWithMailAccount:_user accountType:_typeName categoryType:_categoryType serviceId:_emailId successBlock:^(MailDetails * _Nonnull model) {
        self.model = model;
        self.titleLabel.text = [NSString stringWithFormat:@"    %@",model.context.readeamiltheme];
        //发件赋值
        NSString *senderTotal = model.context.readeamilsendtugset;
        if ([senderTotal containsString:@"\""]){
            NSString *senderName = [senderTotal componentsSeparatedByString:@"\""][1];
            self.senderNameLabel.text = senderName;
            self.detailSenderNameLabel.text = senderName;
            
        }else{
            
        }
        if ([senderTotal containsString:@"<"]){
            NSString *senderEmail = [senderTotal componentsSeparatedByString:@"<"].lastObject;
            self.senderEmail.text = [senderEmail componentsSeparatedByString:@">"].firstObject;
        }else{
            
        }
        //收件赋值
        NSString *receiverTotal = [[[[model.context.readeamilshowtugset stringByReplacingOccurrencesOfString:@"\\" withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
        if ([receiverTotal containsString:@"\""]){
            
            NSArray *receivers = [receiverTotal componentsSeparatedByString:@"\""];
            receivers = [receivers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
            NSMutableArray *users = [NSMutableArray array];
            NSMutableArray *emails = [NSMutableArray array];
            [receivers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx%2 == 0){
                    [users addObject:obj];
                }else{
                    [emails addObject:obj];
                }
            }];
                
            self.receiverLabel.text = [users componentsJoinedByString:@","];
            self.receiverEmail.text = [emails componentsJoinedByString:@","];;
        }
        
        self.timeLabel.text = model.context.readeamiltime;
        [self.webView loadHTMLString:model.context.readeamilcontet baseURL:nil];
        self.secondView.hidden = YES;
    } failBlock:^(NSError * _Nonnull error) {
        
    }];

}

- (IBAction)showDetailAction:(UIButton *)sender {
    _fistView.hidden = true;
    _secondView.hidden = false;
}
- (IBAction)hideDetailAction:(UIButton *)sender {
    _fistView.hidden = false;
    _secondView.hidden = true;

}

- (IBAction)deleteAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您将删除这份邮件?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //删除
        [self deleteRequest];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:true completion:nil];
}
- (IBAction)repeatAction:(id)sender {
    WXWriteEmailViewController *mailVC = [[WXWriteEmailViewController alloc] init];
    mailVC.type = _typeName;
    mailVC.account = _account;
    mailVC.htmlStr = self.model.context.readeamilcontet;
    mailVC.receiver = _senderEmail.text;
    mailVC.isReply = YES;
    mailVC.subjectStr = _titleLabel.text;
    mailVC.messageID = _model.context.readmailmessageid;
    [self.navigationController pushViewController:mailVC animated:true];
}
- (IBAction)zhuanfaAction:(id)sender {
    WXWriteEmailViewController *mailVC = [[WXWriteEmailViewController alloc] init];
    mailVC.type = _typeName;
    mailVC.account = _account;
    mailVC.htmlStr = self.model.context.readeamilcontet;
    mailVC.receiver = _senderEmail.text;
    mailVC.isReply = NO;
    mailVC.subjectStr = _titleLabel.text;
    mailVC.messageID = _model.context.readmailmessageid;
    [self.navigationController pushViewController:mailVC animated:true];
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    CGFloat webViewHeight = [webView.scrollView contentSize].height;
//    _webViewHeight.constant = webViewHeight;
//}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webViewHeight.constant = self.webView.scrollView.contentSize.height;
    
    }
}
///network
- (void)deleteRequest {
    [MailViewModel deleteMailWithMailAccount:_user typeName:_typeName categoryType:_categoryType emailId:_emailId successBlock:^(NSString * _Nonnull successMessage) {
        //
        [self.navigationController popViewControllerAnimated:true];
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
@end
