//
//  XNThemeManager.m
//  XNThemeManager
//
//  Created by Luigi on 2019/12/9.
//

#import "XNThemeManager.h"

@implementation XNThemeManager
+ (XNThemeManager *)themeManager {
    static dispatch_once_t oncetoken;
    static  XNThemeManager *shareinstance;
    dispatch_once(&oncetoken, ^{
        shareinstance = [[self alloc] init];
    });
    return shareinstance;
}

- (void)setThemeType:(XNThemeType)themeType {
    _themeType = themeType;
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ChangeThemeType object:nil];
}

- (void)setFontType:(XNThemeFontType)fontType {
    _fontType = fontType;
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ChangeFontType object:nil];
}

#pragma mark - 获取颜色
- (UIColor *)colorWithThemeColorType:(XNThemeColorType)colorType Alpha:(CGFloat)alpha {
    switch (self.themeType) {
        case XNThemeType_Default:
            return [self defaultThemeColorWithColorType:colorType Alpha:alpha];
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark - 获取字体名
- (NSString *)normalFontName {
    switch (self.fontType) {
        case FontType_Default:
            return [self deviceSystemMajorVersion] < 9 ? @"HelveticaNeue" : @"PingFang-SC-Regular";
            break;
            
        default:
            break;
    }
}

- (NSString *)lightFontName {
    switch (self.fontType) {
        case FontType_Default:
            return [self deviceSystemMajorVersion] < 9 ? @"HelveticaNeue-Light" : @"PingFang-SC-Light";
            break;
            
        default:
            break;
    }
}

- (NSString *)mediumFontName {
    switch (self.fontType) {
        case FontType_Default:
            return [self deviceSystemMajorVersion] < 9 ? @"HelveticaNeue-Medium" : @"PingFang-SC-Medium";
            break;
            
        default:
            break;
    }
}

#pragma mark - 获取图片
- (UIImage *)imageWithImageName:(NSString *)imageName Bundle:(NSBundle *)bundle {
    //尝试获取主题色图片
    NSString *themeImageName = @"";
    switch (self.themeType) {
            
        case XNThemeType_Default:
            themeImageName = [NSString stringWithFormat:@"%@",imageName];
            break;
            
        default:
            break;
    }
    
    UIImage *image = [UIImage imageNamed:themeImageName inBundle:bundle compatibleWithTraitCollection:nil];
    
    
    if (image) {
        return image;
    } else {
        
        //主题色图片获取失败，使用默认图片
        return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];

    }
    
}

#pragma mark - 配置各主题色
- (UIColor *)defaultThemeColorWithColorType:(XNThemeColorType)colorType Alpha:(CGFloat)alpha {
    switch (colorType) {
        case ColorType_Main:
            return [UIColor colorWithRed:0.f/255.f green:155.f/255.f blue:255.f/255.f alpha:alpha];
            break;
        case ColorType_MainBlod:
            return [UIColor colorWithRed:0.f/255.f green:155.f/255.f blue:255.f/255.f alpha:alpha];
            break;
        case ColorType_MainLight:
            return [UIColor colorWithRed:0.f/255.f green:215.f/255.f blue:255.f/255.f alpha:alpha];
            break;
            
            
        case ColorType_Auxiliary:
            return [UIColor colorWithRed:255.f/255.f green:68.f/255.f blue:68.f/255.f alpha:alpha];
            break;
        case ColorType_AuxiliaryBlod:
            return [UIColor colorWithRed:255.f/255.f green:68.f/255.f blue:68.f/255.f alpha:alpha];
            break;
        case ColorType_AuxiliaryLight:
            return [UIColor colorWithRed:255.f/255.f green:68.f/255.f blue:68.f/255.f alpha:alpha];
            break;
            
        case ColorType_Embellishment:
            return [UIColor colorWithRed:0.f/255.f green:215.f/255.f blue:255.f/255.f alpha:alpha];
            break;
        case ColorType_EmbellishmentBlod:
            return [UIColor colorWithRed:0.f/255.f green:215.f/255.f blue:255.f/255.f alpha:alpha];
            break;
        case ColorType_EmbellishmentLight:
            return [UIColor colorWithRed:0.f/255.f green:215.f/255.f blue:255.f/255.f alpha:alpha];
            break;
            
        case ColorType_Black:
            return [UIColor colorWithRed:25.f/255.f green:25.f/255.f blue:25.f/255.f alpha:alpha];
            break;
        case ColorType_BlackLight:
            return [UIColor colorWithRed:25.f/255.f green:25.f/255.f blue:25.f/255.f alpha:alpha];
            break;
        case ColorType_BlackBlod:
            return [UIColor colorWithRed:25.f/255.f green:25.f/255.f blue:25.f/255.f alpha:alpha];
            break;
            
        case ColorType_Gary:
            return [UIColor colorWithRed:163.f/255.f green:163.f/255.f blue:163.f/255.f alpha:alpha];
            break;
        case ColorType_GaryLight:
            return [UIColor colorWithRed:232.f/255.f green:232.f/255.f blue:232.f/255.f alpha:alpha];
            break;
        case ColorType_GaryBlod:
            return [UIColor colorWithRed:117.f/255.f green:117.f/255.f blue:117.f/255.f alpha:alpha];
            break;
        

        default:
            return nil;
            break;
    }
}

- (NSUInteger) deviceSystemMajorVersion {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion]
                                       componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

@end
