//
//  XNThemeManager.h
//  XNThemeManager
//
//  Created by Luigi on 2019/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define Notification_ChangeThemeType            @"Notification_ChangeThemeType"
#define Notification_ChangeFontType             @"Notification_ChangeFontType"

#define ThemeColor(colorType) [[XNThemeManager themeManager] colorWithThemeColorType:colorType  Alpha:1.f]
#define aThemeColor(colorType,alpha) [[XNThemeManager themeManager] colorWithThemeColorType:colorType  Alpha:alpha]

#define ThemeImage(imageName,bundle) [[XNThemeManager themeManager] imageWithImageName:imageName Bundle:bundle]

typedef NS_ENUM(NSInteger ,XNThemeType) {
    XNThemeType_Default,
};

typedef NS_ENUM(NSInteger ,XNThemeColorType) {
    /**
     * 主题色
     */
    ColorType_Main,
    ColorType_MainBlod,
    ColorType_MainLight,

    /**
     * 辅助色
     */
    ColorType_Auxiliary,
    ColorType_AuxiliaryBlod,
    ColorType_AuxiliaryLight,

    /**
     * 点缀色
     */
    ColorType_Embellishment,
    ColorType_EmbellishmentBlod,
    ColorType_EmbellishmentLight,

    /**
     * 黑色
     */
    ColorType_Black,
    ColorType_BlackLight,
    ColorType_BlackBlod,

    /**
     * 灰色
     */
    ColorType_Gary,
    ColorType_GaryLight,
    ColorType_GaryBlod,
};

typedef NS_ENUM(NSInteger ,XNThemeFontType) {
    FontType_Default,
};

@interface XNThemeManager : NSObject
@property (nonatomic, assign) XNThemeType themeType;
@property (nonatomic, assign) XNThemeFontType fontType;

+ (XNThemeManager *)themeManager;

- (UIColor *)colorWithThemeColorType:(XNThemeColorType)colorType Alpha:(CGFloat)alpha;
//获取主题色图片 图片命名规则：imageName_ThemeType 如：msgCenterIcon_blue、msgCenterIcon_unionCarFinancial
- (UIImage *)imageWithImageName:(NSString *)imageName Bundle:(NSBundle *)bundle;
- (NSString *)normalFontName;
- (NSString *)lightFontName;
- (NSString *)mediumFontName;

@end

NS_ASSUME_NONNULL_END
