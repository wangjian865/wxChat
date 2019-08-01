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
@interface WXUserMomentInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *momentView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhiweiLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *momentImages;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *lastImageView;
@property (nonatomic, assign)CGRect originalFrame;
@property (nonatomic, assign)BOOL isDoubleTap;
@end

@implementation WXUserMomentInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getRequestData];
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showZoomImageView:)];
    self.iconView.userInteractionEnabled = YES;
    [self.iconView addGestureRecognizer:iconTap];
    UITapGestureRecognizer *momentViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(momentViewTapAction)];
    [self.momentView addGestureRecognizer:momentViewTap];
    
}
- (void)getRequestData {
    
    [CompanyViewModel getPersonMomentDataWithUserIdL:self.userId successBlock:^(UserMomentInfoModel * _Nonnull model) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.tgusetImg]];
        self.nameLabel.text = model.tgusetName;
        self.zhiweiLabel.text = model.tgusetPosition;
        self.companyLabel.text = model.tgusetCompany;
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
    WXChatViewController *viewController = [[WXChatViewController alloc] initWithConversationChatter:@"user3" conversationType:EMConversationTypeChat];
//    viewController.title = userModel.nickname;
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
@end
