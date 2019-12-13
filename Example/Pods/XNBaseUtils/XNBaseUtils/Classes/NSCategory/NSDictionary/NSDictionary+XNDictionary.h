//
//  NSDictionary+XNDictionary.h
//  XNUtils_Example
//
//  Created by Luigi on 2019/7/1.
//  Copyright © 2019 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (XNDictionary)
/**
 * 字典转json格式字符串  字典为nil时返回@""
 */
- (NSString *)dictionaryToJson;
@end

NS_ASSUME_NONNULL_END
