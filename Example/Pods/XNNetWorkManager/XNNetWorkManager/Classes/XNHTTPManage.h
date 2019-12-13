//
//  XNHTTPManage.h
//  XNNetWorkManager
//
//  Created by Luigi on 2019/6/27.
//  Copyright © 2019 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * kNetWorkErrorTip;//网络请求错误提示文字

typedef BOOL(^responseSuccessOperating)(id _Nullable kResponseObject);
typedef BOOL(^responseFailureOperating)(NSError * _Nonnull kEror);

typedef NS_ENUM(NSInteger, HttpMethod) {
    HttpMethod_Post,
    HttpMethod_Get,
};

typedef NS_ENUM(NSInteger ,HTTPManager_DuplicateType) {
    /**不做处理,即可重复提交*/
    DuplicateType_NotHandle,
    
    /**取消之前的提交*/
    DuplicateType_CancelPreviousRequest,
    
    /**取消当前的提交*/
    DuplicateType_CancelCurrentRequest,
    
    /**整个app运行期间只发送一次*/
    DuplicateType_SingleRequest,
};

@class AFHTTPRequestSerializer;
@class AFSecurityPolicy;
@class AFHTTPSessionManager;

@interface XNHTTPManage : NSObject
@property (nonatomic, strong)   AFHTTPRequestSerializer             *serializer;
@property (nonatomic, strong)   AFSecurityPolicy                    *securityPolicy;
@property (nonatomic, copy, nullable)   NSDictionary                *headers;
@property (nonatomic, copy, nullable)   responseFailureOperating    failureOperating;//请求失败注入代码
@property (nonatomic, copy, nullable)   responseSuccessOperating    successOperating;//请求成功注入代码

+ (XNHTTPManage *)httpManager;
/**
 * 初始化网络请求模块
 */
- (void)httpManagerInitWithAFHTTPRequestSerializer:(nonnull AFHTTPRequestSerializer *)serializer
                                  AFSecurityPolicy:(nullable AFSecurityPolicy *)securityPolicy
                                           Headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                          ResponseSuccessOperating:(responseSuccessOperating)successOperating
                          ResponseFailureOperating:(responseFailureOperating)failureOperating;

/**
 *  @param urlString 网络URL
 *  @param parameters 参数
 *  @param requestSerializer 默认AFHTTPRequestSerializer 可自定义缓存类型，超时等配置
 *  @param securityPolicy 默认defaultPolicy
 *  @param headers 请求头配置
 *  @param progress 上传、下载进度
 *  @param success 成功block
 *  @param failure 失败block
 *  @param duplicateParameters 判断请求是否重复参数
 *  @param duplicateType 重复请求处理,默认为DuplicateType_NotHandle
 */


#pragma mark - 基础请求
/**
 * 基础POST请求
 */
+ (NSURLSessionDataTask *)Post:(NSString *)URLString
                    parameters:(nullable id)parameters
                  hudAnimation:(BOOL)hudAnimation
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

/**
 * 基础GET请求
 */
+ (NSURLSessionDataTask *)Get:(NSString *)URLString
                    parameters:(nullable id)parameters
                 hudAnimation:(BOOL)hudAnimation
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

#pragma mark - 配置AFHTTPSessionManager
/**
* Post配置requestSerializer Post: parameters: requestSerializer:: progress: success: failure:
*/
+ (NSURLSessionDataTask *)Post:(NSString *)URLString
       parameters:(nullable id)parameters
     hudAnimation:(BOOL)hudAnimation
requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
          success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
          failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

/**
 * Post配置requestSerializer Post: parameters: requestSerializer: headers: progress: success: failure:
 */
+ (NSURLSessionDataTask *)Post:(NSString *)URLString
                    parameters:(nullable id)parameters
                  hudAnimation:(BOOL)hudAnimation
             requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                       headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
/**
 * Post配置securityPolicy Post: parameters: securityPolicy: headers: progress: success: failure:
 */
+ (NSURLSessionDataTask *)Post:(NSString *)URLString
                    parameters:(nullable id)parameters
                  hudAnimation:(BOOL)hudAnimation
                securityPolicy:(AFSecurityPolicy *)securityPolicy
                       headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
/**
 * Post配置requestSerializer、securityPolicy和duplicateType Post: parameters: requestSerializer: securityPolicy: headers: duplicateType: progress: success: failure:
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
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;


/**
 * Get配置requestSerializer Get: parameters: requestSerializer: headers: progress: success: failure:
 */
+ (NSURLSessionDataTask *)Get:(NSString *)URLString
                    parameters:(nullable id)parameters
                 hudAnimation:(BOOL)hudAnimation
             requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                       headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
/**
 * Get配置securityPolicy Get: parameters: securityPolicy: headers: progress: success: failure:
 */
+ (NSURLSessionDataTask *)Get:(NSString *)URLString
                    parameters:(nullable id)parameters
                 hudAnimation:(BOOL)hudAnimation
                securityPolicy:(AFSecurityPolicy *)securityPolicy
                       headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
/**
 * Get配置requestSerializer、securityPolicy和duplicateType Get: parameters: requestSerializer: securityPolicy: headers: duplicateType: progress: success: failure:
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
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
#pragma mark - 根据httpMethod发送请求
/**
 * 直接调用AFNetWorking httpMethod: URLString: parameters: headers: manager: progress: success: failure:
 */
+ (nullable NSURLSessionDataTask *)httpMethod:(HttpMethod)httpMethod
                                    URLString:(NSString *)URLString
                                   parameters:(nullable id)parameters
                                 hudAnimation:(BOOL)hudAnimation
                                      headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                      manager:(AFHTTPSessionManager *)manager
                          duplicateParameters:(nullable id)duplicateParameters
                                duplicateType:(HTTPManager_DuplicateType)duplicateType
                                     progress:(nullable void(^)(NSProgress *uploadProgress))progress
                                      success:(nullable void(^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

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
                       failure:(nullable void(^)(NSURLSessionTask *_Nullable task,NSError *error))failure;

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
                       failure:(nullable void(^)(NSURLSessionTask *_Nullable task,NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
