//
//  MailAccount.m
//  WXChat
//
//  Created by gwj on 2019/7/27.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "MailInfoList.h"

@implementation MailInfoList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"context":[MailInfo class]};
}
@end
