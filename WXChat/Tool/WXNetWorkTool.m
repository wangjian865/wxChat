//
//  WXNetWorkTool.m
//  WXChat
//
//  Created by WDX on 2019/6/6.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXNetWorkTool.h"
#import "AFNetworking.h"
NSInteger const kAFNetworkingTimeoutInterval = 10;
@implementation WXNetWorkTool
static AFHTTPSessionManager *aManager;
+ (AFHTTPSessionManager *)sharedManager{
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        aManager = [AFHTTPSessionManager manager];
        aManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
        aManager.responseSerializer = [AFJSONResponseSerializer serializer];
        aManager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置超时时间
        aManager.requestSerializer.timeoutInterval = kAFNetworkingTimeoutInterval;
    });
    return aManager;
}
// 需根据网络使用权限判断
+ (BOOL)isNetworkReachable{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (void)requestWithType:(WXHttpRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
           successBlock:(SuccessBlock)successBlock
           failureBlock:(FailureBlock)failureBlock{
    
    if (urlString == nil)
    {
        return;
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    if (type == WXHttpRequestTypeGet)
    {
        
        [[self sharedManager] GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (error.code !=-999) {
                if (failureBlock)
                {
                    failureBlock(error);
                }
            }
            else{
                NSLog(@"取消队列了");
            }
        }];
        
    }
    
    if (type == WXHttpRequestTypePost)
    {
        
        [[self sharedManager] POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (error.code !=-999) {
                if (failureBlock)
                {
                    failureBlock(error);
                }
            }
            else{
                NSLog(@"取消队列了");
            }
            
        }];
    }
}

+ (void)cancelDataTask{
    NSMutableArray *dataTasks = [NSMutableArray arrayWithArray:[self sharedManager].dataTasks];
    for (NSURLSessionDataTask *taskObj in dataTasks) {
        [taskObj cancel];
    }
}
@end
