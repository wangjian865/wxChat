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
@property (nonatomic, strong) UILabel *bottomView;
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
    
    
    _bubbleView.backgroundImageView.hidden = model.isSender;

    UIImage *image = model.image;
    if (!image) {
        [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
    } else {
        _bubbleView.imageView.image = [UIImage imageNamed:@"白色气泡"];
    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
}

/** 根据消息改变气泡样式 */
- (void)setCustomBubbleView:(id)model{
    self.bubbleView.backgroundImageView.image = nil;
//    _bubbleView.backgroundColor = UIColor.yellowColor;
//    _bubbleView.imageView = [[UIImageView alloc] init];
//    [_bubbleView addSubview:_bubbleView.imageView];
//    [_bubbleView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.offset(0);
//    }];
//
//    _bubbleView.imageView.translatesAutoresizingMaskIntoConstraints = NO;
//    _bubbleView.imageView.backgroundColor = [UIColor greenColor];
    
    
//    _bubbleView.imageView.image = [UIImage imageNamed:@"蓝色对话框"];
}

/** 更新自定义气泡的边距 */
- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)mode
{
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
    CGFloat nameLabelHeight = 15;// 昵称label的高度
    if (mode.isSender) {
        _bubbleView.frame =
        CGRectMake([UIScreen mainScreen].bounds.size.width - 300, nameLabelHeight, 250, bubbleViewHeight);
    }else{
        _bubbleView.frame = CGRectMake(55, nameLabelHeight, 250, bubbleViewHeight);
    }
}

#pragma mark - 私有方法
/** 添加子控件 */
- (void)setupSubViewWithModel:(id<IMessageModel>)model
{
    NSLog(@"扩展消息 === %@",model.message.ext);
    self.hasRead.hidden = YES;
    UIImageView *backImg = [[UIImageView alloc] init];
    backImg.hidden = !model.isSender;
    backImg.image = [UIImage imageNamed:@"白色气泡"];
    [self.bubbleView addSubview:backImg];
    [self.bubbleView addSubview:self.titleLb];
    [self.bubbleView addSubview:self.describeLb];
    [self.bubbleView addSubview:self.iconImgView];
    [self.bubbleView addSubview:self.lienView];
    [self.bubbleView addSubview:self.bottomView];
    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(56);
    }];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(8);
        make.top.equalTo(self.iconImgView.mas_top).offset(8);
    }];
    [_describeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.equalTo(self.titleLb.mas_bottom).offset(8);
        make.right.offset(-8);
    }];
    [_lienView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(0.6);
        make.bottom.mas_equalTo(-20);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-5);
        make.left.offset(15);
    }];
}
- (void)setModel:(id<IMessageModel>)model{
    [super setModel:model];
    NSDictionary *dic = model.message.ext;
    _titleLb.text = [NSString stringWithFormat:@"%@",dic[@"userName"]];
    _describeLb.text = [NSString stringWithFormat:@"%@",dic[@"company"]];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"userIcon"]]]];
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
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(213 - 40 - 20, 15+15+2, 60, 60)];
        _iconImgView.image = [UIImage imageNamed:@"sports"];
        _iconImgView.backgroundColor = UIColor.grayColor;
        _iconImgView.layer.cornerRadius = 28;
        _iconImgView.layer.masksToBounds = true;
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
- (UILabel *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UILabel alloc] init];
        _bottomView.font = [UIFont systemFontOfSize:11];
        _bottomView.text = @"名片";
    }
    return _bottomView;
}
//- (UIButton *)bottomView
//{
//    if (!_bottomView) {
//        _bottomView = [UIButton buttonWithType:UIButtonTypeCustom];
//        _bottomView.frame = CGRectMake(0, bubbleViewHeight - 20, 90, 20);
//        _bottomView.backgroundColor = [UIColor clearColor];
//        [_bottomView setTitle:@"名片" forState:UIControlStateNormal];
//        [_bottomView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        _bottomView.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
//        [_bottomView setImage:[UIImage imageNamed:@"sports_icon"] forState:UIControlStateNormal];
//        _bottomView.titleLabel.font = [UIFont systemFontOfSize:11];
//    }
//    return _bottomView;
//}

@end
