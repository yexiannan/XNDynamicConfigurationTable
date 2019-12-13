//
//  MainTabBarButton.h
//  三人喜
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 微成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarButton : UIButton
@property(nonatomic, strong)UITabBarItem *tabBarItem;
- (instancetype)initWithTitleNormalColor:(UIColor *)titleNormalColor TitleSelectedColor:(UIColor *)titleSelectedColor TitleFont:(UIFont *)titleFont;
@end
