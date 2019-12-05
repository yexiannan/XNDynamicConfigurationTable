//
//  XNHTTPSessionManager.m
//  XNNetWorkManager
//
//  Created by Luigi on 2019/6/27.
//  Copyright © 2019 Luigi. All rights reserved.
//

#import "XNHTTPSessionManager.h"

static AFHTTPSessionManager *postManager;
static AFHTTPSessionManager *getManager;

@implementation XNHTTPSessionManager
+(AFHTTPSessionManager *)sharedHttpPostSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        postManager = [AFHTTPSessionManager manager];
        
    });
    return postManager;
}

+(AFHTTPSessionManager *)sharedHttpGetSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getManager = [AFHTTPSessionManager manager];
    });
    return getManager;
}

@end
