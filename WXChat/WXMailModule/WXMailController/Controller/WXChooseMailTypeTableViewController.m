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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMailLoginViewController *loginVC = [[WXMailLoginViewController alloc] init];
    loginVC.title = @"qq邮箱";
    [self.navigationController pushViewController:loginVC animated:true];
}

@end
