//
//  DCTConfigurationModel.m
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/2.
//

#import "DCTConfigurationModel.h"

@implementation DCTDataBindInfoModel

@end

#pragma mark - 表格结构
@implementation DCTSectionInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"show":[DCTDataBindInfoModel class]};
}
@end

@implementation DCTTableViewInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"saveShow":[DCTDataBindInfoModel class],
             @"nextShow":[DCTDataBindInfoModel class]};
}
@end

@implementation DCTStagesInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tableInfo":[DCTTableViewInfoModel class]};
}
@end

@implementation DCTConfigurationModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tableInfo":[DCTTableViewInfoModel class]};
}
@end

#pragma mark - 单元格信息
@implementation DCTBaseCellInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"show":[DCTDataBindInfoModel class]};
}
@end

@implementation DCTContentCellInfoModel

@end

@implementation DCTContentCellWithoutTitleInfoModel

@end

@implementation DCTTextFieldCellInfoModel

@end

@implementation DCTTextViewCellInfoModel

@end

@implementation DCTPickCellInfoModel

@end


@implementation DCTPickFromServerCellInfoModel
 
@end

@implementation DCTPickFromConfigCellInfoModel
 
@end

@implementation DCTPickDateCellInfoModel
 
@end

@implementation DCTPickAddressCellInfoModel
 
@end

@implementation DCTPickAddressFromServerCellInfoModel
 
@end

@implementation DCTImagesInfoModel
 + (NSDictionary *)modelContainerPropertyGenericClass {
     return @{@"show":[DCTDataBindInfoModel class]};
 }
@end

@implementation DCTPickPhotoSingleKeyCellInfoModel
 
@end

@implementation DCTPickPhotoMutiKeyCellInfoModel
 
@end

@implementation DCTVINCodeRecognitionCellInfoModel
 
@end

@implementation DCTMultiColumnCellInfoModel
 
@end

@implementation DCTSubTableCellInfoModel
 + (NSDictionary *)modelContainerPropertyGenericClass {
     return @{@"tableInfo":[DCTTableViewInfoModel class]};
 }
@end

@implementation DCTSeparatorCellInfoModel
 
@end

