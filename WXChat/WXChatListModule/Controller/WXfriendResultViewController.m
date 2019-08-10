//
//  WXfriendResultViewController.m
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXfriendResultViewController.h"

@interface WXfriendResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postionLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLable;

@end

@implementation WXfriendResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_model.tgusetimg]];
    _nameLabel.text = _model.tgusetname;
    _postionLabel.text = _model.tgusetposition;
    _companyLable.text = _model.tgusetcompany;
}
- (IBAction)addFriendAction:(UIButton *)sender {
    [MineViewModel addFriendWithFriendID:_model.tgusetid context:@"" success:^(NSString * msg) {
        [MBProgressHUD showText:msg];
    } failure:^(NSError * error) {
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
