//
//  DCTBaseTableViewModel.m
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/10.
//

#import "DCTBaseTableViewModel.h"
#import "DCTConfigurationModel.h"

#import "DCTSectionHeaderViewModel.h"
#import "DCTTextFieldTableViewCellViewModel.h"
#import "DCTContentTableViewCellViewModel.h"
#import "DCTPickTypeTableViewCellViewModel.h"

@interface DCTBaseTableViewModel ()
@property (nonatomic, strong) DCTTableViewInfoModel *configurationModel;
@property (nonatomic, copy) id saveBlock;
@property (nonatomic, copy) id nextBlock;
@property (nonatomic, copy) UserInfoBlock userInfoBlock;
@property (nonatomic, copy) DataInfoBlock dataInfoBlock;
@property (nonatomic, copy) DataInfoBind dataInfoBind;
@property (nonatomic, copy) UserInfoBind userInfoBind;
@property (nonatomic, copy) SetDataInfoBlock setDataInfoBlock;
@property (nonatomic, strong) NSMutableArray<RACDisposable *> *bindDisposables;

@end

@implementation DCTBaseTableViewModel
- (instancetype)initWithConfigurationInfo:(NSDictionary *)configurationInfo
                                SaveBlock:(id)saveBlock
                                NextBlock:(id)nextBlock
                            DataInfoBlock:(DataInfoBlock)dataInfoBlock
                            UserInfoBlock:(UserInfoBlock)userInfoBlock
                             DataInfoBind:(DataInfoBind)dataInfoBind
                             UserInfoBind:(UserInfoBind)userInfoBind
                         SetDataInfoBlock:(SetDataInfoBlock)setDataInfoBlock {
    if (self = [super init]) {
        if ([configurationInfo isKindOfClass:[NSDictionary class]]) {
            self.configurationModel = [DCTTableViewInfoModel yy_modelWithJSON:configurationInfo];
        }
        self.bindDisposables = [NSMutableArray new];
        
        if (saveBlock) { self.saveBlock = saveBlock; }
        if (nextBlock) { self.nextBlock = nextBlock; }
        if (userInfoBlock) { self.userInfoBlock = userInfoBlock; }
        if (dataInfoBlock) { self.dataInfoBlock = dataInfoBlock; }
        if (userInfoBind) { self.userInfoBind = userInfoBind; }
        if (dataInfoBind) { self.dataInfoBind = dataInfoBind; }
        if (setDataInfoBlock) { self.setDataInfoBlock = setDataInfoBlock; }

        self.tableViewConfiguration = [self.configurationModel createTableViewCellListWithDataInfoBlock:dataInfoBlock UserInfoBlock:userInfoBlock];
        
        id canSaveResult = [DCTUtilsClass getResultWithFormulaString:self.configurationModel.saveShow.formulaString
                                                      RoundingType:[self.configurationModel.saveShow.roundingType integerValue]
                                                     DecimalNumber:[self.configurationModel.saveShow.decimalNumber integerValue]
                                                     UserInfoBlock:userInfoBlock
                                                     DataInfoBlock:dataInfoBlock];
       
        id canNextResult = [DCTUtilsClass getResultWithFormulaString:self.configurationModel.nextShow.formulaString
                                                      RoundingType:[self.configurationModel.nextShow.roundingType integerValue]
                                                     DecimalNumber:[self.configurationModel.nextShow.decimalNumber integerValue]
                                                     UserInfoBlock:userInfoBlock
                                                     DataInfoBlock:dataInfoBlock];
        

        if (([canSaveResult isKindOfClass:[NSString class]] || [canSaveResult isKindOfClass:[NSNumber class]])
            && [canSaveResult boolValue]) {
            self.canSave = YES;
        }
        
        if (([canNextResult isKindOfClass:[NSString class]] || [canSaveResult isKindOfClass:[NSNumber class]])
            && [canSaveResult boolValue]) {
            self.canNext = YES;
        }
        
        NSLog(@"%@",self.tableViewConfiguration);

    }
    return self;
}

- (NSDictionary *)sectionConfigurationWithSection:(NSInteger)section {
    
    NSInteger sectionTag = [self.tableViewConfiguration[section][@"sort"] integerValue];
    
    __block DCTSectionInfoModel *model;
    [self.configurationModel.sections enumerateObjectsUsingBlock:^(DCTSectionInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.sort integerValue] == sectionTag) {
            
            model = obj;
            *stop = YES;
        }
    }];
    
    return [model yy_modelToJSONObject];
}

