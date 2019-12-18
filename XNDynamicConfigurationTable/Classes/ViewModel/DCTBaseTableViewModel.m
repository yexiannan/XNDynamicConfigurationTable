//
//  DCTBaseTableViewModel.m
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/10.
//

#import "DCTBaseTableViewModel.h"
#import "DCTConfigurationModel.h"
#import "DCTFormulaCalculation.h"

#import "DCTSectionHeaderViewModel.h"
#import "DCTTextFieldTableViewCellViewModel.h"
#import "DCTContentTableViewCellViewModel.h"
#import "DCTPickTypeTableViewCellViewModel.h"

@interface DCTBaseTableViewModel ()
@property (nonatomic, strong) DCTTableViewInfoModel *configurationModel;
@property (nonatomic, strong) NSMutableDictionary *dataInfo;
@property (nonatomic, strong) NSMutableDictionary *dataInfoCopy;
@property (nonatomic, copy) id saveBlock;
@property (nonatomic, copy) id nextBlock;
@property (nonatomic, copy) id userInfoBlock;
@end

@implementation DCTBaseTableViewModel
- (instancetype)initWithConfigurationInfo:(NSDictionary *)configurationInfo DataInfo:(nonnull NSMutableDictionary *)dataInfo SaveBlock:(nullable id)saveBlock NextBlock:(nullable id)nextBlock UserInfoBlock:(nullable id)userInfoBlock {
    if (self = [super init]) {
        if ([configurationInfo isKindOfClass:[NSDictionary class]]) {
            self.configurationModel = [DCTTableViewInfoModel yy_modelWithJSON:configurationInfo];
        }
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            self.dataInfo = dataInfo;
            self.dataInfoCopy = [dataInfo mutableCopy];
        }   
        if (saveBlock) { self.saveBlock = saveBlock; }
        if (nextBlock) { self.nextBlock = nextBlock; }
        if (userInfoBlock) { self.userInfoBlock = userInfoBlock; }

        self.tableViewConfiguration = [self.configurationModel createTableViewCellListWithData:self.dataInfoCopy];
        
        id canSaveResult = [DCTFormulaCalculation getResultWithFormulaString:self.configurationModel.saveShow.formulaString
                                                              DataDictionary:self.dataInfoCopy
                                                                RoundingType:[self.configurationModel.saveShow.roundingType integerValue]
                                                               DecimalNumber:[self.configurationModel.saveShow.decimalNumber integerValue]];
        id canNextResult = [DCTFormulaCalculation getResultWithFormulaString:self.configurationModel.nextShow.formulaString
                                                              DataDictionary:self.dataInfoCopy
                                                                RoundingType:[self.configurationModel.nextShow.roundingType integerValue]
                                                               DecimalNumber:[self.configurationModel.nextShow.decimalNumber integerValue]];
        if ([canSaveResult isKindOfClass:[NSString class]] && [canSaveResult boolValue]) {
            self.canSave = YES;
        }
        
        if ([canNextResult isKindOfClass:[NSString class]] && [canNextResult boolValue]) {
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
    NSDictionary *dict = [self cellConfigurationWithIndexPath:indexPath];
    if ([dict[@"cellType"] integerValue] == DCTConfigurationCellType_TextField) {
        DCTTextFieldTableViewCellViewModel *viewModel = [[DCTTextFieldTableViewCellViewModel alloc] init];
        viewModel.block = ^(NSString * _Nonnull text) {
            
        };
        return viewModel.cellBlock(tableView, indexPath, dict, self.dataInfoCopy, self.userInfoBlock);
    }
    
    if ([dict[@"cellType"] integerValue] == DCTConfigurationCellType_Content) {
        DCTContentTableViewCellViewModel *viewModel = [[DCTContentTableViewCellViewModel alloc] init];
        return viewModel.cellBlock(tableView, indexPath, dict, self.dataInfoCopy, self.userInfoBlock);
    }
    
    if ([dict[@"cellType"] integerValue] == DCTConfigurationCellType_PickFromDictionary) {
        DCTPickTypeTableViewCellViewModel *viewModel = [[DCTPickTypeTableViewCellViewModel alloc] init];
        return viewModel.cellBlock(tableView, indexPath, dict, self.dataInfoCopy, self.userInfoBlock);
    }

    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self cellConfigurationWithIndexPath:indexPath];
    
    if ([dict[@"cellType"] integerValue] == DCTConfigurationCellType_PickFromDictionary
        || [dict[@"cellType"] integerValue] == DCTConfigurationCellType_PickFromServer
        || [dict[@"cellType"] integerValue] == DCTConfigurationCellType_PickFromConfig) {
        
        DCTPickTypeTableViewCellViewModel *viewModel = [[DCTPickTypeTableViewCellViewModel alloc] init];
        [viewModel pickTypeWithTableView:tableView IndexPath:indexPath CellConfig:dict DataInfo:self.dataInfoCopy CompletedBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [tableView reloadData];
            }];
        }];
        
    }
}

@end
