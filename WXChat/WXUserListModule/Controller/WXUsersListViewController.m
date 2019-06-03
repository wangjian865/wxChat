//
//  WXUsersListViewController.m
//  WXChat
//
//  Created by WDX on 2019/5/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXUsersListViewController.h"
#import "UIImage+ColorImage.h"
@interface WXUsersListViewController ()<EMUserListViewControllerDelegate,EMUserListViewControllerDataSource,UISearchControllerDelegate>
/**
 * 搜索框
 */
@property (nonatomic, strong) UISearchController *serachController;
@end

@implementation WXUsersListViewController
#pragma mark -- getter
- (UISearchController *)serachController{
    if (_serachController == nil){
        UIViewController *resultVC = [[UIViewController alloc] init];
        resultVC.view.backgroundColor = UIColor.redColor;
        _serachController = [[UISearchController alloc] initWithSearchResultsController:resultVC];
        self.definesPresentationContext = YES;
        _serachController.view.backgroundColor = UIColor.whiteColor;
        _serachController.searchBar.placeholder = @"搜索";
        // 默认为YES,设置开始搜索时背景显示与否
        _serachController.dimsBackgroundDuringPresentation = YES;
        // 默认为YES,控制搜索时，是否隐藏导航栏
        _serachController.hidesNavigationBarDuringPresentation = YES;
        _serachController.delegate = self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.dataSource = self;
    self.delegate = self;
    [self.tableView setTableHeaderView:self.serachController.searchBar];
}
// delegate
//- (void)userListViewController:(EaseUsersListViewController *)userListViewController
//            didSelectUserModel:(id<IUserModel>)userModel{
//    
//}
// dataSource
//- (NSInteger)numberOfRowInUserListViewController:(EaseUsersListViewController *)userListViewController;{
//    return 2;
//}
//- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
//                   userModelForIndexPath:(NSIndexPath *)indexPath{
//
//}

- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                           modelForBuddy:(NSString *)buddy
{
    //用户可以根据自己的用户体系，根据buddy设置用户昵称和头像
    id<IUserModel> model = nil;
    model = [[EaseUserModel alloc] initWithBuddy:buddy];
    return model;
}

#pragma mark -- SerachController Delegate
- (void)willPresentSearchController:(UISearchController *)searchController{
    
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    NSLog(@"didPresentSearchController");
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    NSLog(@"didDismissSearchController");
}

// Called after the search controller's search bar has agreed to begin editing or when 'active' is set to YES. If you choose not to present the controller yourself or do not implement this method, a default presentation is performed on your behalf.
- (void)presentSearchController:(UISearchController *)searchController{
    NSLog(@"presentSearchController");
}
@end
