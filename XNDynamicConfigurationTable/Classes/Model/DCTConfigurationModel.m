//
//  DCTConfigurationModel.m
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/2.
//

#import "DCTConfigurationModel.h"
#import "DCTFormulaCalculation.h"

typedef NS_ENUM(NSInteger, CellType) {
    CellType_Content = 101,
    CellType_ContentWithoutTitle = 102,
    CellType_TextField = 201,
    CellType_TextView = 301,
    CellType_PickFromDictionary = 401,
    CellType_PickFromServer = 402,
    CellType_PickFromConfig = 403,
    CellType_PickDate = 501,
    CellType_PickDateZone = 502,
    CellType_PickAddress = 601,
    CellType_PickAddressFromServer = 602,
    CellType_PickPhotoSingleKey = 701,
    CellType_PickPhotoMutiKey = 702,
    CellType_PickPhotoFromServer = 703,
    CellType_VINCodeRecognition = 801,
    CellType_MultiColumn = 901,
    CellType_SubTable = 1001,
    CellType_SeparatorCell = 1101,
};

@implementation DCTDataBindInfoModel
- (instancetype)init {
    if (self = [super init]) {
        self.bindData = @[];
        self.responseData = @[];
        self.roundingType = @(DCTRoundingType_Down);
        self.decimalNumber = @(2);
    }
    return self;
}
@end

@implementation DCTURLInfoModel
- (instancetype)init {
    if (self = [super init]) {
        self.params = @{};
    }
    return self;
}

@end

#pragma mark - 表格结构
@implementation DCTSectionInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"show":[DCTDataBindInfoModel class]};
}

- (instancetype)init {
    if (self = [super init]) {
        self.cells = @[];
    }
    return self;
}

