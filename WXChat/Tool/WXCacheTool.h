//
//  WXCacheTool.h
//  WXChat
//
//  Created by WX on 2019/7/19.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface WXCacheTool : NSObject
///数据持久化保存的key
+ (void)wx_saveModel:(id)model key:(NSString *)key;

///获取数据持久化保存的Model  - 要传入model的Class - 内部进行yyModel转模型
+ (id) wx_getSaveModelWithkey:(NSString *)key modelClass:(Class)modelClass;

///获取保存的模型数组
+ (id) wx_getSaveModelArrayWithkey:(NSString *)key modelClass:(Class)modelClass;
@end

NS_ASSUME_NONNULL_END
