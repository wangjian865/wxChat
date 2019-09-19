//
//  WXUserMomentInfoViewController.m
//  WXChat
//
//  Created by WX on 2019/7/14.
//  Copyright © 2019 WDX. All rights reserved.
//好友详情

#import "WXUserMomentInfoViewController.h"
#import "WXPersonMomentViewController.h"
#import "WXChatViewController.h"
#import "CompanyViewModel.h"
#import "YCMenuView.h"
@interface WXUserMomentInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *momentView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhiweiLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (weak, nonatomic) IBOutlet UIButton *makeSureButton;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *momentImages;
@property (nonatomic, copy) NSString *userID;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *lastImageView;
@property (nonatomic, assign)CGRect originalFrame;
@property (nonatomic, assign)BOOL isDoubleTap;
@end

@implementation WXUserMomentInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviRightButton];
    
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showZoomImageView:)];
    self.iconView.userInteractionEnabled = YES;
    [self.iconView addGestureRecognizer:iconTap];
    UITapGestureRecognizer *momentViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(momentViewTapAction)];
    [self.momentView addGestureRecognizer:momentViewTap];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getRequestData];
}
- (void)getRequestData {
    [CompanyViewModel getPersonMomentDataWithUserIdL:self.userId successBlock:^(UserMomentInfoModel * _Nonnull model) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.tgusetImg]];
        self.nameLabel.text = model.tgusetName;
        self.zhiweiLabel.text = model.tgusetPosition;
        self.companyLabel.text = model.tgusetCompany;
        self.userID = model.tgusetId;
        for (int i = 0;i < model.urlName.count && i < 5;i++){
            UIImageView *imageV = self.momentImages[i];
            [imageV sd_setImageWithURL:[NSURL URLWithString:model.urlName[i]]];
        }
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)momentViewTapAction {
    NSLog(@"点击了企业圈");
    WXPersonMomentViewController *vc = [[WXPersonMomentViewController alloc] init];
    vc.userId = self.userId;
    [self.navigationController pushViewController:vc animated:true];
}
- (IBAction)gotoChat:(UIButton *)sender {
    WXChatViewController *viewController = [[WXChatViewController alloc] initWithConversationChatter:self.userId conversationType:EMConversationTypeChat];
    viewController.title = self.nameLabel.text;
    [self.navigationController pushViewController:viewController animated:YES];
}
//        let chatVC = WXChatViewController(conversationChatter: "user3", conversationType: EMConversationType(rawValue: 0))
//        chatVC?.title = "xxx聊天"
//        superVC?.navigationController?.pushViewController(chatVC!, animated: true)


-(void)showZoomImageView:(UITapGestureRecognizer *)tap
{
    if (![(UIImageView *)tap.view image]) {
        return;
    }
    //scrollView作为背景
    UIScrollView *bgView = [[UIScrollView alloc] init];
    bgView.frame = [UIScreen mainScreen].bounds;
    bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    [bgView addGestureRecognizer:tapBg];
    
    UIImageView *picView = (UIImageView *)tap.view;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = picView.image;
    imageView.frame = [bgView convertRect:picView.frame fromView:self.view];
    [bgView addSubview:imageView];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
    
    self.lastImageView = imageView;
    self.originalFrame = imageView.frame;
    self.scrollView = bgView;
    //最大放大比例
    self.scrollView.maximumZoomScale = 1.5;
//    self.scrollView.delegate = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = imageView.frame;
        frame.size.width = bgView.frame.size.width;
        frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
        frame.origin.x = 0;
        frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5;
        imageView.frame = frame;
    }];
}

-(void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer
{
    self.scrollView.contentOffset = CGPointZero;
    [UIView animateWithDuration:0.5 animations:^{
        self.lastImageView.frame = self.originalFrame;
        tapBgRecognizer.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [tapBgRecognizer.view removeFromSuperview];
        self.scrollView = nil;
        self.lastImageView = nil;
    }];
}
//popMenu
//设置右边按钮
- (void)setNaviRightButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"椭圆4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarBtn:)];
}
- (void)clickRightBarBtn: (UIButton *)sender{
    WS(weaklf);
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"删除好友" image:[UIImage imageNamed:@"删除"] handler:^(YCMenuAction *action) {
        [MineViewModel deleteFriendWithFriendID:weaklf.userID success:^(NSDictionary<NSString *,id> * result) {
            NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
            if ([code isEqualToString:@"200"]){
                [MBProgressHUD showSuccess:@"删除成功"];
                [WXChatService deleteAConversationWithId:self.userID completion:nil];
                ///本地删除并发送一条透传消息给对象
                EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"deleteFriedn"];
                NSString *from = [WXAccountTool getUserID];
                EMMessage *message = [[EMMessage alloc] initWithConversationID:self.userID from:from to:self.userID body:body ext:nil];
                [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
//                    [easeMessage _refreshAfterSentMessage:aMessage];
                }];
                [self.navigationController popViewControllerAnimated:true];
            }
        } failure:^(NSError * error) {
            
        }];
    }];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"拉入黑名单" image:[UIImage imageNamed:@"黑名单"] handler:^(YCMenuAction *action) {
        [MineViewModel deleteFriendWithFriendID:weaklf.userID success:^(NSDictionary<NSString *,id> * result) {
            NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
            if ([code isEqualToString:@"200"]){
                [MBProgressHUD showSuccess:@"删除成功"];
                [WXChatService deleteAConversationWithId:self.userID completion:nil];
                ///本地删除并发送一条透传消息给对象
                EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"deleteFriedn"];
                NSString *from = [WXAccountTool getUserID];
                EMMessage *message = [[EMMessage alloc] initWithConversationID:self.userID from:from to:self.userID body:body ext:nil];
                [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
                    //                    [easeMessage _refreshAfterSentMessage:aMessage];
                }];
                [self.navigationController popViewControllerAnimated:true];
            }
        } failure:^(NSError * error) {
            
        }];
    }];
    YCMenuAction *action3 = [YCMenuAction actionWithTitle:@"举报" image:[UIImage imageNamed:@"举报"] handler:^(YCMenuAction *action) {
        [MBProgressHUD showSuccess:@"我们已收到您的举报,将尽快对该用户进行审核处理"];
    }];
    NSArray *arr = @[action1,action2,action3];
    YCMenuView *view = [YCMenuView menuWithActions:arr width:140 relyonView:sender];
    view.textFont = [UIFont systemFontOfSize:14];
    view.textColor = UIColor.whiteColor;
    view.maxDisplayCount = 7;
    [view show];
//    self.menuView = view;
}
@end
