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

        self.tableviewStructure = [self createTableViewStrctureWithConfigurationModel:self.configurationModel DataInfoBlock:self.dataInfoBlock UserInfoBlock:self.userInfoBlock];
        
        NSLog(@"%@",[self.tableviewStructure yy_modelToJSONObject]);

    }
    return self;
}

- (NSDictionary *)sectionConfigurationWithSection:(NSInteger)section {
    
    NSInteger sectionTag = [self.tableviewStructure.sections[section].sort integerValue];
    
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
    
    NSInteger sectionTag = [self.tableviewStructure.sections[indexPath.section].sort integerValue];
    NSInteger rowTag = [self.tableviewStructure.sections[indexPath.section].cells[indexPath.row].sort integerValue];
        
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
    
    return self.tableviewStructure.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableviewStructure.sections[section].cells.count;
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
    DCTSectionStructureModel *sectionStructure = self.tableviewStructure.sections[indexPath.section];
    DCTCellStructureModel *cellStructure;
    if (indexPath.row < sectionStructure.cells.count) {
        cellStructure = sectionStructure.cells[indexPath.row];
    }
    
    if (cellStructure.cellViewModel.cellBlock) {
        return cellStructure.cellViewModel.cellBlock(tableView, indexPath, cellConfiguration, self.dataInfoBlock, self.userInfoBind, self.setDataInfoBlock);
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self cellConfigurationWithIndexPath:indexPath];
    
    if ([dict[@"cellType"] integerValue] == DCTConfigurationCellType_PickFromDictionary
        || [dict[@"cellType"] integerValue] == DCTConfigurationCellType_PickFromServer) {
        
        DCTPickTypeTableViewCellViewModel *viewModel = [[DCTPickTypeTableViewCellViewModel alloc] init];
        
        [viewModel pickTypeWithTableView:tableView IndexPath:indexPath CellConfig:dict DataInfoBlock:self.dataInfoBlock UserInfoBlock:self.userInfoBlock SetDataInfoBlock:self.setDataInfoBlock CompletedBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [tableView reloadData];
            }];
        }];
                
    }
    
}
 
