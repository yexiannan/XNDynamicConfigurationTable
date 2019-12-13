//
//  XNBaseViewController.h
//  XNBaseController_Example
//
//  Created by Luigi on 2019/7/4.
//  Copyright © 2019 yexiannan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ViewControllerBlock)(NSDictionary * _Nullable params);

@interface XNBaseViewController : UIViewController
@property (nonatomic ,strong) UIView   *navigationBar;
@property (nonatomic ,strong) UIButton *backButton;
@property (nonatomic ,strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIView   *lineView;

@property (nonatomic, copy) ViewControllerBlock viewControllerBlock;

/**
 *  根据类名打开指定的页面
 */
- (void)pushOrPresentViewControllerWithClassName:(NSString *)className;

- (void)clickBaseBackButton;

@end

NS_ASSUME_NONNULL_END
