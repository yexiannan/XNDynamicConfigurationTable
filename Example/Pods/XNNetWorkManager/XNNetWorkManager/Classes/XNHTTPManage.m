//
//  XNHTTPManage.m
//  XNNetWorkManager
//
//  Created by Luigi on 2019/6/27.
//  Copyright © 2019 Luigi. All rights reserved.
//

#import "XNHTTPManage.h"
#import "XNHTTPSessionManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "SVProgressHUD.h"

NSString * kNetWorkErrorTip = @"网络异常,请稍后再试!";

@interface XNHTTPManage ()
//请求缓存,避免请求重复提交
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSURLSessionDataTask *>*requestCache;
@end

@implementation XNHTTPManage
+ (XNHTTPManage *)httpManager{
    static dispatch_once_t oncetoken;
    static XNHTTPManage *shareinstance;
    dispatch_once(&oncetoken, ^{
        shareinstance = [[self alloc] init];
        shareinstance.requestCache = [[NSMutableDictionary alloc] init];
        shareinstance.serializer = [AFHTTPRequestSerializer serializer];
        shareinstance.securityPolicy = [AFSecurityPolicy defaultPolicy];
        shareinstance.headers = nil;
    });
    return shareinstance;
}

- (void)httpManagerInitWithAFHTTPRequestSerializer:(AFHTTPRequestSerializer *)serializer AFSecurityPolicy:(AFSecurityPolicy *)securityPolicy Headers:(NSDictionary<NSString *,NSString *> *)headers ResponseSuccessOperating:(nonnull responseSuccessOperating)successOperating ResponseFailureOperating:(nonnull responseFailureOperating)failureOperating{
    self.serializer = serializer;
    self.securityPolicy = securityPolicy;
    self.headers = headers;
    self.successOperating = successOperating;
    self.failureOperating = failureOperating;
}

#pragma mark - 基础请求
/**
 * 基础POST请求
 */
+ (NSURLSessionDataTask *)Post:(NSString *)URLString
                    parameters:(nullable id)parameters
                  hudAnimation:(BOOL)hudAnimation
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{

    return [self Post:URLString
           parameters:parameters
         hudAnimation:hudAnimation
    requestSerializer:[XNHTTPManage httpManager].serializer
       securityPolicy:[XNHTTPManage httpManager].securityPolicy
              headers:[XNHTTPManage httpManager].headers
  duplicateParameters:nil
        duplicateType:DuplicateType_NotHandle
              success:success
              failure:failure];
}

/**
 * 基础GET请求
 */
+ (NSURLSessionDataTask *)Get:(NSString *)URLString
                   parameters:(nullable id)parameters
                 hudAnimation:(BOOL)hudAnimation
                      success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
    
    return [self Get:URLString
          parameters:parameters
        hudAnimation:hudAnimation
   requestSerializer:[XNHTTPManage httpManager].serializer
      securityPolicy:[XNHTTPManage httpManager].securityPolicy
             headers:[XNHTTPManage httpManager].headers
 duplicateParameters:nil
       duplicateType:DuplicateType_NotHandle
             success:success
             failure:failure];
}

#pragma mark - 配置AFHTTPSessionManager
/**
* Post配置requestSerializer Post: parameters: requestSerializer:: progress: success: failure:
*/
+ (NSURLSessionDataTask *)Post:(NSString *)URLString
                    parameters:(nullable id)parameters
                  hudAnimation:(BOOL)hudAnimation
             requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    return [self Post:URLString
           parameters:parameters
         hudAnimation:hudAnimation
    requestSerializer:requestSerializer
              headers:[XNHTTPManage httpManager].headers
              success:success
              failure:failure];
}

/**
 * Post配置requestSerializer Post: parameters: requestSerializer: headers: progress: success: failure:
 */
+ (NSURLSessionDataTask *)Post:(NSString *)URLString
                    parameters:(nullable id)parameters
                  hudAnimation:(BOOL)hudAnimation
             requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                       headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
    return [self Post:URLString
           parameters:parameters
         hudAnimation:hudAnimation
    requestSerializer:requestSerializer
       securityPolicy:[XNHTTPManage httpManager].securityPolicy
              headers:headers
  duplicateParameters:nil
        duplicateType:DuplicateType_NotHandle
              success:success
              failure:failure];
}
/**
 * Post配置securityPolicy Post: parameters: securityPolicy: headers: progress: success: failure:
 */
