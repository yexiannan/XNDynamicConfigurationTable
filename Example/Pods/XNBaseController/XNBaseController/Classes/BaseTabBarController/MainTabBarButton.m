//
//  MainTabBarButton.m
//  三人喜
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 微成. All rights reserved.
//

#import "MainTabBarButton.h"
//image ratio
#define TabBarButtonImageRatio 0.6

@interface MainTabBarButton ()
@property (nonatomic, strong) UIColor   *titleNormalColor;
@property (nonatomic, strong) UIColor   *titleSelectedColor;
@property (nonatomic, strong) UIFont    *titleFont;
@end

@implementation MainTabBarButton


- (instancetype)initWithTitleNormalColor:(UIColor *)titleNormalColor TitleSelectedColor:(UIColor *)titleSelectedColor TitleFont:(UIFont *)titleFont{
    self = [super init];
    if (self) {
        self.titleNormalColor = titleNormalColor;
        self.titleSelectedColor = titleSelectedColor;
        self.titleFont = titleFont;
        
        //只需要设置一次的放置在这里
        self.imageView.contentMode = UIViewContentModeBottom;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = titleFont;
        [self setTitleColor:titleSelectedColor forState:UIControlStateSelected];
        [self setTitleColor:titleNormalColor forState:UIControlStateNormal];
        
    }
    return self;
}

//重写该方法可以去除长按按钮时出现的高亮效果
- (void)setHighlighted:(BOOL)highlighted
{
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height*TabBarButtonImageRatio;
    
    return CGRectMake(0, 0, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height*TabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
}

- (void)setTabBarItem:(UITabBarItem *)tabBarItem
{
    _tabBarItem = tabBarItem;
    [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
    [self setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
    [self setImage:self.tabBarItem.image forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.selectedImage forState:UIControlStateSelected];
}

@end
