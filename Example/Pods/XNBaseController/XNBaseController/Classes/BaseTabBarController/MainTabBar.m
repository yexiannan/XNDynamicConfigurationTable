//
//  MainTabBar.m
//  三人喜
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 微成. All rights reserved.
//

#import "MainTabBar.h"
@interface MainTabBar ()

@property(nonatomic, weak)MainTabBarButton *selectedButton;

@end
@implementation MainTabBar
- (NSMutableArray *)tabbarBtnArray{
    if (!_tabbarBtnArray) {
        _tabbarBtnArray = [NSMutableArray array];
    }
    return  _tabbarBtnArray;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnY = 0;
    CGFloat btnW = self.frame.size.width/(self.subviews.count);
    CGFloat btnH = 49;
    for (int nIndex = 0; nIndex < self.tabbarBtnArray.count; nIndex++) {
        CGFloat btnX = btnW * nIndex;
        MainTabBarButton *tabBarBtn = self.tabbarBtnArray[nIndex];
        tabBarBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        tabBarBtn.tag = nIndex;
    }
}
- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem TitleNormalColor:(UIColor *)titleNormalColor TitleSelectedColor:(UIColor *)titleSelectedColor TitleFont:(UIFont *)titleFont{
    MainTabBarButton *tabBarBtn = [[MainTabBarButton alloc] initWithTitleNormalColor:titleNormalColor TitleSelectedColor:titleSelectedColor TitleFont:titleFont];
    tabBarBtn.tabBarItem = tabBarItem;
    [tabBarBtn addTarget:self action:@selector(ClickTabBarButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tabBarBtn];
    [self.tabbarBtnArray addObject:tabBarBtn];
    
    //default selected first one
    if (self.tabbarBtnArray.count == 1) {
        [self ClickTabBarButton:tabBarBtn];
    }
}

- (void)ClickTabBarButton:(MainTabBarButton *)tabBarBtn{
    if ([self.delegate respondsToSelector:@selector(tabBar:Button:)]) {
        [self.delegate tabBar:self Button:tabBarBtn];
        
    }
}


@end
