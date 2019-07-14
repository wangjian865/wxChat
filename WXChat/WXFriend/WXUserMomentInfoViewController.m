//
//  WXUserMomentInfoViewController.m
//  WXChat
//
//  Created by WX on 2019/7/14.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXUserMomentInfoViewController.h"

@interface WXUserMomentInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *momentView;

@end

@implementation WXUserMomentInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTapAction)];
    [self.iconView addGestureRecognizer:iconTap];
    UITapGestureRecognizer *momentViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(momentViewTapAction)];
    [self.momentView addGestureRecognizer:momentViewTap];
    
}
- (void)iconTapAction {
    NSLog(@"点击了头像");
}
- (void)momentViewTapAction {
    NSLog(@"点击了企业圈");
}
- (IBAction)gotoChat:(UIButton *)sender {
}
//        let chatVC = WXChatViewController(conversationChatter: "user3", conversationType: EMConversationType(rawValue: 0))
//        chatVC?.title = "xxx聊天"
//        superVC?.navigationController?.pushViewController(chatVC!, animated: true)


@end
