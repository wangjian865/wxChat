//
//  WXNetWorkTool.m
//  WXChat
//
//  Created by WDX on 2019/6/6.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXNetWorkTool.h"
#import "AFNetworking.h"
#import "WXAccountTool.h"
NSInteger const kAFNetworkingTimeoutInterval = 500000;
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
    NSString *token = [WXAccountTool getToken];
    //如果有token则添加到请求头中
    if (token != nil){
        [[self sharedManager].requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    
    if (type == WXHttpRequestTypeGet)
    {
        
        [[self sharedManager] GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        
        //添加接口统一参数
        NSMutableDictionary *muParames = [[NSMutableDictionary alloc] initWithDictionary:parameters];

        [[self sharedManager] POST:urlString parameters:muParames progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUD];
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"203"]){
                //token失效
                [WXAccountTool logout];
                [[AppDelegate sharedInstance] loginStateChange:NO huanxinID:@""];
            }
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            if (error.code == 203){
                //token失效
                [WXAccountTool logout];
                [[AppDelegate sharedInstance] loginStateChange:NO huanxinID:@""];
            }
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
+ (void)uploadRequest:(WXHttpRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
           successBlock:(SuccessBlock)successBlock
         failureBlock:(FailureBlock)failureBlock{
    //添加接口统一参数
    NSMutableDictionary *muParames = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    
    [[self sharedManager] POST:urlString parameters:muParames progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
+ (void)uploadFileWithUrl:(NSString *)urlString
                imageName:(NSArray *)names
                    image:(NSArray *)images
               parameters:(NSDictionary *)parameters
            progressBlock:(ProgressBlock)progressBlock
             successBlock:(SuccessBlock)successBlock
             failureBlock:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [self sharedManager];
    
    
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < names.count; i++) {
            NSString *name = names[i];
            UIImage *image = images[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
            CGFloat quality = 1.0;
            // 限定上传图片大小为100K
            while (imageData.length > 10 * 1024 && quality > 0.2) {
                quality -= 0.1;
                imageData = UIImageJPEGRepresentation(image, quality);
            }
            [formData appendPartWithFileData:imageData name:name fileName:@"icon.jpg" mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progressBlock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}
+ (void)cancelDataTask{
    NSMutableArray *dataTasks = [NSMutableArray arrayWithArray:[self sharedManager].dataTasks];
    for (NSURLSessionDataTask *taskObj in dataTasks) {
        [taskObj cancel];
    }
}
@end
