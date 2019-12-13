//
//  NSString+XNString.h
//  Caiyicai
//
//  Created by apple on 2019/1/18.
//  Copyright © 2019 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define STRING_IsNull(string) [NSString stringIsNull:string]
#define STRING_IsCorrect(NSString,NSCharacterSet) [NSString stringIsCorrect:NSString Set:NSCharacterSet]
#define STRING_Safe(string) (STRING_IsNull(string) ? @"" : string)

@interface NSString (XNString)
/**
 *  字符串非空验证
 */
+ (BOOL)stringIsNull:(id)string;
/**
 *  字符串有效性验证
 */
+ (BOOL)stringIsCorrect:(NSString *)string Set:(NSCharacterSet *)set;
/**
 * 是否为小数
 */
- (BOOL)stringIsDecimal;
/**
 * 是否为整数
 */
- (BOOL)stringIsInt;
/**
 * 是否为字母加数字
 */
- (BOOL)stringIsNumberOrLetters;

/**
 *  删除字符串两端空格
 */
- (NSString *)stringByTrim;
/**
 * 转换为md5字符串
 */
- (NSString *)md5String;
/**
 *  输入字符串,字体大小,限制宽度 得到Size
 */
+ (CGSize)getSizeWithString:(NSString *)aStr withFont:(UIFont *)font LimitWidth:(CGFloat)aLimitWidth;
@end

NS_ASSUME_NONNULL_END
