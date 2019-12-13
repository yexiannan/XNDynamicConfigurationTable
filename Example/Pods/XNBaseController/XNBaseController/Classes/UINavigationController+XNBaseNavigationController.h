//
//  UINavigationController+XNBaseNavigationController.h
//  XNBaseController_Example
//
//  Created by Luigi on 2019/7/5.
//  Copyright © 2019 yexiannan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (XNBaseNavigationController)
/**
 *  获取当前VC
 */
+ (UIViewController *)currentVC;
/**
 *  获取当前NC
 */
+ (UINavigationController *)currentNC;
@end

NS_ASSUME_NONNULL_END
