//
//  MLLabelUtil.m
//  MomentKit
//
//  Created by LEA on 2017/12/13.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MLLabelUtil.h"
#import "MomentUtil.h"
#import "MomentComent.h"
@implementation MLLabelUtil

MLLinkLabel *kMLLinkLabel(BOOL isMoment)
{
    UIColor * foregroundColor = nil;
    if (isMoment) {
        foregroundColor = kLinkTextColor;
    } else {
        foregroundColor = kHLTextColor;
    }
    // 行间距
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    // attributes
    NSMutableDictionary * linkTextAttributes = [NSMutableDictionary dictionary];
    [linkTextAttributes setObject:foregroundColor forKey:NSForegroundColorAttributeName]; // 前景色
    [linkTextAttributes setObject:style forKey:NSParagraphStyleAttributeName]; // 行距
    
    NSMutableDictionary * activeLinkTextAttributes = [NSMutableDictionary dictionary];
    [activeLinkTextAttributes setObject:foregroundColor forKey:NSForegroundColorAttributeName]; // 前景色
    [activeLinkTextAttributes setObject:kHLBgColor forKey:NSBackgroundColorAttributeName]; // 背景色
    [activeLinkTextAttributes setObject:style forKey:NSParagraphStyleAttributeName]; // 行距
    
    MLLinkLabel *_linkLabel = [MLLinkLabel new];
    _linkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _linkLabel.textColor = [UIColor blackColor];
    _linkLabel.font = kComTextFont;
    _linkLabel.numberOfLines = 0;
    _linkLabel.activeLinkToNilDelay = 0.3;
    _linkLabel.linkTextAttributes = linkTextAttributes;
    _linkLabel.activeLinkTextAttributes = activeLinkTextAttributes;
    return _linkLabel;
}

NSMutableAttributedString *kMLLinkAttributedText(id object)
{
    NSMutableAttributedString *attributedText = nil;
    if ([object isKindOfClass:[MomentComent class]])
    {
        
        MomentComent * comment = (MomentComent *)object;
        NSString * fromName = comment.commentsTgusetName;
        NSString * toName = comment.commentsTgusetHFName;
        if (fromName == nil){
            fromName = @"";
        }
        if (toName)//不存在toname则表明是直接评论该条企业圈
        {
            NSString * likeString  = [NSString stringWithFormat:@"%@\n回复%@：%@",fromName,toName,comment.commentsContext];
            attributedText = [[NSMutableAttributedString alloc] initWithString:likeString];
            //WDX todo
            [attributedText setAttributes:@{NSFontAttributeName:kComHLTextFont,NSLinkAttributeName:[NSString stringWithFormat:@"%@",comment.commentsTguset]} range:[likeString rangeOfString:fromName]];
            [attributedText setAttributes:@{NSFontAttributeName:kComHLTextFont,NSLinkAttributeName:[NSString stringWithFormat:@"%@",comment.commentsTgusetHFId]} range:[likeString rangeOfString:toName]];
        } else {
            NSString *likeString  = [NSString stringWithFormat:@"%@\n%@",fromName,comment.commentsContext];
            attributedText = [[NSMutableAttributedString alloc] initWithString:likeString];
            [attributedText setAttributes:@{NSFontAttributeName:kComHLTextFont,NSLinkAttributeName:[NSString stringWithFormat:@"%@",comment.commentsTguset]} range:[likeString rangeOfString:fromName]];
        }
    }
    if ([object isKindOfClass:[Moment class]])
    {
        Moment * moment = (Moment *)object;
        NSString * content = [MomentUtil getLikeString:moment];
        NSString * likeString = [NSString stringWithFormat:@"[赞] %@",content];
        attributedText = [[NSMutableAttributedString alloc] initWithString:likeString];
        
        NSArray * nameList = [content componentsSeparatedByString:@"，"];
        NSInteger count = [nameList count];
        for (NSInteger i = 0; i < count; i ++) {
            NSString * name = [nameList objectAtIndex:i];
            MUser * user = [moment.likeList objectAtIndex:i];
            [attributedText setAttributes:@{NSFontAttributeName:kComHLTextFont,NSLinkAttributeName:[NSString stringWithFormat:@"%d",user.pk]} range:[likeString rangeOfString:name]];
        }
        
        // 添加'赞'的图片
        NSRange range = NSMakeRange(0, 3);
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"moment_like_hl"];
        textAttachment.bounds = CGRectMake(0, -3, textAttachment.image.size.width, textAttachment.image.size.height);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attributedText replaceCharactersInRange:range withAttributedString:imageStr];
    }
    return attributedText;
}
@end
