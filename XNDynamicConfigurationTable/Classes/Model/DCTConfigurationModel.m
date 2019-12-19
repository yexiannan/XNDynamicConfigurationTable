//
//  DCTConfigurationModel.m
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/2.
//

#import "DCTConfigurationModel.h"

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
- (NSArray<NSDictionary *> *)createTableViewCellListWithDataInfoBlock:(DataInfoBlock)dataInfoBlock UserInfoBlock:(UserInfoBlock)userInfoBlock {
    NSMutableArray *tableViewList = [NSMutableArray new];
    
    [self.sections enumerateObjectsUsingBlock:^(DCTSectionInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id sectionShow = [DCTUtilsClass getResultWithFormulaString:obj.show.formulaString
                                                      RoundingType:[obj.show.roundingType integerValue]
                                                     DecimalNumber:[obj.show.decimalNumber integerValue]
                                                     UserInfoBlock:userInfoBlock
                                                     DataInfoBlock:dataInfoBlock];
        
        if (![sectionShow isKindOfClass:[NSError class]]) {
            if ([sectionShow boolValue]) {
                NSMutableArray *cellList = [NSMutableArray new];
                [obj.cells enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull cellInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                    id cellShow = [DCTUtilsClass getResultWithFormulaString:cellInfo[@"show"][@"formulaString"]
                                                               RoundingType:[cellInfo[@"show"][@"roundingType"] integerValue]
                                                              DecimalNumber:[cellInfo[@"show"][@"decimalNumber"] integerValue]
                                                              UserInfoBlock:userInfoBlock
                                                              DataInfoBlock:dataInfoBlock];

                    if (![cellShow isKindOfClass:[NSError class]]) {
                        if ([sectionShow boolValue]) {
                            [cellList addObject:cellInfo[@"sort"]];
                        }
                    } else {
                        NSLog(@"addCellFailure CellSection:%@, CellSort:%@, reason:%@", obj.sort, cellInfo[@"sort"], cellShow);
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
             @"canEdit":[DCTDataBindInfoModel class],
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

