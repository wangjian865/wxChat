//
//  Enterprise.m
//  login
//
//  Created by gwj on 2019/7/23.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

#import "Enterprise.h"

@implementation Enterprise
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"commes":[MomentComent class],@"namelike":[LikeListModel class]};
}
@end
