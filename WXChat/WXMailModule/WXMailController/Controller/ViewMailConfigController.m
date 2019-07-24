//
//  ViewMailConfigController.m
//  WXChat
//
//  Created by WX on 2019/7/24.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "ViewMailConfigController.h"

@interface ViewMailConfigController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

//收信服务器
@property (weak, nonatomic) IBOutlet UIView *receiveView;
@property (weak, nonatomic) IBOutlet UITextField *first_serviceTF;
@property (weak, nonatomic) IBOutlet UITextField *first_accountTF;
@property (weak, nonatomic) IBOutlet UITextField *first_pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *first_duankouTF;
@property (weak, nonatomic) IBOutlet UILabel *first_encryptTF;


//收信服务器
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UITextField *second_serviceTF;
@property (weak, nonatomic) IBOutlet UITextField *second_accountTF;
@property (weak, nonatomic) IBOutlet UITextField *second_pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *second_duankouTF;
@property (weak, nonatomic) IBOutlet UILabel *second_encryptTF;


//服务器配置
@property (weak, nonatomic) IBOutlet UIView *exchangeView;
@property (weak, nonatomic) IBOutlet UITextField *Third_serviceTF;
@property (weak, nonatomic) IBOutlet UITextField *Third_yuTF;
@property (weak, nonatomic) IBOutlet UITextField *Third_accountTF;
@property (weak, nonatomic) IBOutlet UITextField *Third_pwdTF;
@property (weak, nonatomic) IBOutlet UISwitch *Third_SSLSwitchControl;


@end

@implementation ViewMailConfigController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务器设置";
    
}
- (IBAction)segmentSelectAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0){
        _exchangeView.hidden = YES;
        _sendView.hidden = NO;
        _receiveView.hidden = NO;
    }else if (sender.selectedSegmentIndex == 1){
        _exchangeView.hidden = YES;
        _sendView.hidden = NO;
        _receiveView.hidden = NO;
    }else{
        _exchangeView.hidden = NO;
        _sendView.hidden = YES;
        _receiveView.hidden = YES;
    }
}


@end
