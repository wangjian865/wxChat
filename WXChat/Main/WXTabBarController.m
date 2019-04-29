//
//  WXTabBarController.m
//  WXChat
//
//  Created by WDX on 2019/4/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXTabBarController.h"
#import "WXNavigationController.h"
#define Controller_First         @"WXConversationListViewController"
#define Controller_Second        @"EaseUsersListViewController"
#define Controller_Third         @"EaseViewController"
#define Controller_Fourth        @"ViewController"
@interface WXTabBarController ()
/**
 * 控制器集合
 */
@property (nonatomic, strong) NSArray *childControllerArray;
/**
 * tabbar选中图标
 */
@property (nonatomic, strong) NSArray *selectedImageArray;
/**
 * 未选中
 */
@property (nonatomic, strong) NSArray *normalImageArray;
/**
 * tabbar标题
 */
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation WXTabBarController

- (NSArray *)childControllerArray {
    if (_childControllerArray == nil){
        _childControllerArray = @[Controller_First,Controller_Second,Controller_Third,Controller_Fourth];
    }
    return _childControllerArray;
}
-(NSArray *)selectedImageArray{
    if (_selectedImageArray == nil) {
        _selectedImageArray = [[NSMutableArray alloc] initWithObjects:@"tabar_message_sel",@"tabbar_maillist_sel",@"tabbar_work_sel",@"tabbar_mine_sel",nil];
    }
    return _selectedImageArray;
}
-(NSArray *)normalImageArray{
    if (_normalImageArray == nil) {
        _normalImageArray = @[@"tabbar_message",@"tabbar_maillist",@"tabbar_work",@"tabbar_mine"];
    }
    return _normalImageArray;
}
-(NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@"消息",@"通讯录",@"朋友圈",@"我的"];
    }
    return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self setUpAllChildVC];
}

- (void)setUpAllChildVC{
    
    for (NSInteger index = 0; index < 4; index++) {
        
        UIViewController *childVC = [[NSClassFromString([self.childControllerArray objectAtIndex:index])alloc]init];
        [self setUpChildViewController:childVC
                                     image:[self.normalImageArray objectAtIndex:index]
                               selectImage:[self.selectedImageArray objectAtIndex:index]
                                     title:[self.titleArray objectAtIndex:index] navTitle:[self.titleArray objectAtIndex:index]];
    }
    
}
/**
 *  添加一个子控制器的方法
 */
- (void)setUpChildViewController:(UIViewController *)VC image:(NSString *)image  selectImage:(NSString *)selectImage title:(NSString *)title navTitle:(NSString *)navTitle{
    
    WXNavigationController *navC = [[WXNavigationController alloc]initWithRootViewController:VC];
    navC.title = title;
    navC.tabBarItem.image = [UIImage imageNamed:image];
    navC.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:rgb(21, 104, 200)} forState:UIControlStateSelected];
    
    //    [navC.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    
    VC.navigationItem.title = navTitle;
    [self addChildViewController:navC];
}
@end
