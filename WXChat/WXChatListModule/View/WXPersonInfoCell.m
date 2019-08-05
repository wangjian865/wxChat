//
//  WXPersonInfoCell.m
//  WXChat
//
//  Created by WX on 2019/7/14.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXPersonInfoCell.h"

#define cellHeight 116
#define bubbleViewHeight cellHeight - 15 // 气泡背景图高度
@interface WXPersonInfoCell ()
/** 标题 */
@property (nonatomic, strong) UILabel *titleLb;
/** 描述 */
@property (nonatomic, strong) UILabel *describeLb;
/** 图片 */
@property (nonatomic, strong) UIImageView *iconImgView;
/** 分割线 */
@property (nonatomic, strong) UIView *lienView;
/** 底部 图片+文字 but */
@property (nonatomic, strong) UIButton *bottomView;
@end
@implementation WXPersonInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

#pragma mark - 系统回调
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        // 添加子控件
        [self setupSubViewWithModel:model];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 重写父类方法
/** 获取cell的reuseIdentifier */
+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    return @"WXPersonInfoCell";
}

/** 获取cell高度 */
+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    return cellHeight;
}

/** 判断是否需要自定义气泡 */
- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
{
    return YES;
}

/** 根据消息model变更气泡样式 */
- (void)setCustomModel:(id<IMessageModel>)model
{
    UIImage *image = model.image;
    if (!image) {
        [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
    } else {
        _bubbleView.imageView.image = image;
    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
}

/** 根据消息改变气泡样式 */
- (void)setCustomBubbleView:(id)model{
    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
}

/** 更新自定义气泡的边距 */
- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)mode
{
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
    CGFloat nameLabelHeight = 15;// 昵称label的高度
    if (mode.isSender) {
        _bubbleView.frame =
        CGRectMake([UIScreen mainScreen].bounds.size.width - 340, nameLabelHeight, 280, bubbleViewHeight);
    }else{
        _bubbleView.frame = CGRectMake(55, nameLabelHeight, 280, bubbleViewHeight);
    }
}

#pragma mark - 私有方法
/** 添加子控件 */
- (void)setupSubViewWithModel:(id<IMessageModel>)model
{
    NSLog(@"扩展消息 === %@",model.message.ext);
    self.hasRead.hidden = YES;
    [self.bubbleView.backgroundImageView addSubview:self.titleLb];
    [self.bubbleView.backgroundImageView addSubview:self.describeLb];
    [self.bubbleView.backgroundImageView addSubview:self.iconImgView];
    [self.bubbleView.backgroundImageView addSubview:self.lienView];
    [self.bubbleView.backgroundImageView addSubview:self.bottomView];
    
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(40);
    }];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(8);
        make.top.equalTo(self.iconImgView.mas_top).offset(8);
    }];
    [_describeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.equalTo(self.titleLb.mas_bottom).offset(8);
        make.right.equalTo(self.bubbleView.backgroundImageView).offset(-8);
    }];
    [_lienView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(0.6);
        make.bottom.mas_equalTo(-20);
    }];
}

#pragma mark - lazy
- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 150, 15)];
        _titleLb.text = @"泰罗奥特曼";
        _titleLb.textColor = [UIColor blackColor];
        _titleLb.font = [UIFont  boldSystemFontOfSize:18];
    }
    return _titleLb;
}

- (UILabel *)describeLb
{
    if (!_describeLb) {
        _describeLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15+15+2, 180, 15)];
        _describeLb.text = @"来自M78星云的超级战士";
        _describeLb.textColor = [UIColor grayColor];
        _describeLb.font = [UIFont systemFontOfSize:13];
    }
    return _describeLb;
}

- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(213 - 40 - 20, 15+15+2, 40, 40)];
        _iconImgView.image = [UIImage imageNamed:@"sports"];
        _iconImgView.backgroundColor = UIColor.redColor;
        _iconImgView.layer.cornerRadius = 25;
    }
    return _iconImgView;
}

- (UIView *)lienView
{
    if (!_lienView) {
        _lienView = [[UIView alloc] initWithFrame:CGRectMake(2, bubbleViewHeight - 20, 213-11, 0.5)];
        _lienView.backgroundColor = [UIColor grayColor];
    }
    return _lienView;
}

- (UIButton *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomView.frame = CGRectMake(0, bubbleViewHeight - 20, 90, 20);
        _bottomView.backgroundColor = [UIColor clearColor];
        [_bottomView setTitle:@"名片" forState:UIControlStateNormal];
        [_bottomView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _bottomView.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
        [_bottomView setImage:[UIImage imageNamed:@"sports_icon"] forState:UIControlStateNormal];
        _bottomView.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _bottomView;
}

@end
