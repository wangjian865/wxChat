//
//  WXMessageAlertViewController.m
//  WXChat
//
//  Created by WDX on 2019/6/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMessageAlertViewController.h"
#import "WXMessageAlertViewCell.h"
#import "WXMessageAlertListModel.h"
#import "WXChatService.h"
@interface WXMessageAlertViewController ()
/**
 * 模型数组
 */
@property (nonatomic, strong) WXMessageAlertListModel *model;

@end

@implementation WXMessageAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
//    [self getData];
    [self getdata];
    [self setupUI];
}

- (void)getData{
//    NSArray *arr = @[
//  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
//  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
//  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
//  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
//  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
//  @{@"avatarUrl":@"http://img.52z.com/upload/news/image/20181108/20181108204521_83402.jpg",@"name":@"皮卡丘",@"descriptionText":@"皮卡丘申请加入成都联盟",@"status":@"确认"},
//  ];
//    _modelArray = [NSArray yy_modelArrayWithClass:[WXMessageAlertModel class] json:arr];
//    NSLog(@"1");
}
- (void)getdata{
    [WXChatService getAllAddFriendRequestSuccessBlock:^(WXMessageAlertListModel * _Nonnull model) {
        self.model = model;
        [self.tableView reloadData];
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
- (void)setupUI{
    ///无接口
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"清空" forState:UIControlStateNormal];
//    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:13];
//    button.size = CGSizeMake(40, 100);
//    [button addTarget:self action:@selector(rightNaviItemAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightNaviItemAction{
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alisdkZhaopin://"]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _model.data.count;
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
    WXMessageAlertModel *model = _model.data[section];
    return [Utility getMomentTime:model.friendshowktime];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        //操作数据源
        WXMessageAlertModel *model = _model.data[indexPath.section];
        [MineViewModel deleteAddRequestWithShowId:model.friendshowid success:^(NSString * msg) {
            [self getdata];
        } failure:^(NSError * error) {
            
        }];
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
    WXMessageAlertModel *model = _model.data[indexPath.section];
    [cell setModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
