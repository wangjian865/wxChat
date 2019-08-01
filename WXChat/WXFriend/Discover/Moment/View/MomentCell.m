//
//  MomentCell.m
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentCell.h"

#pragma mark - ------------------ 动态 ------------------

// 最大高度限制
CGFloat maxLimitHeight = 0;
CGFloat lineSpacing = 5;

@implementation MomentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
        // 观察者
        [kNotificationCenter addObserver:self
                                selector:@selector(resetMenuView)
                                    name:@"ResetMenuView"
                                  object:nil];
        [kNotificationCenter addObserver:self
                                selector:@selector(resetLinkLabel)
                                    name:UIMenuControllerWillHideMenuNotification
                                  object:nil];
    }
    return self;
}

- (void)configUI
{
    WS(wSelf);
    // 头像视图
    _avatarImageView = [[MMImageView alloc] initWithFrame:CGRectMake(14, kBlank, kAvatarWidth, kAvatarWidth)];
    _avatarImageView.cornerRadius = kAvatarWidth/2;
    [_avatarImageView setClickHandler:^(MMImageView *imageView) {
        if ([wSelf.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [wSelf.delegate didOperateMoment:wSelf operateType:MMOperateTypeProfile];
        }
        [wSelf resetMenuView];
    }];
    [self.contentView addSubview:_avatarImageView];
    // 名字视图
    _nicknameBtn = [[UIButton alloc] init];
    _nicknameBtn.tag = MMOperateTypeProfile;
    _nicknameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _nicknameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_nicknameBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_nicknameBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_nicknameBtn];
    //公司视图
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.font = [UIFont systemFontOfSize:14];
    _companyLabel.textColor = rgb(102, 102, 102);
    [self.contentView addSubview:_companyLabel];
    
    // 正文视图 ↓↓
    _linkLabel = kMLLinkLabel(YES);
    _linkLabel.font = kTextFont;
    _linkLabel.delegate = self;
    [self.contentView addSubview:_linkLabel];
    // 查看'全文'按钮
    _showAllBtn = [[UIButton alloc] init];
    _showAllBtn.tag = MMOperateTypeFull;
    _showAllBtn.titleLabel.font = kTextFont;
    [_showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_showAllBtn setTitle:@"收起" forState:UIControlStateSelected];
    [_showAllBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showAllBtn];
    [_showAllBtn sizeToFit];
    // 图片区
    _imageListView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    [_imageListView setSingleTapHandler:^(MMImageView *imageView) {
        [wSelf resetMenuView];
    }];
    [self.contentView addSubview:_imageListView];
    // 位置视图
    _locationBtn = [[UIButton alloc] init];
    _locationBtn.tag = MMOperateTypeLocation;
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_locationBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_locationBtn];
    // 时间视图
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = MMRGBColor(110.f, 110.f, 110.f);
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_timeLabel];
    // 删除视图
    _deleteBtn = [[UIButton alloc] init];
    _deleteBtn.tag = MMOperateTypeDelete;
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    // 评论视图
    _bgImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bgImageView];
    _commentView = [[UIView alloc] init];
    _commentView.backgroundColor = rgb(245, 245, 245);
    [self.contentView addSubview:_commentView];
    // 操作视图
    _menuView = [[MMOperateMenuView alloc] initWithFrame:CGRectZero];
    [_menuView setOperateMenu:^(MMOperateType operateType) { // 评论|赞
        if ([wSelf.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [wSelf.delegate didOperateMoment:wSelf operateType:operateType];
        }
    }];
    [self.contentView addSubview:_menuView];
    // 最大高度限制
    maxLimitHeight = (_linkLabel.font.lineHeight + lineSpacing) * 6;
}
#pragma mark - wx modelSetter
- (void)setModel:(Enterprise *)model{
    _model = model;
    //判断是不是自己的朋友圈,如果是自己的则显示删除按钮
    [_deleteBtn setHidden:!(model.tgusetId == [WXAccountTool getUserID])];
    //头像
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.tgusetImg] placeholderImage:nil];
    // 昵称
    [_nicknameBtn setTitle:model.tgusetName forState:UIControlStateNormal];
    if (_nicknameBtn.width > kTextWidth) {
        _nicknameBtn.width = kTextWidth;
    }
    [_nicknameBtn sizeToFit];
    _nicknameBtn.frame = CGRectMake(_avatarImageView.right + 10, _avatarImageView.top, _nicknameBtn.width, 20);
    // 公司
    _companyLabel.text = model.tgusetCompany;
    [_companyLabel sizeToFit];
    _companyLabel.frame = CGRectMake(_nicknameBtn.mj_x, _nicknameBtn.bottom + 8, _companyLabel.width, _companyLabel.height);
    // 正文
    _showAllBtn.hidden = YES;
    _linkLabel.hidden = YES;
    CGFloat bottom = _avatarImageView.bottom + 15;
    CGFloat rowHeight = 0;
    if ([model.enterprisezContent length])
    {
        _linkLabel.hidden = NO;
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = lineSpacing;
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:model.enterprisezContent];
        [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,[model.enterprisezContent length])];
        _linkLabel.attributedText = attributedText;
        // 判断显示'全文'/'收起'
        CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
        CGFloat labHeight = attrStrSize.height;
        if (labHeight > maxLimitHeight) {
            if (!_moment.isFullText) {
                labHeight = maxLimitHeight;
            }
            _showAllBtn.hidden = NO;
            _showAllBtn.selected = _moment.isFullText;
        }
        _linkLabel.frame = CGRectMake(_avatarImageView.left, bottom, attrStrSize.width, labHeight);
        _showAllBtn.frame = CGRectMake(_avatarImageView.left, _linkLabel.bottom + kArrowHeight, _showAllBtn.width, kMoreLabHeight);
        if (_showAllBtn.hidden) {
            bottom = _linkLabel.bottom + kPaddingValue;
        } else {
            bottom = _showAllBtn.bottom + kPaddingValue;
        }
        // 添加长按手势
        if (!_longPress) {
            _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        }
        [_linkLabel addGestureRecognizer:_longPress];
    }
    // 图片
    NSArray *imageArr = [model.tgusetImg componentsSeparatedByString:@","];
    _imageListView.imageArr = imageArr;
    if ([imageArr count] > 0) {
        _imageListView.origin = CGPointMake(_avatarImageView.left, bottom);
        bottom = _imageListView.bottom + kPaddingValue;
    }
    // 位置和时间
