//
//  WXFriendViewController.m
//  WXChat
//
//  Created by WDX on 2019/4/30.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXFriendViewController.h"

@interface WXFriendViewController ()
/**
 * 动画layer
 */
@property (nonatomic, strong) CALayer *myLayer;
@end

@implementation WXFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _myLayer = [[CALayer alloc] init];
    _myLayer.bounds = CGRectMake(0, 0, 50, 50);
    _myLayer.backgroundColor = [UIColor redColor].CGColor;
    _myLayer.position = CGPointMake(50, 50);
    _myLayer.anchorPoint = CGPointMake(0, 0);
    [self.view.layer addSublayer:_myLayer];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //1.创建核心动画
    CABasicAnimation *anima = [CABasicAnimation animation];
    
    //1.1告诉系统要执行什么样的动画
    anima.keyPath=@"position";
    //设置通过动画，将layer从哪儿移动到哪儿
    anima.fromValue=[NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anima.toValue=[NSValue valueWithCGPoint:CGPointMake(200, 300)];
    
    //1.2设置动画执行完毕之后不删除动画
    anima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    anima.fillMode=kCAFillModeForwards;
    //2.添加核心动画到layer
    [self.myLayer addAnimation:anima forKey:nil];
}
@end
