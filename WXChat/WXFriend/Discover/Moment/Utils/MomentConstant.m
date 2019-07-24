//
//  MomentConstant.m
//  MomentKit
//
//  Created by LEA on 2019/3/27.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MomentConstant.h"

// 容器最小高度
CGFloat const MMContainMinHeight = 50;
// 容器最大高度
CGFloat const MMContainMaxHeight = 120;
// 容器减去输入框的高度
CGFloat const MarginHeight = 15;


// 操作电话号码
CGFloat const MMHandlePhoneTag = 1000;
// 删除评论
CGFloat const MMDelCommentTag = 1001;
//替换封面
CGFloat const MMChangeCoverTag = 1002;
// 延迟执行
void GCD_AFTER(CGFloat time,dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}
