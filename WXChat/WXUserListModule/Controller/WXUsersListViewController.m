//
//  WXUsersListViewController.m
//  WXChat
//
//  Created by WDX on 2019/5/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXUsersListViewController.h"

@interface WXUsersListViewController ()<EMUserListViewControllerDelegate,EMUserListViewControllerDataSource>

@end

@implementation WXUsersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.dataSource = self;
    self.delegate = self;
}
// delegate
- (void)userListViewController:(EaseUsersListViewController *)userListViewController
            didSelectUserModel:(id<IUserModel>)userModel{
    
}
// dataSource
- (NSInteger)numberOfRowInUserListViewController:(EaseUsersListViewController *)userListViewController;{
    return 2;
}
@end
