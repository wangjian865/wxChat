//
//  WDXUsersListCell.m
//  WXChat
//
//  Created by WX on 2019/8/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WDXUsersListCell.h"

@implementation WDXUsersListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self _setupSubview];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        UILongPressGestureRecognizer *headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        //        [self addGestureRecognizer:headerLongPress];
    }
    
    return self;
}
+ (NSString *)cellIdentifierWithModel:(id)model{
    return @"wdxuserListCell";
}
+ (CGFloat)cellHeightWithModel:(id)model{
    return 60;
}
- (void)setWxModel:(SearchUserModel *)wxModel{
    _wxModel = wxModel;
    _titleLabel.text = wxModel.tgusetName;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:wxModel.tgusetImg]];
}
- (void)setCellSelected:(BOOL)CellSelected{
    _CellSelected = CellSelected;
    _selectButton.selected = CellSelected;
}
- (void)setIsEditing:(BOOL)isEditing{
//    _isEditing = isEditing;
//    if (isEditing){
//        _selectButton.hidden = NO;
//        [_avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.selectButton.mas_right).offset(35);
//        }];
//    }else{
//        _selectButton.hidden = YES;
//        [_avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.selectButton.mas_right);
//        }];
//    }
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
    _avatarView.cornerRadius = 19;
    [self.contentView addSubview:_avatarView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.accessibilityIdentifier = @"title";
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 1;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = UIColor.blackColor;
    [self.contentView addSubview:_titleLabel];
    
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@21);
        make.centerY.equalTo(self.contentView);
        make.left.offset(14);
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
    
    _coverView = [[UIView alloc] init];
    _coverView.backgroundColor = RGB(233, 233, 233, 0.4);
    _coverView.hidden = true;
    [self.contentView addSubview:_coverView];
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
}
- (void)setShowCoverView:(BOOL *)showCoverView{
//    _showCoverView = showCoverView;
//    _coverView.hidden = !showCoverView;
}
- (void)changeButtonState:(UIButton *)sender {
    sender.selected = !sender.selected;
    //改变状态后传出
//    _wxModel.isChoose = sender.selected;
    if (self.chooseAction != nil){
        self.chooseAction(_wxModel.tgusetId);
    }
}
@end