+ (NSURLSessionDataTask *)Post:(NSString *)URLString
                    parameters:(nullable id)parameters
                  hudAnimation:(BOOL)hudAnimation
                securityPolicy:(AFSecurityPolicy *)securityPolicy
                       headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
    return [self Post:URLString
           parameters:parameters
         hudAnimation:hudAnimation
    requestSerializer:[XNHTTPManage httpManager].serializer
       securityPolicy:securityPolicy
              headers:headers
  duplicateParameters:nil
        duplicateType:DuplicateType_NotHandle
              success:success
              failure:failure];
}
/**
 * Post配置requestSerializer和securityPolicy Post: parameters: requestSerializer: securityPolicy: headers: progress: success: failure:
 */
+ (NSURLSessionDataTask *)Post:(NSString *)URLString
                    parameters:(nullable id)parameters
                  hudAnimation:(BOOL)hudAnimation
             requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                securityPolicy:(AFSecurityPolicy *)securityPolicy
                       headers:(nullable NSDictionary <NSString *, NSString *> *)headers
           duplicateParameters:(nullable id)duplicateParameters
                 duplicateType:(HTTPManager_DuplicateType)duplicateType
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
    
    AFHTTPSessionManager *manager = [XNHTTPSessionManager sharedHttpPostSessionManager];
    manager.requestSerializer = requestSerializer;
    manager.securityPolicy = securityPolicy;
    
    return [self httpMethod:HttpMethod_Post
                  URLString:URLString
                 parameters:parameters
               hudAnimation:hudAnimation
                    headers:headers
                    manager:manager
        duplicateParameters:duplicateParameters
              duplicateType:duplicateType
                   progress:nil
                    success:success
                    failure:failure];
}


/**
 * Get配置requestSerializer Get: parameters: requestSerializer: headers: progress: success: failure:
 */
+ (NSURLSessionDataTask *)Get:(NSString *)URLString
                   parameters:(nullable id)parameters
                 hudAnimation:(BOOL)hudAnimation
            requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                      headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                      success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
    return [self Get:URLString
           parameters:parameters
        hudAnimation:hudAnimation
    requestSerializer:requestSerializer
       securityPolicy:[AFSecurityPolicy defaultPolicy]
              headers:headers
 duplicateParameters:nil
       duplicateType:DuplicateType_NotHandle
              success:success
              failure:failure];
}
/**
 * Get配置securityPolicy Get: parameters: securityPolicy: headers: progress: success: failure:
 */
+ (NSURLSessionDataTask *)Get:(NSString *)URLString
                   parameters:(nullable id)parameters
                 hudAnimation:(BOOL)hudAnimation
               securityPolicy:(AFSecurityPolicy *)securityPolicy
                      headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                      success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
    return [self Get:URLString
          parameters:parameters
        hudAnimation:hudAnimation
   requestSerializer:[AFHTTPRequestSerializer serializer]
      securityPolicy:securityPolicy
             headers:headers
 duplicateParameters:nil
       duplicateType:DuplicateType_NotHandle
             success:success
             failure:failure];
}
/**
 * Get配置requestSerializer和securityPolicy Get: parameters: requestSerializer: securityPolicy: headers: progress: success: failure:
 */
+ (NSURLSessionDataTask *)Get:(NSString *)URLString
                   parameters:(nullable id)parameters
                 hudAnimation:(BOOL)hudAnimation
            requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
               securityPolicy:(AFSecurityPolicy *)securityPolicy
                      headers:(nullable NSDictionary <NSString *, NSString *> *)headers
          duplicateParameters:(nullable id)duplicateParameters
                duplicateType:(HTTPManager_DuplicateType)duplicateType
                      success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure{
    
    AFHTTPSessionManager *manager = [XNHTTPSessionManager sharedHttpPostSessionManager];
    manager.requestSerializer = requestSerializer;
    manager.securityPolicy = securityPolicy;
    
    return [self httpMethod:HttpMethod_Get
                  URLString:URLString
                 parameters:parameters
               hudAnimation:hudAnimation
                    headers:headers
                    manager:manager
        duplicateParameters:duplicateParameters
              duplicateType:duplicateType
                   progress:nil
                    success:success
                    failure:failure];
}
#pragma mark - 根据httpMethod发送请求
/**
 * 根据配置的参数调用 AFHTTPSessionManager 发送请求
 */
