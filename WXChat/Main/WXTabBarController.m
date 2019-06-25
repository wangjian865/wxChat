//
//  WXTabBarController.m
//  WXChat
//
//  Created by WDX on 2019/4/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXTabBarController.h"
#import "WXNavigationController.h"
#import "WXChat-Swift.h"
#import "WXUsersListViewController.h"
#define Controller_First         @"WXConversationListViewController"
#define Controller_Second        @"WXMailListViewController"
#define Controller_Third         @"DiscoverViewController"
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
        _titleArray = @[@"消息",@"邮件",@"简问",@"人脉"];
    }
    return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;
    [self setUpAllChildVC];
}

- (void)setUpAllChildVC{
    
    for (NSInteger index = 0; index < 4; index++) {
        NSString *className = [self.childControllerArray objectAtIndex:index];
        UIViewController *childVC;
        if ([className isEqualToString:@"WXUsersListViewController"]){
            childVC = [[WXUsersListViewController alloc] init];
            ((WXUsersListViewController *)childVC).isEditing = NO;
        }else if([className isEqualToString:@"LoinController"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            childVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        }else{
            childVC = [[NSClassFromString(className)alloc]init];
        }
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
    
    VC.navigationItem.title = navTitle;
    [self addChildViewController:navC];
}
@end
