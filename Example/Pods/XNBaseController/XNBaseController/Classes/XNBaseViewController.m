//
//  XNBaseViewController.m
//  XNBaseController_Example
//
//  Created by Luigi on 2019/7/4.
//  Copyright © 2019 yexiannan. All rights reserved.
//

#import "XNBaseViewController.h"

#define XNBaseControllerBundle [NSBundle bundleWithPath:[[NSBundle bundleForClass:[XNBaseViewController class]] pathForResource:@"XNBaseController" ofType:@"bundle"]]

@interface XNBaseViewController ()


@end

@implementation XNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ThemeColor(ColorType_Gary);
    [self configNavigationBar];
    
    
}

- (void)pushOrPresentViewControllerWithClassName:(NSString *)className{
    
    if (NSClassFromString(className) == nil) return;
    
    if (self.navigationController != nil) {
        [self.navigationController pushViewController:[[NSClassFromString(@"className") alloc] init] animated:YES];
    }else{
        [self presentViewController:[[NSClassFromString(@"className") alloc] init] animated:YES completion:nil];
    }
    
}

- (void)configNavigationBar{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationBar = [UIView new];
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(NavigationBarHeight);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.mas_topLayoutGuide).offset(NavigationBarHeight);
        }
    }];
    [self.view layoutIfNeeded];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:ThemeImage(@"back_arrow",XNBaseControllerBundle) forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(clickBaseBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.navigationBar);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = ThemeColor(ColorType_Black);
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationBar addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right);
        make.right.equalTo(self.navigationBar).offset(-50);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.navigationBar);
    }];
    
    self.lineView = [[UIView alloc] init];
    _lineView.backgroundColor = ThemeColor(ColorType_Gary);
    [self.navigationBar addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.navigationBar);
        make.height.offset(1);
    }];
}

- (void)clickBaseBackButton{
    if (self.navigationController != nil) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    NSLog(@"%@  dealloc",NSStringFromClass([self class]));
}

@end
