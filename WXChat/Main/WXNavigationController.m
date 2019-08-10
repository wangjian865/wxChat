//
//  WXNavigationController.m
//  WXChat
//
//  Created by WDX on 2019/4/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXNavigationController.h"

@interface WXNavigationController ()

@end

@implementation WXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
//    self.navigationBar.barTintColor = rgb(48, 134, 191);
    self.navigationBar.barTintColor = rgb(74, 133, 186);
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    [self.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //设置非根控制器的内容
    if (self.childViewControllers.count) { // 不是根控制器
        viewController.hidesBottomBarWhenPushed = YES ;
        UIImage *image = [[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    }
    [super pushViewController:viewController animated:animated];
}
- (void)backAction{
    [self popViewControllerAnimated:YES];
}
@end