- (void)setCells:(NSArray<id> *)cells {
    NSMutableArray *cellsModel = [[NSMutableArray alloc] initWithCapacity:cells.count];
    [(NSArray <NSDictionary *>*)cells enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch ([obj[@"cellType"] integerValue]) {
            case CellType_Content: [cellsModel addObject:[DCTContentCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_ContentWithoutTitle: [cellsModel addObject:[DCTContentCellWithoutTitleInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_TextField: [cellsModel addObject:[DCTTextFieldCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_TextView: [cellsModel addObject:[DCTTextViewCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_PickFromDictionary: [cellsModel addObject:[DCTPickCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_PickFromServer: [cellsModel addObject:[DCTPickFromServerCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_PickFromConfig: [cellsModel addObject:[DCTPickFromConfigCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_PickDate: [cellsModel addObject:[DCTPickDateCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_PickDateZone: [cellsModel addObject:[DCTPickDateZoneCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_PickAddress: [cellsModel addObject:[DCTPickAddressCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_PickAddressFromServer: [cellsModel addObject:[DCTPickAddressFromServerCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_PickPhotoSingleKey: [cellsModel addObject:[DCTPickPhotoSingleKeyCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_PickPhotoMutiKey: [cellsModel addObject:[DCTPickPhotoMutiKeyCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_PickPhotoFromServer: [cellsModel addObject:[DCTPickPhotoFromServerCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_VINCodeRecognition: [cellsModel addObject:[DCTVINCodeRecognitionCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_MultiColumn: [cellsModel addObject:[DCTMultiColumnCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_SubTable: [cellsModel addObject:[DCTSubTableCellInfoModel yy_modelWithJSON:obj]]; break;
            case CellType_SeparatorCell: [cellsModel addObject:[DCTSeparatorCellInfoModel yy_modelWithJSON:obj]]; break;

            default:
                break;
        }
    }];
    _cells = cellsModel;
}
@end

@implementation DCTTableViewInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"saveShow":[DCTDataBindInfoModel class],
             @"nextShow":[DCTDataBindInfoModel class],
             @"sections":[DCTSectionInfoModel class]};
}

- (instancetype)init {
    if (self = [super init]) {
        self.sections = @[];
    }
    return self;
}

//根据配置表创建表格结构
- (NSArray<NSDictionary *> *)createTableViewCellListWithData:(NSDictionary *)data {

    NSMutableArray *tableViewList = [NSMutableArray new];
    
    [self.sections enumerateObjectsUsingBlock:^(DCTSectionInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id sectionShow = [DCTFormulaCalculation getResultWithFormulaString:obj.show.formulaString
                                                            DataDictionary:data
                                                              RoundingType:[obj.show.roundingType integerValue]
                                                             DecimalNumber:[obj.show.decimalNumber integerValue]];
        
        if (![sectionShow isKindOfClass:[NSError class]]) {
            if ([sectionShow boolValue]) {
                NSMutableArray *cellList = [NSMutableArray new];
                [obj.cells enumerateObjectsUsingBlock:^(DCTBaseCellInfoModel * cellInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                    id cellShow = [DCTFormulaCalculation getResultWithFormulaString:cellInfo.show.formulaString
                                                                     DataDictionary:data
                                                                       RoundingType:[cellInfo.show.roundingType integerValue]
                                                                      DecimalNumber:[cellInfo.show.decimalNumber integerValue]];
                    if (![cellShow isKindOfClass:[NSError class]]) {
                        if ([sectionShow boolValue]) {
                            [cellList addObject:cellInfo.sort];
                        }
                    } else {
                        NSLog(@"addCellFailure CellSection:%@, CellSort:%@, reason:%@", obj.sort, cellInfo.sort, cellShow);
                    }
                }];
                            
                [cellList sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"" ascending:YES]]];
                [tableViewList addObject:@{@"sort":obj.sort, @"cells":cellList}];
            }
        } else {
            NSLog(@"addSectionFailure sort:%@, reason:%@", obj.sort, sectionShow);
        }
        
    }];
    [tableViewList sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES]]];
    
    return tableViewList;
}
@end

@implementation DCTStagesInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tableInfo":[DCTTableViewInfoModel class]};
}

- (instancetype)init {
    if (self = [super init]) {
        self.showStatus = @[];
    }
    return self;
}
@end

@implementation DCTConfigurationModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tableInfo":[DCTTableViewInfoModel class],
             @"stagesArray":[DCTStagesInfoModel class]};
}
- (instancetype)init {
    if (self = [super init]) {
        self.stagesArray = @[];
    }
    return self;
}
@end

#pragma mark - 单元格信息
@implementation DCTBaseCellInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"show":[DCTDataBindInfoModel class],
             @"bindData":[DCTDataBindInfoModel class]};
}
@end

@implementation DCTContentCellInfoModel
- (instancetype)init {
    if (self = [super init]) {
        self.content = @[];
    }
    return self;
}
@end

@implementation DCTContentCellWithoutTitleInfoModel
- (instancetype)init {
    if (self = [super init]) {
        self.content = @[];
    }
    return self;
}
@end

@implementation DCTTextFieldCellInfoModel
- (instancetype)init {
    if (self = [super init]) {
        self.regularExpressions = @[];
        self.contentType = @(1);
    }
    return self;
}
@end

@implementation DCTTextViewCellInfoModel
- (instancetype)init {
    if (self = [super init]) {
        self.content = @[];
        self.minLength = @(0);
        self.maxLength = @(-1);
    }
    return self;
}
@end

@implementation DCTPickCellInfoModel
- (instancetype)init {
    if (self = [super init]) {
        self.content = @[];
    }
    return self;
}
@end

@implementation DCTPickFromServerCellInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"request":[DCTURLInfoModel class]};
}

 - (instancetype)init {
     if (self = [super init]) {
         self.content = @[];
     }
     return self;
 }
@end

@implementation DCTPickFromConfigCellInfoModel
 - (instancetype)init {
     if (self = [super init]) {
         self.content = @[];
         self.configList = @[];
     }
     return self;
 }
@end

@implementation DCTPickDateCellInfoModel
 - (instancetype)init {
     if (self = [super init]) {
         self.content = @[];
     }
     return self;
 }
@end

@implementation DCTPickDateZoneCellInfoModel
 - (instancetype)init {
     if (self = [super init]) {
         self.content = @[];
     }
     return self;
 }
@end

@implementation DCTPickAddressCellInfoModel
 - (instancetype)init {
     if (self = [super init]) {
         self.content = @[];
     }
     return self;
 }
@end

@implementation DCTPickAddressFromServerCellInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"request":[DCTURLInfoModel class]};
}
 - (instancetype)init {
     if (self = [super init]) {
         self.content = @[];
     }
     return self;
 }
@end

@implementation DCTImagesInfoModel
 + (NSDictionary *)modelContainerPropertyGenericClass {
     return @{@"show":[DCTDataBindInfoModel class]};
 }
@end

@implementation DCTPickPhotoSingleKeyCellInfoModel
 
@end

@implementation DCTPickPhotoMutiKeyCellInfoModel
- (instancetype)init {
    if (self = [super init]) {
        self.imagesInfo = @[];
    }
    return self;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"imagesInfo":[DCTImagesInfoModel class]};
}
@end

@implementation DCTPickPhotoFromServerCellInfoModel
 + (NSDictionary *)modelContainerPropertyGenericClass {
     return @{@"request":[DCTURLInfoModel class]};
 }
@end

@implementation DCTVINCodeRecognitionCellInfoModel
 + (NSDictionary *)modelContainerPropertyGenericClass {
     return @{@"request":[DCTURLInfoModel class]};
 }
- (instancetype)init {
    if (self = [super init]) {
        self.carInfo = @[];
    }
    return self;
}
@end

@implementation DCTMultiColumnCellInfoModel
 - (instancetype)init {
     if (self = [super init]) {
         self.title = @[];
         self.content = @[];
     }
     return self;
 }
@end

@implementation DCTSubTableCellInfoModel
 + (NSDictionary *)modelContainerPropertyGenericClass {
     return @{@"tableInfo":[DCTTableViewInfoModel class]};
 }
@end

@implementation DCTSeparatorCellInfoModel
 
@end