- (NSDictionary *)cellConfigurationWithIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger sectionTag = [self.tableViewConfiguration[indexPath.section][@"sort"] integerValue];
    NSInteger rowTag = [self.tableViewConfiguration[indexPath.section][@"cells"][indexPath.row] integerValue];
        
    __block NSDictionary *cellConfiguration = @{};
    [self.configurationModel.sections enumerateObjectsUsingBlock:^(DCTSectionInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.sort integerValue] == sectionTag) {
            
            [obj.cells enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj[@"sort"] integerValue] == rowTag) {
                    
                    cellConfiguration = obj;
                    *stop = YES;
                }
            }];
            
            *stop = YES;
        }
    }];
    
    return cellConfiguration;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.tableViewConfiguration.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *cellsArray = self.tableViewConfiguration[section][@"cells"];
    return cellsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return [DCTSectionHeaderViewModel cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dict = [self sectionConfigurationWithSection:section];
    DCTSectionHeaderViewModel *header = [[DCTSectionHeaderViewModel alloc] init];
    return header.sectionHeaderBlock(section, dict);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellConfiguration = [self cellConfigurationWithIndexPath:indexPath];
    DCTBaseTableViewCellViewModel *viewModel;
    if ([cellConfiguration[@"cellType"] integerValue] == DCTConfigurationCellType_TextField) {
        if (indexPath.section == 0 && indexPath.row == 3) {
        }
        viewModel = [DCTTextFieldTableViewCellViewModel new];
    }
    
    if ([cellConfiguration[@"cellType"] integerValue] == DCTConfigurationCellType_Content) {
        viewModel = [[DCTContentTableViewCellViewModel alloc] init];
    }
    
    if ([cellConfiguration[@"cellType"] integerValue] == DCTConfigurationCellType_PickFromDictionary) {
        viewModel = [[DCTPickTypeTableViewCellViewModel alloc] init];
    }

    if (viewModel) {
        return viewModel.cellBlock(tableView, indexPath, cellConfiguration, self.dataInfoBlock, self.userInfoBind, self.setDataInfoBlock);
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self cellConfigurationWithIndexPath:indexPath];
    
    if ([dict[@"cellType"] integerValue] == DCTConfigurationCellType_PickFromDictionary
        || [dict[@"cellType"] integerValue] == DCTConfigurationCellType_PickFromServer
        || [dict[@"cellType"] integerValue] == DCTConfigurationCellType_PickFromConfig) {
        
        DCTPickTypeTableViewCellViewModel *viewModel = [[DCTPickTypeTableViewCellViewModel alloc] init];
        
        [viewModel pickTypeWithTableView:tableView IndexPath:indexPath CellConfig:dict DataInfoBlock:self.dataInfoBlock UserInfoBlock:self.userInfoBlock SetDataInfoBlock:self.setDataInfoBlock CompletedBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [tableView reloadData];
            }];
        }];
        
        
        
    }
    
}

#pragma mark - 数据绑定操作
- (void)setTableViewConfiguration:(NSArray<NSDictionary *> *)tableViewConfiguration {
    _tableViewConfiguration = tableViewConfiguration;
    [tableViewConfiguration enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull sectionInfo, NSUInteger sectionIndex, BOOL * _Nonnull stop) {
        
        [(NSArray<NSNumber *> *)sectionInfo[@"cells"] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull cellSort, NSUInteger rowIndex, BOOL * _Nonnull stop) {
        
            NSDictionary *cellConfiguration = [self cellConfigurationWithIndexPath:[NSIndexPath indexPathForRow:rowIndex
                                                                                                      inSection:sectionIndex]];
            DCTBaseCellInfoModel *cellModel = [DCTBaseCellInfoModel yy_modelWithJSON:cellConfiguration];
            
            [cellModel.bindData enumerateObjectsUsingBlock:^(DCTDataBindInfoModel * _Nonnull bindInfoModel, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [bindInfoModel.bindData enumerateObjectsUsingBlock:^(NSString * _Nonnull bindKeyPath, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    RACSignal *signal = [DCTUtilsClass setObserveWithKeyPath:bindKeyPath UserInfoBind:self.userInfoBind DataInfoBind:self.dataInfoBind];
                    RACSubject *subject = [RACSubject subject];
                    [signal subscribe:subject];
                    
                    RACDisposable *disposable = [subject subscribeNext:^(id  _Nullable x) {
                        [self respondBindDataWithbindInfoModel:bindInfoModel];
                    }];
                    [self.bindDisposables addObject:disposable];
                    
                }];
                
            }];
            
        }];
        
    }];
}

- (void)respondBindDataWithbindInfoModel:(DCTDataBindInfoModel *)bindInfoModel {
    id formulaResult = [DCTUtilsClass getResultWithFormulaString:bindInfoModel.formulaString
                                             RoundingType:[bindInfoModel.roundingType integerValue]
                                            DecimalNumber:[bindInfoModel.decimalNumber integerValue]
                                            UserInfoBlock:self.userInfoBlock
                                            DataInfoBlock:self.dataInfoBlock];
        
    if (![formulaResult isKindOfClass:[NSError class]]) {
        [bindInfoModel.responseData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.setDataInfoBlock) {
                id setDataInfoResult = [DCTUtilsClass setDataInfoWithKeyPath:obj DataInfo:formulaResult SetDataInfoBlock:self.setDataInfoBlock];
                NSLog(@"-----responseData setDataInfoBlockResult = %@, data = %@, keyPath = %@", setDataInfoResult, formulaResult, obj);
            }
        }];
    }
    
    [self.bindDisposables enumerateObjectsUsingBlock:^(RACDisposable * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dispose];
    }];
    [self.bindDisposables removeAllObjects];
    
    self.tableViewConfiguration = [self.configurationModel createTableViewCellListWithDataInfoBlock:self.dataInfoBlock UserInfoBlock:self.userInfoBlock];
}

@end
