//
//  BaseTabBarController.h
//  UnionCar
//
//  Created by apple on 2018/9/4.
//  Copyright © 2018年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNBaseTabBarInfoModel.h"

#define Notification_ChangeTabbarIndex           @"ChangeTabbarIndex"

@interface BaseTabBarController : UITabBarController
@property (nonatomic, copy) NSArray <XNBaseTabBarInfoModel *> *tabBarInfosArray;

- (void)popToRootViewController;
/**
 * 在子类中重写此方法以实现点击tabbar权限判断逻辑
 */
- (void)permissionJudgmentWithTabBarIndex:(NSInteger)index Result:(void (^)(BOOL hasPermission))result;
@end
