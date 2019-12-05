//
//  DCTBaseTableView.m
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/4.
//

#import "DCTBaseTableView.h"

@interface DCTBaseTableView ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitButton;
@end

@implementation DCTBaseTableView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutUI];
}

#pragma mark - LayoutUI
- (void)createUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = COLOR_GARY_BG;
    _tableView.separatorColor = COLOR_GARY_BG;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if(@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.submitButton = [UIButton new];
    [_submitButton setBackgroundImage:[UIImage imageWithColor:cHEXCOLOR(#004FA1)] forState:UIControlStateNormal];
    [_submitButton setTitle:@"保存" forState:UIControlStateNormal];
    [_submitButton.titleLabel setFont:MFont(18)];
    [_submitButton setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton setHidden:YES];
    
    
    
}

- (void)layoutUI {
    
}

@end