//    _timeLabel.text = [Utility getMomentTime:moment.time];
    _timeLabel.text = model.enterprisezTime;
    [_timeLabel sizeToFit];
//    if (moment.location) {
//        [_locationBtn setTitle:moment.location.position forState:UIControlStateNormal];
//        [_locationBtn sizeToFit];
//        _locationBtn.hidden = NO;
//        _locationBtn.frame = CGRectMake(_avatarImageView.left, bottom, _locationBtn.width, kTimeLabelH);
//        bottom = _locationBtn.bottom + kPaddingValue;
//    } else {
        _locationBtn.hidden = YES;
//    }
    _timeLabel.frame = CGRectMake(_avatarImageView.left, bottom, _timeLabel.width, kTimeLabelH);
    _deleteBtn.frame = CGRectMake(_timeLabel.right + 25, _timeLabel.top, 30, kTimeLabelH);
    bottom = _timeLabel.bottom + kPaddingValue;
    // 操作视图
    _menuView.frame = CGRectMake(k_screen_width-kOperateWidth-10, _timeLabel.top-(kOperateHeight-kTimeLabelH)/2, kOperateWidth, kOperateHeight);
    _menuView.show = NO;
//    _menuView.isLike = moment.isLike;
    _menuView.isLike = false;
    // 处理评论/赞
    _commentView.frame = CGRectZero;
    _bgImageView.frame = CGRectZero;
    _bgImageView.image = nil;
    [_commentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 处理赞
    CGFloat top = 0;
    CGFloat width = k_screen_width - kRightMargin - _avatarImageView.left;
    if ([model.namelike count]){
        UIView *likeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 48)];
        CGFloat iconX = 30;
        //idx增加后增加的x
        CGFloat marginWidth = 40;
        //这里需要加一个点赞图标
        [model.namelike enumerateObjectsUsingBlock:^(LikeListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MMImageView *iconLike = [[MMImageView alloc] initWithFrame:CGRectMake(iconX + marginWidth * idx, 8, kLikeIconWidth, kLikeIconWidth)];
            WS(wSelf);
            [iconLike setClickHandler:^(MMImageView *imageView) {
                if ([wSelf.delegate respondsToSelector:@selector(didOperateMoment:selectLike:)]) {
                    [wSelf.delegate didOperateMoment:wSelf selectLike:obj];
                }
            }];
            iconLike.cornerRadius = kLikeIconWidth/2;
            iconLike.backgroundColor = UIColor.grayColor;
            //点赞模型缺图片
            [iconLike sd_setImageWithURL:[NSURL URLWithString:@""]];
            [likeView addSubview:iconLike];
        }];
        
        [_commentView addSubview:likeView];
        // 分割线
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, likeView.bottom, width, 0.5)];
        line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        [_commentView addSubview:line];
        top = 48;
    }
    
    // 处理评论
    NSInteger count = [model.commes count];
    for (NSInteger i = 0; i < count; i ++) {
        CommentLabel * label = [[CommentLabel alloc] initWithFrame:CGRectMake(0, top, width, 0)];
        label.wxComment = [model.commes objectAtIndex:i];
        // 点击评论
        
        [label setDidClickText:^(MomentComent *comment) {
            // 当前moment相对tableView的frame
            CGRect rect = [[label superview] convertRect:label.frame toView:self.superview];
            [AppDelegate sharedInstance].convertRect = rect;
            if ([self.delegate respondsToSelector:@selector(didOperateWxMoment:selectWxComment:)]){
                [self.delegate didOperateWxMoment:self selectWxComment:comment];
            }
//            if ([self.delegate respondsToSelector:@selector(didOperateMoment:selectComment:)]) {
//                [self.delegate didOperateMoment:self selectComment:comment];
//
//            }
            [self resetMenuView];
        }];
        // 点击高亮
        [label setDidClickLinkText:^(MLLink *link, NSString *linkText) {
            if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:)]) {
                [self.delegate didClickLink:link linkText:linkText];
            }
            [self resetMenuView];
        }];
        //点击头像
        [label setDidClickUserIcon:^(MomentComent *comment) {
            if ([self.delegate respondsToSelector:@selector(didClickCommentIcon:)]){
                [self.delegate didClickCommentIcon:comment];
            }
        }];
        [_commentView addSubview:label];
        // 更新
        top += label.height;
    }
    // 更新UI
    if (top > 0) {
        _bgImageView.frame = CGRectMake(_nicknameBtn.left, bottom, width, top + kArrowHeight);
        _bgImageView.image = [[UIImage imageNamed:@"comment_bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
        _commentView.frame = CGRectMake(_avatarImageView.left, bottom + kArrowHeight, width, top);
        rowHeight = _commentView.bottom + kBlank;
    } else {
        rowHeight = _timeLabel.bottom + kBlank;
    }
    // 这样做就是起到缓存行高的作用，省去重复计算!!!
    model.rowHeight = rowHeight;
}

#pragma mark - setter
- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    // 头像
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:moment.user.portrait] placeholderImage:nil];
    // 昵称
    [_nicknameBtn setTitle:moment.user.name forState:UIControlStateNormal];
    [_nicknameBtn sizeToFit];
    if (_nicknameBtn.width > kTextWidth) {
        _nicknameBtn.width = kTextWidth;
    }
    _nicknameBtn.frame = CGRectMake(_avatarImageView.right + 10, _avatarImageView.top, _nicknameBtn.width, 20);
    // 正文
    _showAllBtn.hidden = YES;
    _linkLabel.hidden = YES;
    CGFloat bottom = _avatarImageView.bottom + 15;
    CGFloat rowHeight = 0;
    if ([moment.text length])
    {
        _linkLabel.hidden = NO;
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = lineSpacing;
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:moment.text];
        [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,[moment.text length])];
        _linkLabel.attributedText = attributedText;
        // 判断显示'全文'/'收起'
        CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
        CGFloat labHeight = attrStrSize.height;
        if (labHeight > maxLimitHeight) {
            if (!_moment.isFullText) {
                labHeight = maxLimitHeight;
            }
            _showAllBtn.hidden = NO;
            _showAllBtn.selected = _moment.isFullText;
        }
        _linkLabel.frame = CGRectMake(_avatarImageView.left, bottom, attrStrSize.width, labHeight);
        _showAllBtn.frame = CGRectMake(_avatarImageView.left, _linkLabel.bottom + kArrowHeight, _showAllBtn.width, kMoreLabHeight);
        if (_showAllBtn.hidden) {
            bottom = _linkLabel.bottom + kPaddingValue;
        } else {
            bottom = _showAllBtn.bottom + kPaddingValue;
        }
        // 添加长按手势
        if (!_longPress) {
            _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        }
        [_linkLabel addGestureRecognizer:_longPress];
    }
    // 图片
    _imageListView.moment = moment;
    if ([moment.pictureList count] > 0) {
        _imageListView.origin = CGPointMake(_avatarImageView.left, bottom);
        bottom = _imageListView.bottom + kPaddingValue;
    }
    // 位置
    _timeLabel.text = [Utility getMomentTime:moment.time];
    [_timeLabel sizeToFit];
    if (moment.location) {
        [_locationBtn setTitle:moment.location.position forState:UIControlStateNormal];
        [_locationBtn sizeToFit];
        _locationBtn.hidden = NO;
        _locationBtn.frame = CGRectMake(_avatarImageView.left, bottom, _locationBtn.width, kTimeLabelH);
        bottom = _locationBtn.bottom + kPaddingValue;
    } else {
        _locationBtn.hidden = YES;
    }
    _timeLabel.frame = CGRectMake(_avatarImageView.left, bottom, _timeLabel.width, kTimeLabelH);
    _deleteBtn.frame = CGRectMake(_timeLabel.right + 25, _timeLabel.top, 30, kTimeLabelH);
    bottom = _timeLabel.bottom + kPaddingValue;
    // 操作视图
    _menuView.frame = CGRectMake(k_screen_width-kOperateWidth-10, _timeLabel.top-(kOperateHeight-kTimeLabelH)/2, kOperateWidth, kOperateHeight);
    _menuView.show = NO;
    _menuView.isLike = moment.isLike;
    // 处理评论/赞
    _commentView.frame = CGRectZero;
    _bgImageView.frame = CGRectZero;
    _bgImageView.image = nil;
    [_commentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 处理赞
    CGFloat top = 0;
    CGFloat width = k_screen_width - kRightMargin - _avatarImageView.left;
    if ([moment.likeList count]) {
        MLLinkLabel * likeLabel = kMLLinkLabel(NO);
        likeLabel.delegate = self;
        likeLabel.attributedText = kMLLinkAttributedText(moment);
        CGSize attrStrSize = [likeLabel preferredSizeWithMaxWidth:kTextWidth];
        likeLabel.frame = CGRectMake(5, 8, attrStrSize.width, attrStrSize.height);
        [_commentView addSubview:likeLabel];
        // 分割线
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, likeLabel.bottom + 7, width, 0.5)];
        line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        [_commentView addSubview:line];
        // 更新
        top = attrStrSize.height + 15;
    }
    // 处理评论
    NSInteger count = [moment.commentList count];
    for (NSInteger i = 0; i < count; i ++) {
        CommentLabel * label = [[CommentLabel alloc] initWithFrame:CGRectMake(0, top, width, 0)];
        label.comment = [moment.commentList objectAtIndex:i];
        // 点击评论
//        [label setDidClickText:^(Comment *comment) {
//            // 当前moment相对tableView的frame
//            CGRect rect = [[label superview] convertRect:label.frame toView:self.superview];
//            [AppDelegate sharedInstance].convertRect = rect;
//
//            if ([self.delegate respondsToSelector:@selector(didOperateMoment:selectComment:)]) {
//                [self.delegate didOperateMoment:self selectComment:comment];
//            }
//            [self resetMenuView];
//        }];
        // 点击高亮
        [label setDidClickLinkText:^(MLLink *link, NSString *linkText) {
            if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:)]) {
                [self.delegate didClickLink:link linkText:linkText];
            }
            [self resetMenuView];
        }];
        [_commentView addSubview:label];
        // 更新
        top += label.height;
    }
    // 更新UI
    if (top > 0) {
        _bgImageView.frame = CGRectMake(_nicknameBtn.left, bottom, width, top + kArrowHeight);
        _bgImageView.image = [[UIImage imageNamed:@"comment_bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
        _commentView.frame = CGRectMake(_avatarImageView.left, bottom + kArrowHeight, width, top);
        rowHeight = _commentView.bottom + kBlank;
    } else {
        rowHeight = _timeLabel.bottom + kBlank;
    }
    // 这样做就是起到缓存行高的作用，省去重复计算!!!
    _moment.rowHeight = rowHeight;
}

#pragma mark - 点击事件
// 点击昵称/查看位置/查看全文|收起/删除动态
- (void)buttonClicked:(UIButton *)sender
{
    MMOperateType operateType = sender.tag;
    // 改变背景色
    sender.titleLabel.backgroundColor = kHLBgColor;
    GCD_AFTER(0.3, ^{  // 延迟执行
        sender.titleLabel.backgroundColor = [UIColor clearColor];
        if (operateType == MMOperateTypeFull) {
            self->_moment.isFullText = !_moment.isFullText;
            [self->_moment update];
        }
        if ([self.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [self.delegate didOperateMoment:self operateType:operateType];
        }
    });
    [self resetMenuView];
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    [self resetMenuView];
    // 点击动态正文或者赞高亮
    if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:)]) {
        [self.delegate didClickLink:link linkText:linkText];
    }
}

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [kNotificationCenter postNotificationName:@"ResetMenuView" object:nil];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyHandler)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 长按拷贝
- (void)longPressHandler:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        
        _linkLabel.backgroundColor = kHLBgColor;
        CGRect frame = [[_linkLabel superview] convertRect:_linkLabel.frame toView:self];
        CGRect menuFrame = CGRectMake(frame.origin.x + frame.size.width/2.0, frame.origin.y, 0, 0);
        if (!_menuController) {
            UIMenuItem * copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyHandler)];
            _menuController = [UIMenuController sharedMenuController];
            [_menuController setMenuItems:@[copyItem]];
        }
        [_menuController setTargetRect:menuFrame inView:self];
        [_menuController setMenuVisible:YES animated:YES];
    }
}