#pragma mark - 数据绑定操作
- (void)setTableviewStructure:(DCTTableViewStructureModel *)tableviewStructure {
    _tableviewStructure = tableviewStructure;
 
    //判断是否显示保存/下一步按钮
    id canSaveResult = [DCTUtilsClass getResultWithFormulaString:self.configurationModel.saveShow.formulaString
                                                     RoundingType:[self.configurationModel.saveShow.roundingType integerValue]
                                                    DecimalNumber:[self.configurationModel.saveShow.decimalNumber integerValue]
                                                    UserInfoBlock:self.userInfoBlock
                                                    DataInfoBlock:self.dataInfoBlock];
    
     id canNextResult = [DCTUtilsClass getResultWithFormulaString:self.configurationModel.nextShow.formulaString
                                                     RoundingType:[self.configurationModel.nextShow.roundingType integerValue]
                                                    DecimalNumber:[self.configurationModel.nextShow.decimalNumber integerValue]
                                                    UserInfoBlock:self.userInfoBlock
                                                    DataInfoBlock:self.dataInfoBlock];
     

     if (([canSaveResult isKindOfClass:[NSString class]] || [canSaveResult isKindOfClass:[NSNumber class]])
         && [canSaveResult boolValue]) {
         self.canSave = YES;
     }
     
     if (([canNextResult isKindOfClass:[NSString class]] || [canSaveResult isKindOfClass:[NSNumber class]])
         && [canSaveResult boolValue]) {
         self.canNext = YES;
     }
    
    [tableviewStructure.sections enumerateObjectsUsingBlock:^(DCTSectionStructureModel * _Nonnull sectionInfo, NSUInteger sectionIndex, BOOL * _Nonnull stop) {
        
        [sectionInfo.cells enumerateObjectsUsingBlock:^(DCTCellStructureModel * _Nonnull obj, NSUInteger rowIndex, BOOL * _Nonnull stop) {
            
            NSDictionary *cellConfiguration = [self cellConfigurationWithIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
            DCTBaseCellInfoModel *cellModel = [DCTBaseCellInfoModel yy_modelWithJSON:cellConfiguration];

            //根据配置表监听数据
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

//响应监听
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
    
    //清除之前的订阅
    [self.bindDisposables enumerateObjectsUsingBlock:^(RACDisposable * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dispose];
    }];
    [self.bindDisposables removeAllObjects];
    
    self.tableviewStructure = [self createTableViewStrctureWithConfigurationModel:self.configurationModel DataInfoBlock:self.dataInfoBlock UserInfoBlock:self.userInfoBlock];
}


//根据配置表创建表格结构
- (DCTTableViewStructureModel *)createTableViewStrctureWithConfigurationModel:(DCTTableViewInfoModel *)model DataInfoBlock:(DataInfoBlock)dataInfoBlock UserInfoBlock:(UserInfoBlock)userInfoBlock {
    DCTTableViewStructureModel *strctureModel = [[DCTTableViewStructureModel alloc] init];
    
    [model.sections enumerateObjectsUsingBlock:^(DCTSectionInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id sectionShow = [DCTUtilsClass getResultWithFormulaString:obj.show.formulaString
                                                      RoundingType:[obj.show.roundingType integerValue]
                                                     DecimalNumber:[obj.show.decimalNumber integerValue]
                                                     UserInfoBlock:userInfoBlock
                                                     DataInfoBlock:dataInfoBlock];
        
        if (![sectionShow isKindOfClass:[NSError class]]) {
            if ([sectionShow boolValue]) {
                DCTSectionStructureModel *sectionStructure = [[DCTSectionStructureModel alloc] init];
                [obj.cells enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull cellInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                    id cellShow = [DCTUtilsClass getResultWithFormulaString:cellInfo[@"show"][@"formulaString"]
                                                               RoundingType:[cellInfo[@"show"][@"roundingType"] integerValue]
                                                              DecimalNumber:[cellInfo[@"show"][@"decimalNumber"] integerValue]
                                                              UserInfoBlock:userInfoBlock
                                                              DataInfoBlock:dataInfoBlock];

                    if (![cellShow isKindOfClass:[NSError class]]) {
                        if ([sectionShow boolValue]) {
                            DCTCellStructureModel *cellStructure = [[DCTCellStructureModel alloc] init];
                            cellStructure.sort = [NSNumber numberWithInteger:[cellInfo[@"sort"] integerValue]];
                            cellStructure.cellViewModel = [self createCellViewModelWithCellType:[cellInfo[@"cellType"] integerValue]];
                            [sectionStructure.cells addObject:cellStructure];
                        }
                    } else {
                        NSLog(@"addCellFailure CellSection:%@, CellSort:%@, reason:%@", obj.sort, cellInfo[@"sort"], cellShow);
                    }
                }];
                            
                [sectionStructure.cells sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES]]];
                sectionStructure.sort = obj.sort;
                [strctureModel.sections addObject:sectionStructure];
            }
        } else {
            NSLog(@"addSectionFailure sort:%@, reason:%@", obj.sort, sectionShow);
        }
        
    }];
    [strctureModel.sections sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES]]];
    
    return strctureModel;
}

//根据单元格类型创建对应的viewModel
- (DCTBaseTableViewCellViewModel *)createCellViewModelWithCellType:(NSInteger)cellType {
    switch (cellType) {
        case DCTConfigurationCellType_Content: return [[DCTContentTableViewCellViewModel alloc] init]; break;
        case DCTConfigurationCellType_TextField: return [[DCTTextFieldTableViewCellViewModel alloc] init]; break;
        case DCTConfigurationCellType_PickFromDictionary: return [[DCTPickTypeTableViewCellViewModel alloc] init]; break;

        default:
            return [[DCTBaseTableViewCellViewModel alloc] init];
            break;
    }
}

@end
