//
//  DCTBaseTableViewModel.m
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/10.
//

#import "DCTBaseTableViewModel.h"
#import "DCTConfigurationModel.h"
#import "DCTFormulaCalculation.h"

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
            self.dataInfoCopy = [dataInfo copy];
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


@end
