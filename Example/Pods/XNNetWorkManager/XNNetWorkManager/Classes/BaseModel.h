//
//  BaseModel.h
//  XNBaseController
//
//  Created by Luigi on 2019/7/5.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject
//网络请求状态标示码
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger errcode;
//网络请求状态内容
@property (copy, nonatomic) NSString* msg;
@end

NS_ASSUME_NONNULL_END
