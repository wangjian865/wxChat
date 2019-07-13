//
//  WXNewMomentMessageViewController.m
//  WXChat
//
//  Created by WX on 2019/7/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXNewMomentMessageViewController.h"
#import "WXNewMomentMessageViewCell.h"
@interface WXNewMomentMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *myView;
@end

@implementation WXNewMomentMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanBtn.backgroundColor = UIColor.clearColor;
    cleanBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cleanBtn setTitle:@"清空" forState:UIControlStateNormal];
    [cleanBtn addTarget:self action:@selector(cleanAll) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cleanBtn];
    [self setupUI];
}
- (void)cleanAll{
    NSLog(@"清空消息列表");
}
- (void)setupUI{
    _myView = [[UITableView alloc] init];
    [self.view addSubview:_myView];
    [_myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _myView.delegate = self;
    _myView.dataSource = self;
    _myView.rowHeight = 83;
    [_myView registerNib:[UINib nibWithNibName:@"WXNewMomentMessageViewCell" bundle:nil] forCellReuseIdentifier:@"newMomentMessageCell"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXNewMomentMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newMomentMessageCell" forIndexPath:indexPath];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        //删除事件
        
    }
}
@end