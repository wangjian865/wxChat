//
//  WXCacheTool.m
//  WXChat
//
//  Created by WX on 2019/7/19.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXCacheTool.h"

@implementation WXCacheTool
+ (void)wx_saveModel:(id)model key:(NSString *)key{
    
    //model转json
    NSDictionary *productDic = [model yy_modelToJSONObject];
    
    /**
     NSUserDefaults支持的数据格式有：NSNumber（Integer、Float、Double），NSString，NSDate，NSArray，NSDictionary，BOOL类型，而我们这里存储的是自定义的model类型-ProductModel，该类型不被支持
     */
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:productDic];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    
}


+ (id) wx_getSaveModelWithkey:(NSString *)key modelClass:(Class)modelClass{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return [modelClass yy_modelWithJSON:dict];
}

+ (id) wx_getSaveModelArrayWithkey:(NSString *)key modelClass:(Class)modelClass{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return [NSArray yy_modelArrayWithClass:[modelClass class] json:array];
}
@end
