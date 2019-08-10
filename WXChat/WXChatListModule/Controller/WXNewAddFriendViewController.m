//
//  WXNewAddFriendViewController.m
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXNewAddFriendViewController.h"
#import "WXNewAddTableViewCell.h"
#import <IQKeyboardManager.h>
#import "WXfriendResultViewController.h"
#import "WXContackListViewController.h"
@interface WXNewAddFriendViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (strong, nonatomic) NSArray <WXMessageAlertModel *> *models;
@end

@implementation WXNewAddFriendViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    _tableView.rowHeight = 104;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView registerNib:[UINib nibWithNibName:@"WXNewAddTableViewCell" bundle:nil] forCellReuseIdentifier:@"newCell"];
    _searchTF.delegate = self;
    [self getAddList];
}
- (void)getAddList {
    [MineViewModel getAddFriendListWithSuccess:^(NSArray<WXMessageAlertModel *> * friends) {
        self.models = friends;
        [self.tableView reloadData];
    } failure:^(NSError * error) {
        
    }];
}
- (IBAction)addContackFriendsAction:(UIButton *)sender {
    WXContackListViewController *listVC = [[WXContackListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.models != nil){
        return self.models.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMessageAlertModel *model = _models[indexPath.row];
    WXNewAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newCell" forIndexPath:indexPath];
    WS(wSelf);
    cell.handleCallBack = ^{
        [wSelf getAddList];
    };
    cell.model = model;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        //删除事件
        
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length <= 0){
        [MBProgressHUD showError:@"请输入手机号"];
        [textField endEditing:true];
        return NO;
    }
    NSString *account = textField.text;
    //先获取搜索结果后跳转
    [MineViewModel getUserInfo:account success:^(UserInfoModel * model) {
        NSLog(@"1");
        
        WXfriendResultViewController *resultVC = [[WXfriendResultViewController alloc] init];
        resultVC.model = model;
        [self.navigationController pushViewController:resultVC animated:true];
    } failure:^(NSError * error) {
        
    }];
    return YES;
}

//不跳转
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    WXfriendResultViewController *resultVC = [[WXfriendResultViewController alloc] init];
//    WXMessageAlertModel *model = _models[indexPath.row];
//
//    [self.navigationController pushViewController:resultVC animated:true];
//}
@end
