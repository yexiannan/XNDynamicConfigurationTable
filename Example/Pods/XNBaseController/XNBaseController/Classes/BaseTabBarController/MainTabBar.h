//
//  MainTabBar.h
//  三人喜
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 微成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarButton.h"
@class MainTabBar;
@protocol MainTabBarDelegate <NSObject>

@optional
- (void)tabBar:(MainTabBar *)tabBar Button:(MainTabBarButton *)tabBarBtn;

@end
@interface MainTabBar : UIView

@property(nonatomic, strong)NSMutableArray *tabbarBtnArray;
- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem TitleNormalColor:(UIColor *)titleNormalColor TitleSelectedColor:(UIColor *)titleSelectedColor TitleFont:(UIFont *)titleFont;
@property(nonatomic, weak)id <MainTabBarDelegate>delegate;

@end
