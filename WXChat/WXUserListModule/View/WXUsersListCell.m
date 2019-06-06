//
//  WXUsersListCell.m
//  WXChat
//
//  Created by WDX on 2019/6/6.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXUsersListCell.h"
@interface WXUsersListCell ()
/**
 * 头像
 */
@property (nonatomic, strong) UIImageView *avatarView;
/**
 * 名字
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 * editMode下存在选中框
 */
@property (nonatomic, strong) UIButton *selectButton;
@end
@implementation WXUsersListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//+ (void)initialize
//{
    // UIAppearance Proxy Defaults
    /** @brief 默认配置 */
//    WXUsersListCell *cell = [self appearance];
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self _setupSubview];
//        UILongPressGestureRecognizer *headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
//        [self addGestureRecognizer:headerLongPress];
    }
    
    return self;
}
+ (NSString *)cellIdentifierWithModel:(id)model{
    return @"userListCell";
}
+ (CGFloat)cellHeightWithModel:(id)model{
    return 60;
}
- (void)setModel:(id<IUserModel>)model{
    _model = model;
    _titleLabel.text = model.buddy;
}
- (void)setCellSelected:(BOOL)CellSelected{
    _CellSelected = CellSelected;
    _selectButton.selected = CellSelected;
}
- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    if (isEditing){
        _selectButton.hidden = NO;
        [_avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectButton.mas_right).offset(35);
        }];
    }else{
        _selectButton.hidden = YES;
        [_avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectButton.mas_right);
        }];
    }
}
#pragma mark - private method
- (void)_setupSubview{
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectButton addTarget:self action:@selector(changeButtonState:) forControlEvents:UIControlEventTouchUpInside];
    [_selectButton setImage:[UIImage imageNamed:@"userList_deselect"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"userList_select"] forState:UIControlStateSelected];
    [self.contentView addSubview:_selectButton];
    
    _avatarView = [[UIImageView alloc] init];
    _avatarView.image = [UIImage imageNamed:@"normal_icon"];
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_avatarView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.accessibilityIdentifier = @"title";
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 2;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = UIColor.blackColor;
    [self.contentView addSubview:_titleLabel];
    
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@21);
        make.centerY.equalTo(self.contentView);
        make.left.offset(21);
    }];
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@38);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.selectButton.mas_right).offset(35);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarView);
        make.left.equalTo(self.avatarView.mas_right).offset(15);
    }];
}
- (void)changeButtonState:(UIButton *)sender {
    sender.selected = !sender.selected;
    //改变状态后传出
    if (self.chooseAction != nil){
        self.chooseAction(_model.buddy);
    }
}
@end
