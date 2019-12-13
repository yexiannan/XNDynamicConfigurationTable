//
//  BaseTabBarController.m
//  UnionCar
//
//  Created by apple on 2018/9/4.
//  Copyright © 2018年 Luigi. All rights reserved.
//

#import "BaseTabBarController.h"
#import "UINavigationController+XNBaseNavigationController.h"
#import "MainTabBar.h"

@interface BaseTabBarController ()<MainTabBarDelegate>
@property (nonatomic, weak)   MainTabBar                        *mainTabBar;
@property (nonatomic, weak)   MainTabBarButton                  *selectedButton;
@end

@implementation BaseTabBarController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UIView *tabBar in self.tabBar.subviews) {
        if ([tabBar isKindOfClass:[UIControl class]]) {
            [tabBar removeFromSuperview];
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //适配曲面屏底部
    if (@available(iOS 11.0, *)) {
        self.mainTabBar.frame = CGRectMake(0, 0.5, SCREEN_WIDTH, self.tabBar.height);
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SetupMainTabBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changIndex:) name:Notification_ChangeTabbarIndex object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changIndex:(NSNotification *)notification
{
    NSInteger index = [notification.object integerValue];
    if (index == 0) {
        self.selectedIndex = index;
        [self tabBar:self.mainTabBar Button:self.mainTabBar.tabbarBtnArray[index]];
    }else{
        [self tabBar:self.mainTabBar Button:self.mainTabBar.tabbarBtnArray[index]];
        self.selectedIndex = index;
    }
}
- (void)SetupMainTabBar{
    //隐藏tabbar自带的uiimageview
    UITabBar *tabbar = [UITabBar appearance];
    [tabbar setBackgroundImage:[UIImage new]];
    [tabbar setShadowImage:[UIImage new]];
    
    UIView *div         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    div.backgroundColor = cHEXCOLOR(0xcccccc);
    [self.tabBar addSubview:div];
    [self.tabBar bringSubviewToFront:div];
    
    MainTabBar *mainTabBar = [[MainTabBar alloc] init];
    mainTabBar.frame       = CGRectMake(0, 0.5, SCREEN_WIDTH, TabBarHeight);
    mainTabBar.delegate    = self;
    [self.tabBar addSubview:mainTabBar];
    [self.tabBar bringSubviewToFront:mainTabBar];
    _mainTabBar = mainTabBar;
    
}

- (void)setTabBarInfosArray:(NSArray<XNBaseTabBarInfoModel *> *)tabBarInfosArray{
    _tabBarInfosArray = tabBarInfosArray;
    [tabBarInfosArray enumerateObjectsUsingBlock:^(XNBaseTabBarInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self SetupChildVc:obj.vc
                     title:obj.title
                     image:obj.image
             selectedImage:obj.selectedImage
          TitleNormalColor:obj.titleNormalColor
        TitleSelectedColor:obj.titleSelectedColor
                 TitleFont:obj.titleFont];
    }];
}

- (void)SetupChildVc:(UIViewController *)childVc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage TitleNormalColor:(UIColor *)titleNormalColor TitleSelectedColor:(UIColor *)titleSelectedColor TitleFont:(UIFont *)titleFont{
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    nav.navigationBar.hidden = YES;
    
    image?[childVc.tabBarItem setImage:image]:nil;
    selectedImage?[childVc.tabBarItem setSelectedImage:selectedImage]:nil;
    
    childVc.tabBarItem.title = STRING_Safe(title);
    
    [self.mainTabBar addTabBarButtonWithTabBarItem:childVc.tabBarItem
                                  TitleNormalColor:titleNormalColor ? titleNormalColor : COLOR_PLACEHOLDER
                                TitleSelectedColor:titleSelectedColor ? titleSelectedColor : COLOR_BLACK_2C
                                         TitleFont:titleFont ? titleFont : MFont(10)];
    [self addChildViewController:nav];
}

//重写此方法以实现权限判断
- (void)permissionJudgmentWithTabBarIndex:(NSInteger)index Result:(void (^)(BOOL))result{
    result(YES);
}

#pragma mark --------------------mainTabBar delegate
- (void)tabBar:(MainTabBar *)tabBar Button:(MainTabBarButton *)tabBarBtn{
    [self permissionJudgmentWithTabBarIndex:tabBarBtn.tag Result:^(BOOL hasPermission) {
        if (hasPermission) {
            self.selectedButton.selected = NO;
            tabBarBtn.selected = YES;
            self.selectedButton = tabBarBtn;
            
            self.selectedIndex = tabBarBtn.tag;
        }
        
    }];
    
    
}

- (void)popToRootViewController{
    [self.tabBarInfosArray enumerateObjectsUsingBlock:^(XNBaseTabBarInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.vc.navigationController popToRootViewControllerAnimated:NO];
    }];
    
    self.selectedIndex = 0;
    [self tabBar:self.mainTabBar Button:self.mainTabBar.tabbarBtnArray[0]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
