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

@end

@implementation WXNewAddFriendViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.rowHeight = 104;
    [_tableView registerNib:[UINib nibWithNibName:@"WXNewAddTableViewCell" bundle:nil] forCellReuseIdentifier:@"newCell"];
    _searchTF.delegate = self;
}
- (IBAction)addContackFriendsAction:(UIButton *)sender {
    WXContackListViewController *listVC = [[WXContackListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXNewAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newCell" forIndexPath:indexPath];
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
    //先获取搜索结果后跳转
    
    WXfriendResultViewController *resultVC = [[WXfriendResultViewController alloc] init];
    [self.navigationController pushViewController:resultVC animated:true];
    
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXfriendResultViewController *resultVC = [[WXfriendResultViewController alloc] init];
    [self.navigationController pushViewController:resultVC animated:true];
}
@end
