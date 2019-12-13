#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BaseTabBarController.h"
#import "MainTabBar.h"
#import "MainTabBarButton.h"
#import "XNBaseTabBarInfoModel.h"
#import "UINavigationController+XNBaseNavigationController.h"
#import "XNBaseViewController.h"

FOUNDATION_EXPORT double XNBaseControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char XNBaseControllerVersionString[];

