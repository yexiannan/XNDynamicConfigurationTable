//
//  DCTBaseTableView.m
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/4.
//

#import "DCTBaseTableView.h"
#import "DCTBaseTableViewModel.h"

@interface DCTBaseTableView ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) DCTBaseTableViewModel *viewModel;

@end

@implementation DCTBaseTableView

- (instancetype)initWithConfigurationInfo:(NSDictionary *)configurationInfo
                                SaveBlock:(id)saveBlock
                                NextBlock:(id)nextBlock
                            DataInfoBlock:(DataInfoBlock)dataInfoBlock
                            UserInfoBlock:(UserInfoBlock)userInfoBlock
                             DataInfoBind:(DataInfoBind)dataInfoBind
                             UserInfoBind:(UserInfoBind)userInfoBind
                         SetDataInfoBlock:(SetDataInfoBlock)setDataInfoBlock {
    
    if (self = [super init]) {
        
        self.viewModel = [[DCTBaseTableViewModel alloc] initWithConfigurationInfo:configurationInfo
                                                                        SaveBlock:saveBlock
                                                                        NextBlock:nextBlock
                                                                    DataInfoBlock:dataInfoBlock
                                                                    UserInfoBlock:userInfoBlock
                                                                     DataInfoBind:dataInfoBind
                                                                     UserInfoBind:userInfoBind
                                                                 SetDataInfoBlock:setDataInfoBlock];
        
        [self createUI];
        [self subscribeSignal];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self layoutUI];
}

#pragma mark - 订阅信号
- (void)subscribeSignal {
    @weakify(self)
    //当根据配置表生成的表格结构变化时更新表格
    [[RACObserve(self, viewModel.tableViewConfiguration)
        deliverOnMainThread]
        subscribeNext:^(id  _Nullable x) {
        
            @strongify(self)
            NSLog(@"tableViewConfiguration change");

            [self.tableView reloadData];
        }
     ];
        
    //判断是否显示submitButton 并设置submitButton的title
    [[[RACSignal combineLatest:@[RACObserve(self, viewModel.canSave), RACObserve(self, viewModel.canNext)]
                        reduce:^id (NSNumber *canSave, NSNumber *canNext){
        
                            return @([canSave boolValue] || [canNext boolValue]);
                        }]
        deliverOnMainThread]
        subscribeNext:^(NSNumber *showSubmitButton) {
        
            @strongify(self)
            [self.submitButton setHidden:![showSubmitButton boolValue]];
        
            if (self.viewModel.canNext) {
                
                self.submitButton.title(@"下一步", UIControlStateNormal);
            }
            else {
                
                self.submitButton.title(@"保存", UIControlStateNormal);
            }
            [self layoutSubviews];
        }
     ];
    
    //submitButton点击事件
    [[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        
        x.enabled = NO;
    }] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        [[self.viewModel.submitCommand execute:nil] subscribeError:^(NSError * _Nullable error) {
            
            x.enabled = YES;
        } completed:^{
            
            x.enabled = YES;
        }];
    }];
}

#pragma mark - LayoutUI
- (void)createUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = COLOR_GARY_BG;
    _tableView.separatorColor = COLOR_GARY_BG;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.delegate = self.viewModel;
    _tableView.dataSource = self.viewModel;
    _tableView.estimatedRowHeight = 0;
    
    if(@available(iOS 11.0, *)) {
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.submitButton = [UIButton new];
    self.submitButton.backgroundImage([UIImage imageWithColor:cHEXCOLOR(#004FA1)], UIControlStateNormal);
    self.submitButton.title(@"保存", UIControlStateNormal).titleFont(MFont(18)).titleColor(COLOR_WHITE, UIControlStateNormal);
    [self.submitButton setHidden:YES];

    [self addSubview:self.tableView];
    [self addSubview:self.submitButton];
}

- (void)layoutUI {
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset((self.viewModel.canNext || self.viewModel.canSave) ? 49.f : 0.01);
        make.bottom.offset(0);
    }];
       
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.submitButton.mas_top).offset((self.viewModel.canNext || self.viewModel.canSave) ? -10 : 0.01);
    }];
}
@end
 
