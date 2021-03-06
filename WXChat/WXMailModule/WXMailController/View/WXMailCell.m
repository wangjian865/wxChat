//
//  WXMailCell.m
//  MailDemo
//
//  Created by 王坚 on 2019/6/21.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMailCell.h"


@interface WXMailCell ()
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;

@end
@implementation WXMailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    _iconView = [[UIImageView alloc] init];
    _iconView.image = [UIImage imageNamed:@"normal_icon"];
    [self.contentView addSubview:_iconView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"This is name label";
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = rgb(21,21,21);
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"This is name label";
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = rgb(21,21,21);
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"This is title label";
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = rgb(21,21,21);
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.text = @"Logo的事情还要继续麻烦你帮下忙，我周末沟通下来，需要在原来的基础上设计以下三种板式，具体的图片传";
    _contentLabel.font = [UIFont systemFontOfSize:12];
    _contentLabel.textColor = rgb(102,102,102);
    _contentLabel.numberOfLines = 2;
    [self.contentView addSubview:_contentLabel];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.width.height.mas_equalTo(50);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(17);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(11);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(6);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-18);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}
- (void)setModel:(MailInfo *)model{
    _model = model;
    _nameLabel.text = [[model.readeamilsendtugset componentsSeparatedByString:@"<"].firstObject stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    _titleLabel.text = model.readeamiltheme;
    _timeLabel.text = model.readeamiltime;
//    NSString *temp = [model.readeamilcontet componentsSeparatedByString:@"<td style=\"display:none;\">"].lastObject;
//    NSString *content = [temp componentsSeparatedByString:@"</td>"].firstObject;
    
    NSString *content = [self filterHTML:model.readeamilcontet];
    _contentLabel.text = content;
}
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    return html;
}
@end