+ (NSURLSessionDataTask *)httpMethod:(HttpMethod)httpMethod
                           URLString:(NSString *)URLString
                          parameters:(nullable id)parameters
                        hudAnimation:(BOOL)hudAnimation
                             headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                             manager:(AFHTTPSessionManager *)manager
                 duplicateParameters:(nullable id)duplicateParameters
                       duplicateType:(HTTPManager_DuplicateType)duplicateType
                            progress:(void (^)(NSProgress * _Nonnull))progress
                             success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                             failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    
    if (![self canContiueRequestWithUrlString:URLString parameters:duplicateParameters duplicateType:duplicateType failure:failure]) {
        return nil;
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    //设置请求头
    for (NSString *headerField in headers.keyEnumerator) {
        [manager.requestSerializer setValue:headers[headerField] forHTTPHeaderField:headerField];
    }
    
    //创建请求任务
    NSURLSessionDataTask *sessionDataTask = nil;

    if (hudAnimation) {
        [SVProgressHUD show];
    }
    
    if (httpMethod == HttpMethod_Post) {
        
        sessionDataTask = [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"-----url = %@,\n param = %@,\n header = %@,\n responseObject = %@",URLString,parameters,headers,responseObject);
            
            //移除缓存
            [self endSVProgressHUDWithHudAnimation:hudAnimation];
            [self removeRequestCacheWithUrl:URLString Param:duplicateParameters duplicateType:duplicateType];
            if ([XNHTTPManage httpManager].successOperating) {
                BOOL isContinue = [XNHTTPManage httpManager].successOperating(responseObject);
                if (!isContinue) { return ; }
            }
            if (success) {
                success(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"-----url = %@,\n param = %@,\n header = %@,\n error = %@",URLString,parameters,headers,error);
            
            //移除缓存
            [self endSVProgressHUDWithHudAnimation:hudAnimation];
            [self removeRequestCacheWithUrl:URLString Param:duplicateParameters duplicateType:duplicateType];
            if ([XNHTTPManage httpManager].failureOperating) {
                BOOL isContinue = [XNHTTPManage httpManager].failureOperating(error);
                if (!isContinue) { return ; }
            }
            if (failure) {
                failure(task,error);
            }
        }];
        
    } else if (httpMethod == HttpMethod_Get) {
        
        sessionDataTask = [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"-----url = %@,\n param = %@,\n header = %@,\n responseObject = %@",URLString,parameters,headers,responseObject);

            //移除缓存
            [self removeRequestCacheWithUrl:URLString Param:duplicateParameters duplicateType:duplicateType];
            [self endSVProgressHUDWithHudAnimation:hudAnimation];
            if ([XNHTTPManage httpManager].successOperating) {
                BOOL isContinue = [XNHTTPManage httpManager].successOperating(responseObject);
                if (!isContinue) { return ; }
            }
            if (success) {
                success(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"-----url = %@,\n param = %@,\n header = %@,\n error = %@",URLString,parameters,headers,error);

            //移除缓存
            [self removeRequestCacheWithUrl:URLString Param:duplicateParameters duplicateType:duplicateType];
            [self endSVProgressHUDWithHudAnimation:hudAnimation];
            if ([XNHTTPManage httpManager].failureOperating) {
                BOOL isContinue = [XNHTTPManage httpManager].failureOperating(error);
                if (!isContinue) { return ; }
            }
            if (failure) {
                failure(task,error);
            }
        }];
        
    } else {
        NSAssert(NO, @"目前只支持POST、GET请求");
    }
    
   
    
    [self addRequestCacheWithUrl:URLString Param:duplicateParameters SessionDataTask:sessionDataTask duplicateType:duplicateType];
    return sessionDataTask;
    
}

#pragma mark - 上传图片
/**
 *  上传单张图片
 */
