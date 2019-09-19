//
//  WXContackListViewController.m
//  WXChat
//
//  Created by WX on 2019/7/17.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXContackListViewController.h"
#import <Contacts/Contacts.h>
#import "WXContactCell.h"
@interface WXContackListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, weak)UIButton *selectAllButton;
@property (nonatomic, weak)UILabel *selectCountLabel;
@property (nonatomic, weak)UIButton *makeSureButton;

@property (nonatomic, assign)int itemCount;
@property (nonatomic, strong)NSArray *modelArr;
@property (nonatomic, strong)NSMutableArray *selectIndexArr;
@end

@implementation WXContackListViewController
- (UIView *)topView{
    if (_topView == nil){
        _topView = [[NSBundle mainBundle] loadNibNamed:@"WXContactView" owner:nil options:nil].firstObject;
        _selectAllButton = [_topView viewWithTag:101];
        _selectCountLabel = [_topView viewWithTag:102];
    }
    return _topView;
}
- (UIView *)bottomView{
    if (_bottomView == nil){
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"WXContactView" owner:nil options:nil].lastObject;
        _bottomView.frame = CGRectMake(0, 0, k_screen_width, 66);
        _makeSureButton = [_bottomView viewWithTag:101];
    }
    return _bottomView;
}
- (NSMutableArray *)selectIndexArr{
    if (_selectIndexArr == nil){
        _selectIndexArr = [NSMutableArray array];
    }
    return _selectIndexArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _itemCount = 0;
    [self setupUI];
    [self requestContactAuthorAfterSystemVersion];
}

- (void)setupUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    [_tableView registerNib:[UINib nibWithNibName:@"WXContactCell" bundle:nil] forCellReuseIdentifier:@"WXContactCell"];
    _tableView.tableFooterView = self.bottomView;
    [_makeSureButton addTarget:self action:@selector(makeSureAction) forControlEvents:UIControlEventTouchUpInside];
    _tableView.allowsMultipleSelection = YES;
    [self.view addSubview:self.topView];
    [self.view addSubview:_tableView];
    [_selectAllButton addTarget:self action:@selector(selectAllAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)makeSureAction {
    if (self.selectIndexArr.count > 0){
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSNumber *index in self.selectIndexArr) {
            int temp = index.intValue;
            FriendModel *model = self.modelArr[temp];
            [arr addObject:model.tgusetid];
        }
        [MineViewModel addFriendWithListWithFriendID:arr success:^(NSString * msg) {
            [MBProgressHUD showSuccess:@"邀请已发送"];
        } failure:^(NSError * error) {
            
        }];
    }
}
- (void)selectAllAction {
    if (self.selectIndexArr.count == _itemCount){
        //反选逻辑
        _selectAllButton.selected = false;
        [self.selectIndexArr removeAllObjects];
        _selectCountLabel.text = @"选中 ( 0 )";
        [_tableView reloadData];
        return;
    }
    //正选逻辑
    [self.selectIndexArr removeAllObjects];
    for (int i = 0;i < _itemCount;i++) {
        [_selectIndexArr addObject:[NSNumber numberWithInt:i]];
    }
    _selectCountLabel.text = [NSString stringWithFormat:@"全选 ( %d )",_itemCount];
    _selectAllButton.selected = true;
    [_tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_modelArr == nil){
        return 0;
    }
    return _modelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXContactCell" forIndexPath:indexPath];
    FriendModel *model = _modelArr[indexPath.row];
    cell.model = model;
    cell.selectionIcon.selected = [self.selectIndexArr containsObject:[NSNumber numberWithInteger:indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *currentNumber = [NSNumber numberWithInteger:indexPath.row];
    WXContactCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.selectIndexArr containsObject:currentNumber]){
        [self.selectIndexArr removeObject:currentNumber];
        cell.selectionIcon.selected = false;
    }else{
        [self.selectIndexArr addObject:currentNumber];
        cell.selectionIcon.selected = true;
    }
    if (self.selectIndexArr.count == _itemCount){
        _selectCountLabel.text = [NSString stringWithFormat:@"全选 ( %d )",_itemCount];
    }else{
        _selectCountLabel.text = [NSString stringWithFormat:@"选中 ( %lu )",(unsigned long)self.selectIndexArr.count];
    }
    //每次改变数组都要判断是否全选
    _selectAllButton.selected = self.selectIndexArr.count == _itemCount;
}
- (void)viewDidLayoutSubviews{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_equalTo(50);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.topView.mas_bottom);
    }];
}
//请求通讯录权限
#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                NSLog(@"授权失败");
                
            }else {
                NSLog(@"成功授权");
                //成功授权后调用通讯录
                [self openContact];
            }
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        [self openContact];
    }
    
}

//有通讯录权限-- 进行下一步操作
- (void)openContact{
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSMutableArray *phones = [NSMutableArray array];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSArray *phoneNumbers = contact.phoneNumbers;
        //        CNPhoneNumber  * cnphoneNumber = contact.phoneNumbers[0];
        
        //        NSString * phoneNumber = cnphoneNumber.stringValue;
        
        for (CNLabeledValue *labelValue in phoneNumbers) {
            //遍历一个人名下的多个电话号码
            
            //   NSString *    phoneNumber = labelValue.value;
            CNPhoneNumber *phoneNumber = labelValue.value;
            
            NSString * string = phoneNumber.stringValue ;
            
            //去掉电话中的特殊字符
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            [phones addObject:string];
//            NSLog(@"姓名=%@, 电话号码是=%@", nameStr, string);
            
        }
        
        //    *stop = YES; // 停止循环，相当于break；
        
    }];
    [self getFriendswithContactList:phones];
//    [self getFriendswithContactList:@[@"15608497699",@"17521574814",@"15608497659",@"15608497658",@"15755122783",@"15221027523",@"18917513635",@"17317322821",@"15755357580",@"18896702523",@"15067098209",@"13641920696",@"13162259222",@"13585527710",@"18818068610",@"15821199294",@"15021676019"]];
}
- (void)getFriendswithContactList:(NSArray *) phones{
    NSString *urlStr = [WXApiManager getRequestUrl:@"manKeepToken/selectUserFriends"];
    NSDictionary *params = @{@"tgusetaccount":phones,@"companytgusettgusetid":[WXAccountTool getUserID]};
    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
        if ([code isEqualToString:@"200"]){
            //成功
            NSArray *dataArray = (NSArray *)responseBody[@"data"];
            NSMutableArray *resultArr = [NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
                FriendModel *model = [FriendModel yy_modelWithDictionary:dic];
                [resultArr addObject:model];
            }
            self.modelArr = resultArr.copy;
            self.itemCount = resultArr.count;
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",responseBody[@"msg"]]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}



//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许竹简访问您的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
