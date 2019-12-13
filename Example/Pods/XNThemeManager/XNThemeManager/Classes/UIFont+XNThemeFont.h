//
//  UIFont+XNThemeFont.h
//  XNThemeManager
//
//  Created by Luigi on 2019/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define TLFont(size) [UIFont lightFontWithAutoSize:size minSize:size MaxSize:size]
#define TMFont(size) [UIFont mediumFontWithAutoSize:size minSize:size MaxSize:size]
#define TRFont(size) [UIFont regularFontWithAutoSize:size minSize:size MaxSize:size]
#define TBFont(size) [UIFont boldFontWithAutoSize:size minSize:size MaxSize:size]

#define TALFont(size,minSize,maxSize) [UIFont lightFontWithAutoSize:size minSize:minSize MaxSize:maxSize]
#define TAMFont(size,minSize,maxSize) [UIFont mediumFontWithAutoSize:size minSize:minSize MaxSize:maxSize]
#define TARFont(size,minSize,maxSize) [UIFont regularFontWithAutoSize:size minSize:minSize MaxSize:maxSize]
#define TABFont(size,minSize,maxSize) [UIFont boldFontWithAutoSize:size minSize:minSize MaxSize:maxSize]

@interface UIFont (XNThemeFont)
//以375*667的屏幕大小为基准 对字体进行缩放 maxSize为0时不做限制
+ (instancetype)lightThemeFontWithAutoSize:(CGFloat)size minSize:(CGFloat)minSize MaxSize:(CGFloat)maxSize;
+ (instancetype)mediumThemeFontWithAutoSize:(CGFloat)size minSize:(CGFloat)minSize MaxSize:(CGFloat)maxSize;
+ (instancetype)regularThemeFontWithAutoSize:(CGFloat)size minSize:(CGFloat)minSize MaxSize:(CGFloat)maxSize;
+ (instancetype)boldThemeFontWithAutoSize:(CGFloat)size minSize:(CGFloat)minSize MaxSize:(CGFloat)maxSize;
@end

NS_ASSUME_NONNULL_END