- (void)copyHandler
{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:_moment.text];
    [_menuController setMenuVisible:NO animated:YES];
}

- (void)resetLinkLabel
{
    _linkLabel.backgroundColor = [UIColor clearColor];
}

- (void)resetMenuView
{
    _menuView.show = NO;
    [_menuController setMenuVisible:NO animated:YES];
}

#pragma mark -
- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}

@end

#pragma mark - ------------------ 评论 ------------------
@implementation CommentLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _linkLabel = kMLLinkLabel(NO);
        _linkLabel.delegate = self;
        [self addSubview:_linkLabel];
        
        _iconView = [[MMImageView alloc] initWithFrame:CGRectMake(30, 13, kLikeIconWidth, kLikeIconWidth)];
        
        _iconView.cornerRadius = kLikeIconWidth/2;
        _iconView.backgroundColor = UIColor.grayColor;
        [self addSubview:_iconView];
    }
    return self;
}
#pragma mark - WX_Setter
- (void)setWxComment:(MomentComent *)wxComment{
    _wxComment = wxComment;
    
    [_iconView sd_setImageWithURL: [NSURL URLWithString:wxComment.tgusetImg]];
    WS(wSelf);
    [_iconView setClickHandler:^(MMImageView *imageView) {
        if (wSelf.didClickUserIcon) {
            wSelf.didClickUserIcon(wxComment);
        }
    }];
    
    _linkLabel.attributedText = kMLLinkAttributedText(wxComment);
    CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth - 71];
    _linkLabel.frame = CGRectMake(_iconView.right+9, _iconView.top, attrStrSize.width, attrStrSize.height);
//    self.height = attrStrSize.height + 5;
    self.height = MAX(_iconView.bottom, attrStrSize.height + 17) + 5;
    
}
#pragma mark - Setter
- (void)setComment:(Comment *)comment
{
    _comment = comment;
    
    
    _linkLabel.attributedText = kMLLinkAttributedText(comment);
    CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
    _linkLabel.frame = CGRectMake(5, 3, attrStrSize.width, attrStrSize.height);
    self.height = attrStrSize.height + 5;
    
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    if (self.didClickLinkText) {
        self.didClickLinkText(link,linkText);
    }
}

#pragma mark - 点击
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = kHLBgColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    GCD_AFTER(0.3, ^{  // 延迟执行
        self.backgroundColor = [UIColor clearColor];
        if (self.didClickText) {
            self.didClickText(_wxComment);
        }
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
}

@end
