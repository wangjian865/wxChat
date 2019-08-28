//
//  WXSingleViewController.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "WXSingleViewController.h"
#import "WKWebViewController.h"
#import "MMLocationViewController.h"
#import "EaseUsersListViewController.h"
#import "MMCommentInputView.h"
#import "MomentCell.h"
#import "MomentUtil.h"
#import "UIImage+ColorImage.h"
#import "WXNewMomentViewController.h"
#import "WXNewMomentMessageViewController.h"
#import "CompanyViewModel.h"
#import "MomentComent.h"
#import "UserCompanies.h"
#import "WXUserMomentInfoViewController.h"
#import "Enterprise.h"
@interface WXSingleViewController ()<UITableViewDelegate,UITableViewDataSource,UUActionSheetDelegate,MomentCellDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray * momentList;  // 朋友圈动态列表
@property (nonatomic, strong) MMTableView * tableView; // 表格
@property (nonatomic, strong) MMCommentInputView * commentInputView; // 评论输入框
@property (nonatomic, strong) MomentCell * operateCell; // 当前操作朋友圈动态
@property (nonatomic, strong) Comment * operateComment; // 当前操作评论
@property (nonatomic, strong) MUser * loginUser; // 当前用户
@property (nonatomic, strong) NSIndexPath * selectedIndexPath; // 当前评论indexPath
@property (nonatomic, assign) CGFloat keyboardHeight; // 键盘高度

//wdx's
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) Enterprise *myModel;
@property (nonatomic, strong) MomentComent *operateWXComment; // 当前操作评论
///"我"
@property (nonatomic, strong) UserCompanies *mine;
///page
@property (nonatomic, assign) int page;
@end