+ (NSURLSessionDataTask *)POST:(NSString *)urlString
                     imageData:(NSData *)imageData
                          name:(NSString *)name
                    parameters:(nullable id)parameters
           duplicateParameters:(nullable id)duplicateParameters
                 duplicateType:(HTTPManager_DuplicateType)duplicateType
                  hudAnimation:(BOOL)hudAnimation
                       headers:(nullable NSDictionary <NSString *, NSString *> *)headers
             requestSerializer:(nullable AFHTTPRequestSerializer *)requestSerializer
                      progerss:(nullable void(^)(NSProgress *uploadProgress))progress
                       success:(nullable void(^)(NSURLSessionTask *task,id _Nullable responseObject))success
                       failure:(nullable void(^)(NSURLSessionTask *_Nullable task,NSError *error))failure{
    return [self POST:urlString
       imageDataArray:@[imageData]
                 name:name
           parameters:parameters
  duplicateParameters:duplicateParameters
        duplicateType:duplicateType
         hudAnimation:hudAnimation
              headers:headers
    requestSerializer:requestSerializer
             progerss:progress
              success:success
              failure:failure];
}

/**
 *  上传多张图片
 */
+ (NSURLSessionDataTask *)POST:(NSString *)urlString
                imageDataArray:(NSArray <NSData *> *)imageDataArray
                          name:(NSString *)name
                    parameters:(nullable id)parameters
           duplicateParameters:(nullable id)duplicateParameters
                 duplicateType:(HTTPManager_DuplicateType)duplicateType
                  hudAnimation:(BOOL)hudAnimation
                       headers:(nullable NSDictionary <NSString *, NSString *> *)headers
             requestSerializer:(nullable AFHTTPRequestSerializer *)requestSerializer
                      progerss:(nullable void(^)(NSProgress *uploadProgress))progress
                       success:(nullable void(^)(NSURLSessionTask *task,id _Nullable responseObject))success
                       failure:(nullable void(^)(NSURLSessionTask *_Nullable task,NSError *error))failure{
    
    if (![self canContiueRequestWithUrlString:urlString parameters:duplicateParameters duplicateType:duplicateType failure:failure]) {
        return nil;
    }
    
    AFHTTPSessionManager *manager = [XNHTTPSessionManager sharedHttpPostSessionManager];
    if (requestSerializer) {
        manager.requestSerializer = requestSerializer;
    } else {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    for (NSString *headerField in headers.keyEnumerator) {
        [manager.requestSerializer setValue:headers[headerField] forHTTPHeaderField:headerField];
    }
    
    //创建请求任务
    NSURLSessionDataTask *sessionDataTask = nil;
    
    if (hudAnimation) {
        [SVProgressHUD show];
    }
    
    sessionDataTask = [manager POST:urlString
                         parameters:parameters
          constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
              [imageDataArray enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  if (obj) {
                      //enumerateObjectsUsingBlock方式添加自动释放池中，一次上传结束即释放临时变量，处理内存峰值及优化内存使用
                      [formData appendPartWithFileData:obj name:name fileName:@"image.jpeg" mimeType:@"image/jpeg"];
                  }
              }];
          }
                           progress:^(NSProgress * _Nonnull uploadProgress) {
                               //上传进度
                               if (progress) {
                                   progress(uploadProgress);
                               }
                               
                           }
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSLog(@"-----url = %@,\n param = %@,\n header = %@,\n responseObject = %@",urlString,parameters,headers,responseObject);

                                [self endSVProgressHUDWithHudAnimation:hudAnimation];
                                [self removeRequestCacheWithUrl:urlString Param:duplicateParameters duplicateType:duplicateType];
                                if (responseObject) {
                                    if ([XNHTTPManage httpManager].successOperating) {
                                        BOOL isContinue = [XNHTTPManage httpManager].successOperating(responseObject);
                                        if (!isContinue) { return ; }
                                    }
                                    if (success) {
                                        success(task, responseObject);
                                    }
                                }
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"-----url = %@,\n param = %@,\n header = %@,\n error = %@",urlString,parameters,headers,error);

                                [self endSVProgressHUDWithHudAnimation:hudAnimation];
                                [self removeRequestCacheWithUrl:urlString Param:duplicateParameters duplicateType:duplicateType];
                                if (failure) {
                                    if ([XNHTTPManage httpManager].failureOperating) {
                                        BOOL isContinue = [XNHTTPManage httpManager].failureOperating(error);
                                        if (!isContinue) { return ; }
                                    }
                                    if (failure) {
                                        failure(task, error);
                                    }
                                }
                            }];
    
    [self addRequestCacheWithUrl:urlString Param:duplicateParameters SessionDataTask:sessionDataTask duplicateType:duplicateType];
    return sessionDataTask;
}


