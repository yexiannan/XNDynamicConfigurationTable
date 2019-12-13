//
//  UIFont+XNThemeFont.m
//  XNThemeManager
//
//  Created by Luigi on 2019/12/9.
//

#import "UIFont+XNThemeFont.h"
#import "XNThemeManager.h"

@implementation UIFont (XNThemeFont)
+ (instancetype)lightThemeFontWithAutoSize:(CGFloat)size minSize:(CGFloat)minSize MaxSize:(CGFloat)maxSize{
    CGFloat scaleSize = [self calculateFontSizeWithSize:size minSize:minSize MaxSize:maxSize];
    return [UIFont fontWithName:[[XNThemeManager themeManager] lightFontName] size:scaleSize];
}

+ (instancetype)mediumThemeFontWithAutoSize:(CGFloat)size minSize:(CGFloat)minSize MaxSize:(CGFloat)maxSize {
    CGFloat scaleSize = [self calculateFontSizeWithSize:size minSize:minSize MaxSize:maxSize];
    return [UIFont fontWithName:[[XNThemeManager themeManager] mediumFontName] size:scaleSize];
}

+ (instancetype)regularThemeFontWithAutoSize:(CGFloat)size minSize:(CGFloat)minSize MaxSize:(CGFloat)maxSize {
    CGFloat scaleSize = [self calculateFontSizeWithSize:size minSize:minSize MaxSize:maxSize];
    return [UIFont fontWithName:[[XNThemeManager themeManager] normalFontName] size:scaleSize];
}

+ (instancetype)boldThemeFontWithAutoSize:(CGFloat)size minSize:(CGFloat)minSize MaxSize:(CGFloat)maxSize {
    CGFloat scaleSize = [self calculateFontSizeWithSize:size minSize:minSize MaxSize:maxSize];
    return [UIFont boldSystemFontOfSize:scaleSize];
}

+ (CGFloat)calculateFontSizeWithSize:(CGFloat)size minSize:(CGFloat)minSize MaxSize:(CGFloat)maxSize{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat scaleSize = size * floorf(screenWidth/375.0);
    
    if (maxSize > 0) { //是否有设置最大值
        
        if (minSize < maxSize) { //最大值和最小值区间的有效性判断
            
            if (size <= minSize) {
                scaleSize = minSize;
            }
            if (size >= maxSize) {
                scaleSize = maxSize;
            }
            
        } else {
             scaleSize = size;
        }
        
    } else {
        
        if (minSize > 0) { //是否有设置最小值
            
            if (size < minSize) {
                scaleSize = minSize;
            }
            
        } else {
            scaleSize = size;
        }
        
    }
    
    return scaleSize;
}

+ (NSUInteger) deviceSystemMajorVersion {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion]
                                       componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}
@end
