//
//  WXMessageAlertViewController.m
//  WXChat
//
//  Created by WDX on 2019/6/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMessageAlertViewController.h"
#import "WXMessageAlertViewCell.h"
@interface WXMessageAlertViewController ()

@end

@implementation WXMessageAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self setupUI];
}

- (void)setupUI{
    self.tableView.rowHeight = k_current_Height(74);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"清空" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.size = CGSizeMake(40, 100);
    [button addTarget:self action:@selector(rightNaviItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightNaviItemAction{
    NSLog(@"do sth");
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alisdkZhaopin://"]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return k_current_Height(30);
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"2019年5月28日 19:00";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        //操作数据源
        NSLog(@"delete %ld",indexPath.section);
    }
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMessageAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXMessageAlertViewCell"];
    if (cell == nil){
        cell = [[WXMessageAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WXMessageAlertViewCell"];
    }
    return cell;
}
@end
