//
//  WXAddFriendViewController.m
//  WXChat
//
//  Created by WDX on 2019/6/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXAddFriendViewController.h"
#import "UIImage+ColorImage.h"
@interface WXAddFriendViewController ()<UISearchControllerDelegate>
/**
 * textfield
 */
@property (nonatomic, strong) UITextField *textField;
/**
 * 搜索框
 */
@property (nonatomic, strong) UISearchController *serachController;
/**
 * tableView
 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WXAddFriendViewController
- (UISearchController *)serachController{
    if (_serachController == nil){
        _serachController = [[UISearchController alloc] init];
        self.definesPresentationContext = YES;
        _serachController.view.backgroundColor = UIColor.whiteColor;
        _serachController.searchBar.placeholder = @"搜索";
        // 默认为YES,设置开始搜索时背景显示与否
        _serachController.dimsBackgroundDuringPresentation = YES;
        // 默认为YES,控制搜索时，是否隐藏导航栏
        _serachController.hidesNavigationBarDuringPresentation = YES;
        _serachController.delegate = self;
        //searchController.view添加提示试图
        UISearchBar *bar = _serachController.searchBar;
        bar.barStyle = UISearchBarStyleDefault;
        [bar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        //输入框背景色
        for(UIView *subview in bar.subviews[0].subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
            {
                subview.backgroundColor = rgb(237,237,239);
                break;
            }
        }
    }
    return _serachController;
}
- (UITableView *)tableView{
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    self.view.backgroundColor = k_background_color;
    [self setupUI];
}
- (void)setType:(WXAddVCType)type{
    _type = type;
    switch (type) {
            case 0:
                self.title = @"添加好友";
            break;
            case 1:
                self.title = @"加入群组";
            break;
        default:
            break;
    }
}
- (void)setupUI{
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@14);
        make.left.right.equalTo(@0);
        make.height.equalTo(@42);
    }];
    
    //放大镜图片
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"magnifying_glass"]];
    [containerView addSubview:iconView];
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"输入对方的手机号";
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.textColor = rgb(51,51,51);
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.keyboardType = UIKeyboardTypePhonePad;
    [_textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [containerView addSubview:_textField];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).offset(23);
        make.centerY.equalTo(containerView);
        make.width.height.equalTo(@14);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(16);
        make.centerY.equalTo(containerView);
        make.right.offset(-30);
    }];
}


-(void)changedTextField:(id)textField{
    if (_textField.text.length == 11){
        if ([WXValidationTool validateCellPhoneNumber:_textField.text]){
            //网络请求
        }else{
            [MBProgressHUD showError:@"手机号不合法"];
        }
    }
}
@end

