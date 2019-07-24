//
//  WXNetWorkTool.h
//  WXChat
//
//  Created by WDX on 2019/6/6.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/** 请求类型的枚举 */
typedef NS_ENUM(NSUInteger, WXHttpRequestType)
{
    /** get请求 */
    WXHttpRequestTypeGet = 0,
    /** post请求 */
    WXHttpRequestTypePost
};
typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSError * error);
typedef void(^ProgressBlock)(NSProgress * downloadProgress);
@interface WXNetWorkTool : NSObject
//当前网络是否可用
+ (BOOL)isNetworkReachable;
/**
 *  网络请求的实例方法
 *
 *  @param type         get / post
 *  @param urlString    请求的地址
 *  @param parameters   请求的参数
 *  @param successBlock 请求成功回调
 *  @param failureBlock 请求失败回调
 */
+ (void)requestWithType:(WXHttpRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
           successBlock:(SuccessBlock)successBlock
           failureBlock:(FailureBlock)failureBlock;
/**
 文件上传
 **/
+ (void)uploadFileWithUrl:(NSString *)urlString
                    image:(UIImage *)image
               parameters:(NSDictionary *)parameters
             successBlock:(SuccessBlock)successBlock
             failureBlock:(FailureBlock)failureBlock;
/**
 取消队列
 */
+(void)cancelDataTask;
@end

NS_ASSUME_NONNULL_END
