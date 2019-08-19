//
//  WXMessageAlertViewCell.m
//  WXChat
//
//  Created by WDX on 2019/6/12.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMessageAlertViewCell.h"
#import "WXMessageAlertModel.h"
#import "ApprovalModel.h"
@interface WXMessageAlertViewCell ()
/**
 * 头像
 */
@property (nonatomic, strong) UIImageView *avatarView;
/**
 * 姓名
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 * 描述
 */
@property (nonatomic, strong) UILabel *descriptionLabel;
/**
 * 功能按钮
 */
@property (nonatomic, strong) UIButton *button;
//模型
@property (nonatomic, strong) WXMessageAlertModel *myModel;
@end
@implementation WXMessageAlertViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    _avatarView = [[UIImageView alloc] init];
    _avatarView.image = [UIImage imageNamed:@"normal_icon"];
    _avatarView.layer.cornerRadius = 47/2;
    _avatarView.layer.masksToBounds = true;
    [self.contentView addSubview:_avatarView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"";
    [self.contentView addSubview:_nameLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.text = @"";
    [self.contentView addSubview:_descriptionLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@" 同意 " forState:UIControlStateNormal];
    [_button setTitleColor:rgb(48,134,191) forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _button.titleLabel.font = [UIFont systemFontOfSize:12];
    _button.layer.borderColor = rgb(48,134,191).CGColor;
    _button.layer.borderWidth = 1;
    [_button addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button];
}

- (void)layoutSubviews{
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(15);
        make.width.height.equalTo(@47);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
        make.left.equalTo(self.avatarView.mas_right).offset(25);
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.contentView.mas_centerY).offset(2);
    }];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(k_current_Width(-14));
        make.centerY.equalTo(self.contentView);
//        make.width.equalTo(@38);
//        make.height.equalTo(@24);
    }];
}
- (void)setModel: (WXMessageAlertModel *)model{
    _myModel = model;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:model.tgusetImg]];
    _nameLabel.text = model.tgusetName;
    _descriptionLabel.text = model.friendshowcontext;
    if ([model.friendshowifconsend isEqualToString:@"0"]){
        //申请中
        [self.button setTitle:@" 申请中 " forState:UIControlStateNormal];
        self.button.enabled = true;
        self.button.layer.borderColor = rgb(48,134,191).CGColor;
    }else if ([model.friendshowifconsend isEqualToString:@"1"]){
        //已通过
        [self.button setTitle:@" 已通过 " forState:UIControlStateDisabled];
        self.button.enabled = false;
        _button.layer.borderColor = [UIColor grayColor].CGColor;
    }else{
        //已拒绝
        [self.button setTitle:@" 已拒绝 " forState:UIControlStateDisabled];
        self.button.enabled = false;
        _button.layer.borderColor = [UIColor grayColor].CGColor;
    }
}
- (void)setComModel:(ApprovalModel *)comModel{
    _comModel = comModel;
//    [_avatarView sd_setImageWithURL:[NSURL URLWithString:comModel.]];
    _nameLabel.text = comModel.approvalTgusetname;
    _descriptionLabel.text = comModel.approvalContent;
    if ([comModel.state isEqualToString:@"0"]){
        //申请中
        [self.button setTitle:@" 申请中 " forState:UIControlStateNormal];
        self.button.enabled = true;
        self.button.layer.borderColor = rgb(48,134,191).CGColor;
    }else if ([comModel.state isEqualToString:@"1"]){
        //已通过
        [self.button setTitle:@" 已通过 " forState:UIControlStateDisabled];
        self.button.enabled = false;
        _button.layer.borderColor = [UIColor grayColor].CGColor;
    }else{
        //已拒绝
        [self.button setTitle:@" 已拒绝 " forState:UIControlStateDisabled];
        self.button.enabled = false;
        _button.layer.borderColor = [UIColor grayColor].CGColor;
    }
}
- (void)makeSure{
    [MineViewModel agreeUserForCompanyWithCompanyId:_comModel.approvalCompanyid userId:_comModel.approvalTgusetid success:^(NSString * msg) {
//        [MBProgressHUD showText:msg]
        if (self.makeSureAction){
            self.makeSureAction();
        }

    } failure:^(NSError * error) {

    }];
//    [MineViewModel handleFriendRequestWithIfAgree:@"1" showId:_myModel.friendshowid success:^(NSString * result) {
//        [MBProgressHUD showText:result];
//        if (self.makeSureAction){
//            self.makeSureAction();
//        }
//    } failure:^(NSError * error) {
//
//    }];
    
}
@end
