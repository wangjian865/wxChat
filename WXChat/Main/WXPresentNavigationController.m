//
//  WXPresentNavigationController.m
//  WXChat
//
//  Created by WDX on 2019/6/3.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXPresentNavigationController.h"

@interface WXPresentNavigationController ()

@end

@implementation WXPresentNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
//    self.navigationBar.barTintColor = rgb(48, 134, 191);
    self.navigationBar.barTintColor = rgb(237, 237, 237);
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor,
                                                 NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
}

@end
