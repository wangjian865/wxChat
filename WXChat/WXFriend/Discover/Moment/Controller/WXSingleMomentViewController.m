//
//  WXSingleMomentViewController.m
//  WXChat
//
//  Created by WX on 2019/8/5.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXSingleMomentViewController.h"

@interface WXSingleMomentViewController ()

@end
// 最大高度限制
CGFloat maxLimitHeight = 0;
CGFloat lineSpacing = 5;
@implementation WXSingleMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    [self getData];
}

- (void)getData {
    [CompanyViewModel getMomentsDetailWithPriseid:_model.enterprisezid successBlock:^(Enterprise * _Nonnull model) {
        NSLog(@"1");
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI {
    [self configUI];
}

- (void)configUI
{
    WS(wSelf);
    // 头像视图
    _avatarImageView = [[MMImageView alloc] initWithFrame:CGRectMake(14, kBlank, kAvatarWidth, kAvatarWidth)];
    _avatarImageView.cornerRadius = kAvatarWidth/2;
    [_avatarImageView setClickHandler:^(MMImageView *imageView) {
//        if ([wSelf.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
//            [wSelf.delegate didOperateMoment:wSelf operateType:MMOperateTypeProfile];
//        }
//        [wSelf resetMenuView];
    }];
    [self.view addSubview:_avatarImageView];
    // 名字视图
    _nicknameBtn = [[UIButton alloc] init];
    _nicknameBtn.tag = MMOperateTypeProfile;
    _nicknameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _nicknameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_nicknameBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_nicknameBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nicknameBtn];
    //公司视图
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.font = [UIFont systemFontOfSize:14];
    _companyLabel.textColor = rgb(102, 102, 102);
    [self.view addSubview:_companyLabel];
    
    // 正文视图 ↓↓
    _linkLabel = kMLLinkLabel(YES);
    _linkLabel.font = kTextFont;
    _linkLabel.delegate = self;
    [self.view addSubview:_linkLabel];
    // 查看'全文'按钮
    _showAllBtn = [[UIButton alloc] init];
    _showAllBtn.tag = MMOperateTypeFull;
    _showAllBtn.titleLabel.font = kTextFont;
    [_showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_showAllBtn setTitle:@"收起" forState:UIControlStateSelected];
    [_showAllBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showAllBtn];
    [_showAllBtn sizeToFit];
    // 图片区
    _imageListView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    [_imageListView setSingleTapHandler:^(MMImageView *imageView) {
//        [wSelf resetMenuView];
    }];
    [self.view addSubview:_imageListView];
    // 位置视图
    _locationBtn = [[UIButton alloc] init];
    _locationBtn.tag = MMOperateTypeLocation;
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_locationBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_locationBtn];
    // 时间视图
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = MMRGBColor(110.f, 110.f, 110.f);
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:_timeLabel];
    // 删除视图
    _deleteBtn = [[UIButton alloc] init];
    _deleteBtn.tag = MMOperateTypeDelete;
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteBtn];
    // 评论视图
    _bgImageView = [[UIImageView alloc] init];
    [self.view addSubview:_bgImageView];
    _commentView = [[UIView alloc] init];
    _commentView.backgroundColor = rgb(245, 245, 245);
    [self.view addSubview:_commentView];
    // 操作视图
    _menuView = [[MMOperateMenuView alloc] initWithFrame:CGRectZero];
    [_menuView setOperateMenu:^(MMOperateType operateType) { // 评论|赞
//        if ([wSelf.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
//            [wSelf.delegate didOperateMoment:wSelf operateType:operateType];
//        }
    }];
    [self.view addSubview:_menuView];
    // 最大高度限制
//    maxLimitHeight = (_linkLabel.font.lineHeight + lineSpacing) * 6;
}

