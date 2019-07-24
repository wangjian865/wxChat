//
//  WXChooseMailTypeTableViewController.m
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXChooseMailTypeTableViewController.h"
#import "WXMailLoginViewController.h"
@interface WXChooseMailTypeTableViewController ()

@end

@implementation WXChooseMailTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加邮箱";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMailLoginViewController *loginVC = [[WXMailLoginViewController alloc] init];
    loginVC.title = @"qq邮箱";
    [self.navigationController pushViewController:loginVC animated:true];
}

@end
