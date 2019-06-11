//
//  WXValidationTool.h
//  WXChat
//
//  Created by WDX on 2019/6/11.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXValidationTool : NSObject
+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum;
@end

NS_ASSUME_NONNULL_END
