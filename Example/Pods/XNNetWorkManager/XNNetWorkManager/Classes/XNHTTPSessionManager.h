//
//  XNHTTPSessionManager.h
//  XNNetWorkManager
//
//  Created by Luigi on 2019/6/27.
//  Copyright © 2019 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@class AFHTTPSessionManager;

@interface XNHTTPSessionManager : NSObject

/*
 *  使用单例类创建请求解决内存泄漏
 *  使用两个，解决get后无法post的问题
 */
+(AFHTTPSessionManager *)sharedHttpPostSessionManager;
+(AFHTTPSessionManager *)sharedHttpGetSessionManager;
@end

NS_ASSUME_NONNULL_END
