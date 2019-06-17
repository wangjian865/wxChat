//
//  ViewController.m
//  WXChat
//
//  Created by WDX on 2019/4/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (atomic) float kCloseCellHeight;
@property (atomic) float kOpenCellHeight;
@property (atomic) int kRowsCount;
@property (atomic) NSMutableArray* cellHeights;
@end
@implementation ViewController
- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height - k_top_height - k_bar_height) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.redColor;
        [_tableView registerNib:[UINib nibWithNibName:@"WXFoldingCell" bundle:nil] forCellReuseIdentifier:@"WXFoldingCell"];
    }
    return _tableView;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.kCloseCellHeight = 179;
    self.kOpenCellHeight = 488;
    self.kRowsCount = 8;
    self.cellHeights = [NSMutableArray array];
    
    for (int i = 0; i < self.kRowsCount; i++) {
        [self.cellHeights addObject:[NSNumber numberWithFloat:self.kCloseCellHeight]];
    }
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = self.kCloseCellHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIImage *patternImage = [UIImage imageNamed:@"background"];
    UIColor *patternColor = [UIColor colorWithPatternImage:patternImage];
    self.tableView.backgroundColor = patternColor;
    self.tableView.contentInset = UIEdgeInsetsMake(16, 0, 0, 0);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.kRowsCount;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor clearColor];
    NSNumber *height = [self.cellHeights objectAtIndex:indexPath.row];
    bool cellIsCollapsed = height.floatValue == self.kCloseCellHeight;
    if (cellIsCollapsed) {
        
        [(FoldingCell *)cell unfold:NO animated:NO completion:nil];
        //[(FoldingCell *) cell selectedAnimation:false animated:false completion: nil];
    } else {
        [(FoldingCell *)cell unfold:YES animated:NO completion:nil];
        //[(FoldingCell *) cell selectedAnimation:true animated:false completion: nil];
    }
    
    UIView *backgroundTopView = [cell viewWithTag:11];
    CALayer *backgroundTopViewLayer = backgroundTopView.layer;
    backgroundTopViewLayer.cornerRadius = 10;
    backgroundTopViewLayer.masksToBounds = YES;
    
    UILabel *closeNumberlabel = [cell viewWithTag:12];
    UILabel *openNumberLabel = [cell viewWithTag:13];
    
    NSString *text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    closeNumberlabel.text = text;
    openNumberLabel.text = text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXFoldingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXFoldingCell"];
    cell.backgroundColor = [UIColor clearColor];
    CALayer *layer = ((WXFoldingCell *) cell).foregroundView.layer;
    layer.cornerRadius = 10;
    layer.masksToBounds = YES;
    
    NSArray *durations = @[@0.26, @0.2, @0.2];
    [cell setDurationsForExpandedState:durations];
    [cell setDurationsForCollapsedState:durations];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = self.cellHeights[indexPath.row];
    return height.floatValue;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FoldingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.isAnimating) {
        return;
    }
    
    double duration = 0;
    NSNumber *height = [self.cellHeights objectAtIndex:indexPath.row];
    bool cellIsCollapsed = height.floatValue == self.kCloseCellHeight;
    if (cellIsCollapsed) {
        [self.cellHeights setObject:[NSNumber numberWithFloat:self.kOpenCellHeight] atIndexedSubscript:indexPath.row];
        //[cell selectedAnimation:true animated:true completion: nil];
        [cell unfold:YES animated:YES completion:nil];
        duration = 0.5;
    } else {
        [self.cellHeights setObject:[NSNumber numberWithFloat:self.kCloseCellHeight] atIndexedSubscript:indexPath.row];
        //[cell selectedAnimation:false animated:true completion: nil];
        [cell unfold:NO animated:YES completion:nil];
        duration = 0.8;
    }
    
    [UIView animateWithDuration:duration delay:0 options:0 animations:^{
        [tableView beginUpdates];
        [tableView endUpdates];
    } completion:nil];
    
}
@end
