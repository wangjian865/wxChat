//
//  MailHomePageModel.m
//  WXChat
//
//  Created by WX on 2019/8/7.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "MailHomePageModel.h"

@implementation MailHomePageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"email":[MailHomePageAModel class]};
}
@end
