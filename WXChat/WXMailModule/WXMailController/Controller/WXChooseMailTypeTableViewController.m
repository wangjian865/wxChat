//
//  WXChooseMailTypeTableViewController.m
//  WXChat
//
//  Created by WX on 2019/7/13.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXChooseMailTypeTableViewController.h"
#import "WXMailLoginViewController.h"
#import "WXMailListViewController.h"
@interface WXChooseMailTypeTableViewController ()
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *typeArr;

@end
@implementation WXChooseMailTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邮箱";
    [self setRightBarButton];
    _titleArr = @[@"qq邮箱",@"163邮箱",@"126邮箱",@"新浪邮箱",@"其他"];
    _typeArr = @[@"qq",@"163",@"126",@"sina",@"other"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)setRightBarButton{
    UIImage *image = [[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(gotoListView)];
}
- (void)gotoListView{
    WXMailListViewController *listVC = [[WXMailListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:true];
}
//qq 163 126 新浪 其他
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMailLoginViewController *loginVC = [[WXMailLoginViewController alloc] init];
    loginVC.title = _titleArr[indexPath.row];
    loginVC.type = _typeArr[indexPath.row];
    [self.navigationController pushViewController:loginVC animated:true];
}

@end