#pragma mark - 私有方法
/**
 * 针对请求重复时的不同情况作处理 判断是否继续执行请求
 */
+ (BOOL)canContiueRequestWithUrlString:(NSString *)urlString
                            parameters:(nullable id)parameters
                         duplicateType:(HTTPManager_DuplicateType)duplicateType
                              failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    switch (duplicateType) {
        case DuplicateType_NotHandle:
            return YES;
            break;
            
            //不是第一次请求则取消请求
        case DuplicateType_SingleRequest:
            if ([self requestRepeatedJudgmentWithUrl:urlString Param:parameters]) {
                if (failure) {
                    NSError *err = [[NSError alloc] initWithDomain:@"SingleRequestFailed" code:3 userInfo:nil];
                    failure(nil,err);
                }
                return NO;
            }
            break;
            
            //之前请求未完成，取消当前请求
        case DuplicateType_CancelCurrentRequest:
            if ([self requestRepeatedJudgmentWithUrl:urlString Param:parameters]) {
                if (failure) {
                    NSError *err = [[NSError alloc] initWithDomain:@"CancelCurrentRequest" code:2 userInfo:nil];
                    failure(nil,err);
                }
                return NO;
            }
            break;
            
            //之前请求未完成，取消之前请求重新提交
        case DuplicateType_CancelPreviousRequest:
            if ([self requestRepeatedJudgmentWithUrl:urlString Param:parameters]) {
                
                NSString *md5String = [self md5StringWithUrlString:urlString Params:parameters];
                NSURLSessionDataTask *task = [[XNHTTPManage httpManager].requestCache objectForKey:md5String];
                
                if (task == nil) {
                    [[XNHTTPManage httpManager].requestCache removeObjectForKey:md5String];
                } else {
                    [[XNHTTPManage httpManager].requestCache removeObjectForKey:md5String];
                    [task cancel];
                }
                return YES;
            }
            break;
            
        default:
            break;
    }
    return YES;
}

/**
 * 将当前请求与请求缓存中的数据对比,判断是否是重复请求
 */
+ (BOOL)requestRepeatedJudgmentWithUrl:(NSString *)url Param:(nullable id)param{
    NSString *md5String = [self md5StringWithUrlString:url Params:param];
    __block BOOL isRepeated = NO;
    
    [[XNHTTPManage httpManager].requestCache enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSURLSessionDataTask * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:md5String]) {
            isRepeated = YES;
            *stop = YES;
        }
    }];
    
    return isRepeated;
}

/**
 * 添加请求缓存
 */
+ (void)addRequestCacheWithUrl:(NSString *)url Param:(nullable id)param SessionDataTask:(NSURLSessionDataTask *)sessionDataTask duplicateType:(HTTPManager_DuplicateType)duplicateType{
    if (duplicateType != DuplicateType_NotHandle) {
        NSString *md5String = [self md5StringWithUrlString:url Params:param];
        [[XNHTTPManage httpManager].requestCache setObject:sessionDataTask forKey:md5String];
    }
}

/**
 * 移除请求缓存
 */
+ (void)removeRequestCacheWithUrl:(NSString *)url Param:(nullable id)param duplicateType:(HTTPManager_DuplicateType)duplicateType{
    if (duplicateType != DuplicateType_NotHandle) {
        NSString *md5String = [self md5StringWithUrlString:url Params:param];
        [[XNHTTPManage httpManager].requestCache removeObjectForKey:md5String];
    }
}

/**
 * 将url与参数字符串转为md5字符串
 */
+ (NSString *)md5StringWithUrlString:(NSString *)urlString Params:(nullable id)params{
    NSString *string = [NSString stringWithFormat:@"url=%@,params=%@",urlString,[self dictionaryToJson:params]];
    
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
}

/**
 * 字典转json格式字符串  字典为nil时返回@""
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic{
    if(dic){
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return @"";
}

+ (void)endSVProgressHUDWithHudAnimation:(BOOL)hudAnimation{
    if (hudAnimation) {
        [SVProgressHUD dismiss];
    }
}

@end