- (void)setModel:(Enterprise *)model{
//    _model = model;
//    //判断是不是自己的朋友圈,如果是自己的则显示删除按钮
////    [_deleteBtn setHidden:!(model.tgusetId == [WXAccountTool getUserID])];
//    //头像
//    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.tgusetImg] placeholderImage:nil];
//    // 昵称
//    [_nicknameBtn setTitle:model.tgusetName forState:UIControlStateNormal];
//    if (_nicknameBtn.width > kTextWidth) {
//        _nicknameBtn.width = kTextWidth;
//    }
//    [_nicknameBtn sizeToFit];
//    _nicknameBtn.frame = CGRectMake(_avatarImageView.right + 10, _avatarImageView.top, _nicknameBtn.width, 20);
//    // 公司
//    _companyLabel.text = model.tgusetCompany;
//    [_companyLabel sizeToFit];
//    _companyLabel.frame = CGRectMake(_nicknameBtn.mj_x, _nicknameBtn.bottom + 8, _companyLabel.width, _companyLabel.height);
//    // 正文
//    _showAllBtn.hidden = YES;
//    _linkLabel.hidden = YES;
//    CGFloat bottom = _avatarImageView.bottom + 15;
//    CGFloat rowHeight = 0;
//    if ([model.enterprisezContent length])
//    {
//        _linkLabel.hidden = NO;
//        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
//        style.lineSpacing = lineSpacing;
//        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:model.enterprisezContent];
//        [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,[model.enterprisezContent length])];
//        _linkLabel.attributedText = attributedText;
//        // 判断显示'全文'/'收起'
//        CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
//        CGFloat labHeight = attrStrSize.height;
////        if (labHeight > maxLimitHeight) {
////            if (!_moment.isFullText) {
////                labHeight = maxLimitHeight;
////            }
////            _showAllBtn.hidden = NO;
////            _showAllBtn.selected = _moment.isFullText;
////        }
//        _linkLabel.frame = CGRectMake(_avatarImageView.left, bottom, attrStrSize.width, labHeight);
//        _showAllBtn.frame = CGRectMake(_avatarImageView.left, _linkLabel.bottom + kArrowHeight, _showAllBtn.width, kMoreLabHeight);
//        if (_showAllBtn.hidden) {
//            bottom = _linkLabel.bottom + kPaddingValue;
//        } else {
//            bottom = _showAllBtn.bottom + kPaddingValue;
//        }
//        // 添加长按手势
//        if (!_longPress) {
//            _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
//        }
//        [_linkLabel addGestureRecognizer:_longPress];
//    }
//    // 图片
//    NSArray *imageArr = [model.enterprisezfujina componentsSeparatedByString:@","];
//    _imageListView.imageArr = imageArr;
//    if ([imageArr count] > 0) {
//        _imageListView.origin = CGPointMake(_avatarImageView.left, bottom);
//        bottom = _imageListView.bottom + kPaddingValue;
//    }
//    // 位置和时间
//    //    _timeLabel.text = [Utility getMomentTime:moment.time];
//    _timeLabel.text = [Utility getMomentTime:model.enterprisezTime];
//    [_timeLabel sizeToFit];
//    //    if (moment.location) {
//    //        [_locationBtn setTitle:moment.location.position forState:UIControlStateNormal];
//    //        [_locationBtn sizeToFit];
//    //        _locationBtn.hidden = NO;
//    //        _locationBtn.frame = CGRectMake(_avatarImageView.left, bottom, _locationBtn.width, kTimeLabelH);
//    //        bottom = _locationBtn.bottom + kPaddingValue;
//    //    } else {
//    _locationBtn.hidden = YES;
//    //    }
//    _timeLabel.frame = CGRectMake(_avatarImageView.left, bottom, _timeLabel.width, kTimeLabelH);
//    _deleteBtn.frame = CGRectMake(_timeLabel.right + 25, _timeLabel.top, 30, kTimeLabelH);
//    bottom = _timeLabel.bottom + kPaddingValue;
//    // 操作视图
//    _menuView.frame = CGRectMake(k_screen_width-kOperateWidth-10, _timeLabel.top-(kOperateHeight-kTimeLabelH)/2, kOperateWidth, kOperateHeight);
//    _menuView.show = NO;
//    //    _menuView.isLike = moment.isLike;
//    _menuView.isLike = false;
//    // 处理评论/赞
//    _commentView.frame = CGRectZero;
//    _bgImageView.frame = CGRectZero;
//    _bgImageView.image = nil;
//    [_commentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 处理赞
//    CGFloat top = 0;
//    CGFloat width = k_screen_width - kRightMargin - _avatarImageView.left;
//    if ([model.namelike count]){
//        UIView *likeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 48)];
//        CGFloat iconX = 30;
//        //idx增加后增加的x
//        CGFloat marginWidth = 40;
//        //这里需要加一个点赞图标
//        [model.namelike enumerateObjectsUsingBlock:^(LikeListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            MMImageView *iconLike = [[MMImageView alloc] initWithFrame:CGRectMake(iconX + marginWidth * idx, 8, kLikeIconWidth, kLikeIconWidth)];
//            WS(wSelf);
//            [iconLike setClickHandler:^(MMImageView *imageView) {
////                if ([wSelf.delegate respondsToSelector:@selector(didOperateMoment:selectLike:)]) {
////                    [wSelf.delegate didOperateMoment:wSelf selectLike:obj];
////                }
//            }];
//            iconLike.cornerRadius = kLikeIconWidth/2;
//            iconLike.backgroundColor = UIColor.grayColor;
//            //点赞模型缺图片
//            [iconLike sd_setImageWithURL:[NSURL URLWithString:obj.tgusetimg]];
//            [likeView addSubview:iconLike];
//        }];
//        
//        [_commentView addSubview:likeView];
//        // 分割线
//        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, likeView.bottom, width, 0.5)];
//        line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
//        [_commentView addSubview:line];
//        top = 48;
//    }
    
    // 处理评论
//    NSInteger count = [model.commes count];
//    for (NSInteger i = 0; i < count; i ++) {
//        CommentLabel * label = [[CommentLabel alloc] initWithFrame:CGRectMake(0, top, width, 0)];
//        label.wxComment = [model.commes objectAtIndex:i];
//        // 点击评论
//        
//        [label setDidClickText:^(MomentComent *comment) {
//            // 当前moment相对tableView的frame
//            CGRect rect = [[label superview] convertRect:label.frame toView:self.superview];
//            [AppDelegate sharedInstance].convertRect = rect;
//            if ([self.delegate respondsToSelector:@selector(didOperateWxMoment:selectWxComment:)]){
//                [self.delegate didOperateWxMoment:self selectWxComment:comment];
//            }
//            //            if ([self.delegate respondsToSelector:@selector(didOperateMoment:selectComment:)]) {
//            //                [self.delegate didOperateMoment:self selectComment:comment];
//            //
//            //            }
//            [self resetMenuView];
//        }];
//        // 点击高亮
//        [label setDidClickLinkText:^(MLLink *link, NSString *linkText) {
////            if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:)]) {
////                [self.delegate didClickLink:link linkText:linkText];
////            }
//            [self resetMenuView];
//        }];
//        //点击头像
//        [label setDidClickUserIcon:^(MomentComent *comment) {
////            if ([self.delegate respondsToSelector:@selector(didClickCommentIcon:)]){
////                [self.delegate didClickCommentIcon:comment];
////            }
//        }];
//        [_commentView addSubview:label];
//        // 更新
//        top += label.height;
//    }
//    // 更新UI
//    if (top > 0) {
//        _bgImageView.frame = CGRectMake(_nicknameBtn.left, bottom, width, top + kArrowHeight);
//        _bgImageView.image = [[UIImage imageNamed:@"comment_bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
//        _commentView.frame = CGRectMake(_avatarImageView.left, bottom + kArrowHeight, width, top);
//        rowHeight = _commentView.bottom + kBlank;
//    } else {
//        rowHeight = _timeLabel.bottom + kBlank;
//    }
//    // 这样做就是起到缓存行高的作用，省去重复计算!!!
//    model.rowHeight = rowHeight;
}

@end
