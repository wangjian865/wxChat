//
//  WXMessageAlertViewController.m
//  WXChat
//
//  Created by WDX on 2019/6/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMessageAlertViewController.h"
#import "WXMessageAlertViewCell.h"
#import "WXMessageAlertModel.h"
@interface WXMessageAlertViewController ()
/**
 * 模型数组
 */
@property (nonatomic, strong) NSArray *modelArray;
@end

@implementation WXMessageAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self getData];
    [self setupUI];
    
}

- (void)getData{
    NSArray *arr = @[
  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
  ];
    _modelArray = [NSArray yy_modelArrayWithClass:[WXMessageAlertModel class] json:arr];
    NSLog(@"1");
}
- (void)setupUI{
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
    return _modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return k_current_Height(74);
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
    WXMessageAlertModel *model = _modelArray[indexPath.section];
    [cell setModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