@implementation WXSingleViewController
- (UIImagePickerController *)imagePicker{
    if (_imagePicker == nil){
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"企业圈";
    _mine = [[UserCompanies alloc] init];
    _mine.tgusetName = [WXAccountTool getUserName];
    _mine.tgusetId = [WXAccountTool getUserID];
    _mine.tgusetImg = [WXAccountTool getUserImage];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //    [self configData];
    [self configUI];
    [self getMoments];
}
- (void)getMoments {
    [CompanyViewModel getMomentsDetailWithPriseid:_model.enterprisezid successBlock:^(Enterprise * _Nonnull model) {
        self.myModel = model;
        [self.tableView reloadData];
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
//获取到数据后对UI进行填充
- (void)setUIData {
    [_tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - UI
- (void)configUI
{
    // 表格
    MMTableView * tableView = [[MMTableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height-k_top_height)];
    tableView.showsVerticalScrollIndicator = false;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)viewDidLayoutSubviews{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
}

#pragma mark - 评论相关
- (void)addComment:(NSString *)commentText
{
    Enterprise *moment = self.operateCell.model;
    //创建评论
    MomentComent *wxComment = [[MomentComent alloc] init];
    wxComment.tgusetImg = _mine.tgusetImg;
    wxComment.commentsContext = commentText;
    wxComment.commentsTgusetName = _mine.tgusetName;
    wxComment.commentsTguset = _mine.tgusetId;
    if (self.operateWXComment){//存在操作的评论即回复某条评论 //区分对moment评论和对人评论
        wxComment.commentsTgusetHFName = self.operateWXComment.commentsTgusetName;
        wxComment.commentsTgusetHFId = self.operateWXComment.commentsTguset;
        //发布对评论的评论
        [CompanyViewModel commentToPersonWithContent:commentText commentOwnerId:moment.tgusetId priseid:moment.enterprisezId beCommentId:wxComment.commentsTgusetHFId beCommentName:wxComment.commentsTgusetHFName successBlock:^(NSString * _Nonnull successMsg) {
            NSLog(@"%@",successMsg);
            [self addCommentRefreshUI:wxComment];
        } failBlock:^(NSError * _Nonnull error) {
            
        }];
    }else{
        //WDX http
        //添加评论的请求
        [CompanyViewModel commentWithContent:commentText priseid:moment.enterprisezId successBlock:^(NSString * _Nonnull successMsg) {
            NSLog(@"%@",successMsg);
            [self addCommentRefreshUI:wxComment];
        } failBlock:^(NSError * _Nonnull error) {
            
        }];
    }
    
}
///评论插入视图操作  请求成功后调用
- (void)addCommentRefreshUI: (MomentComent *)wxComment{
    //评论插入
    NSMutableArray *commentList = [NSMutableArray arrayWithArray:self.operateCell.model.commes];
    [commentList addObject:wxComment];
    self.operateCell.model.commes = commentList;
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
    }];
}
// 滚动table
- (void)scrollForComment
{
    if (self.keyboardHeight > 0) {
        CGRect rect = [AppDelegate sharedInstance].convertRect;
        // 转换成window坐标
        rect = [self.tableView convertRect:rect toView:nil];
        CGFloat delta = self.commentInputView.ctTop - rect.origin.y - rect.size.height;
        CGFloat offsetY = self.tableView.contentOffset.y - delta;
        if (offsetY > 0){
            [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        }
    } else {
        if(self.selectedIndexPath.section == self.momentList.count - 1){
            [UIView performWithoutAnimation:^{
                [self.tableView scrollToBottomAnimated:NO];
            }];
        }
    }
}
#pragma mark - MomentCellDelegate
- (void)didOperateMoment:(MomentCell *)cell operateType:(MMOperateType)operateType;
{
    switch (operateType)
    {
        case MMOperateTypeProfile: // 用户详情
        {
            WXUserMomentInfoViewController * controller = [[WXUserMomentInfoViewController alloc] init];
            controller.userId = cell.model.tgusetId;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case MMOperateTypeDelete: // 删除
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 取消
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                Enterprise * moment = cell.model;
                [CompanyViewModel deleteMomentWithPriseid:moment.enterprisezId successBlock:^(NSString * _Nonnull successMsg) {
                    self.parents.refreshFlag = YES;
                    self.anoParents.refreshFlag = YES;
                    [self.navigationController popViewControllerAnimated:true];
                } failBlock:^(NSError * _Nonnull error) {
                    
                }];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case MMOperateTypeLocation: // 位置
        {
            MMLocationViewController * controller = [[MMLocationViewController alloc] init];
            controller.location = cell.moment.location;
            [self.navigationController pushViewController:controller animated:YES];
        }
        case MMOperateTypeLike: // 点赞
        {
            // data
            Enterprise * moment = cell.model;
            NSMutableArray<LikeListModel *> * likeList = [NSMutableArray arrayWithArray:moment.namelike];
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"enterpriseliketid = %@",_mine.tgusetId];
            NSArray *result = [likeList filteredArrayUsingPredicate:predicate];
            if ([result count]) {
                //存在
                LikeListModel *model = result.firstObject;
                [likeList removeObject:model];
                //取消点赞
                [CompanyViewModel deleteLikeMomentWithPriseid:moment.enterprisezId successBlock:^(NSString * _Nonnull successMsg) {
                    NSLog(@"%@",successMsg);
                } failBlock:^(NSError * _Nonnull error) {
                    
                }];
            } else { // 点赞
                LikeListModel *like = [[LikeListModel alloc] init];
                like.enterpriseliketid = _mine.tgusetId;
                like.enterpricelikename = _mine.tgusetName;
                like.tgusetimg = _mine.tgusetImg;
                [likeList addObject:like];
                //点赞
                [CompanyViewModel likeMomentWithPriseid:moment.enterprisezId successBlock:^(NSString * _Nonnull successMsg) {
                    NSLog(@"%@",successMsg);
                } failBlock:^(NSError * _Nonnull error) {
                    
                }];
            }
            moment.namelike = likeList.copy;
            // 刷新
            [self.momentList replaceObjectAtIndex:cell.tag withObject:moment];
            NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
            if (indexPath) {
                [UIView performWithoutAnimation:^{
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
            break;
        }
        case MMOperateTypeComment: // 添加评论
        {
            self.operateCell = cell;
            self.operateComment = nil;
            self.operateWXComment = nil;
            self.selectedIndexPath = [self.tableView indexPathForCell:cell];
            CGRect rect = [self.tableView rectForRowAtIndexPath:self.selectedIndexPath];
            [AppDelegate sharedInstance].convertRect = rect;
            self.commentInputView.comment = nil;
            [self.commentInputView show];
            break;
        }
        case MMOperateTypeFull: // 全文/收起
        {
            NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
            if (indexPath) {
                [UIView performWithoutAnimation:^{
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
            break;
        }
        default:
            break;
    }
}
///点击评论中的头像
- (void)didClickCommentIcon:(MomentComent *)wxComment{
    WXUserMomentInfoViewController * controller = [[WXUserMomentInfoViewController alloc] init];
    controller.userId = wxComment.commentsTguset;
    [self.navigationController pushViewController:controller animated:YES];
}
/// 选择评论
- (void)didOperateWxMoment:(MomentCell *)cell selectWxComment:(MomentComent *)wxComment{
    self.operateCell = cell;
    self.operateWXComment = wxComment;
    
    if (wxComment.commentsTguset == _mine.tgusetId) { // 删除自己的评论
        UUActionSheet * sheet = [[UUActionSheet alloc] initWithTitle:@"删除我的评论" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        sheet.tag = MMDelCommentTag;
        [sheet showInView:self.view.window];
    } else { // 回复评论
        self.selectedIndexPath = [self.tableView indexPathForCell:cell];
        self.commentInputView.WxComment = wxComment;
        [self.commentInputView show];
    }
}
///老的选择评论  已失效
- (void)didOperateMoment:(MomentCell *)cell selectComment:(Comment *)comment
{
    self.operateCell = cell;
    self.operateComment = comment;
    
    if (comment.fromUser.type == 1) { // 删除自己的评论
        UUActionSheet * sheet = [[UUActionSheet alloc] initWithTitle:@"删除我的评论" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        sheet.tag = MMDelCommentTag;
        [sheet showInView:self.view.window];
    } else { // 回复评论
        self.selectedIndexPath = [self.tableView indexPathForCell:cell];
        self.commentInputView.comment = comment;
        [self.commentInputView show];
    }
}
//点击点赞头像
- (void)didOperateMoment:(MomentCell *)cell selectLike:(LikeListModel *)like{
    /// 传一个id
    WXUserMomentInfoViewController * controller = [[WXUserMomentInfoViewController alloc] init];
    controller.userId = like.enterpriseliketid;
    [self.navigationController pushViewController:controller animated:YES];
}
// 点击高亮文字
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText
{
    switch (link.linkType)
    {
        case MLLinkTypeURL: // 链接
        {
            WKWebViewController * controller = [[WKWebViewController alloc] init];
            controller.url = linkText;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case MLLinkTypePhoneNumber: // 电话
        {
            UUActionSheet * sheet = [[UUActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@可能是一个电话号码，你可以",link.linkValue] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"呼叫" otherButtonTitles:@"复制号码",nil];
            sheet.tag = MMHandlePhoneTag;
            [sheet showInView:self.view.window];
            break;
        }
        case MLLinkTypeEmail: // 邮箱
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",linkText]]];
            break;
        }
        case MLLinkTypeOther: // 用户
        {
            //WDX 跳转用户详情页
            WXUserMomentInfoViewController * controller = [[WXUserMomentInfoViewController alloc] init];
            controller.userId = link.linkValue;
            [self.navigationController pushViewController:controller animated:YES];
            
            //            MMUserDetailViewController * controller = [[MMUserDetailViewController alloc] init];
            //            controller.user = user;
            //            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        default:
            break;
    }
}
#pragma mark - UUActionSheetDelegate
- (void)actionSheet:(UUActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == MMHandlePhoneTag) { // 电话
        NSString * title = actionSheet.title;
        NSString * subString = [title substringWithRange:NSMakeRange(0, [title length] - 13)];
        if (buttonIndex == 0) { // 拨打电话
            UIWebView * webView = [[UIWebView alloc] init];
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",subString]];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [self.view addSubview:webView];
        } else if (buttonIndex == 1) { // 复制
            [[UIPasteboard generalPasteboard] setPersistent:YES];
            [[UIPasteboard generalPasteboard] setValue:subString forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
        } else { // 取消
            
        }
    } else if (actionSheet.tag == MMDelCommentTag) { // 删除自己的评论
        if (buttonIndex == 0)
        {
            //删除评论请求
            [CompanyViewModel deleteCommentWithContentId:[NSString stringWithFormat:@"%d",self.operateWXComment.commentsId] successBlock:^(NSString * _Nonnull successMsg) {
                
                // 移除评论
                Enterprise * moment = self.operateCell.model;
                NSMutableArray * tempList = [NSMutableArray arrayWithArray:moment.commes];
                [tempList removeObject:self.operateWXComment];
                moment.commes = tempList;
                // 刷新
                [self.momentList replaceObjectAtIndex:self.operateCell.tag withObject:moment];
                NSIndexPath * indexPath = [self.tableView indexPathForCell:self.operateCell];
                if (indexPath) {
                    [UIView performWithoutAnimation:^{
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                              withRowAnimation:UITableViewRowAnimationNone];
                    }];
                }
                
            } failBlock:^(NSError * _Nonnull error) {
                
            }];
        } else { // 取消
            
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MomentCell1";
    MomentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 500, 0, 0);
    cell.tag = indexPath.row;
    cell.model = _myModel;
    //    cell.moment = [self.momentList objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 使用缓存行高，避免计算多次
    //    Moment * moment = [self.momentList objectAtIndex:indexPath.row];
    Enterprise *model = _myModel;
    
    return model.rowHeight;
}



#pragma mark - lazy load
- (MMCommentInputView *)commentInputView
{
    if (!_commentInputView) {
        _commentInputView = [[MMCommentInputView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        WS(wSelf);
        [_commentInputView setMMCompleteInputTextBlock:^(NSString *commentText) { // 完成文本输入
            [wSelf addComment:commentText];
        }];
        [_commentInputView setMMContainerWillChangeFrameBlock:^(CGFloat keyboardHeight) { // 输入框监听
            wSelf.keyboardHeight = keyboardHeight;
            [wSelf scrollForComment];
        }];
    }
    return _commentInputView;
}



@end
