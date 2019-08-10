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
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *typeArr;

@end
@implementation WXChooseMailTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加邮箱";
    _titleArr = @[@"qq邮箱",@"163邮箱",@"126邮箱",@"新浪邮箱",@"其他"];
    _typeArr = @[@"qq",@"163",@"126",@"sina",@"other"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

//qq 163 126 新浪 其他
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMailLoginViewController *loginVC = [[WXMailLoginViewController alloc] init];
    loginVC.title = _titleArr[indexPath.row];
    loginVC.type = _typeArr[indexPath.row];
    [self.navigationController pushViewController:loginVC animated:true];
}

@end
