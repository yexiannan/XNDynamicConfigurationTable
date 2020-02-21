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
        self.bindData       = @[];
        self.responseData   = @[];
        self.roundingType   = @(NSRoundDown);
        self.decimalNumber  = @(2);
        self.canReplace     = @(YES);
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

@implementation DCTFontInfoModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.fontSize   = @(14);
        self.fontWeight = @(DCTFontWeightType_Regular);
        self.color      = @"#333333FF";
    }
    return self;
}
@end

#pragma mark - 表格结构
@implementation DCTTableHandleModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"handleShow":[DCTDataBindInfoModel class],
             @"handleRequest":[DCTURLInfoModel class]};
}
@end

@implementation DCTSectionInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"show":[DCTDataBindInfoModel class],
             @"titleFont":[DCTFontInfoModel class]};
}

- (instancetype)init {
    if (self = [super init]) {
        self.cells      = @[];
        self.titleFont  = [[DCTFontInfoModel alloc] init];
    }
    return self;
}
@end

@implementation DCTTableViewInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tableHandle":[DCTTableHandleModel class],
             @"sections":[DCTSectionInfoModel class]};
}

- (instancetype)init {
    if (self = [super init]) {
        self.tableHandle    = @[];
        self.sections       = @[];
        self.integrityVerificationBeforeSave = @(NO);
    }
    return self;
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
             @"bindData":[DCTDataBindInfoModel class],
             @"titleFont":[DCTFontInfoModel class],
             @"contentFont":[DCTFontInfoModel class],
             @"placeholderFont":[DCTFontInfoModel class
                                 
                                 
                                 
                                 ]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bindData = @[];
    }
    return self;
}
@end

@implementation DCTContentCellInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"titleFont":[DCTFontInfoModel class],
             @"contentFont":[DCTFontInfoModel class],
             @"unitFont":[DCTFontInfoModel class]};
}

- (instancetype)init {
    if (self = [super init]) {
        self.content        = @[];
        self.titleFont      = [[DCTFontInfoModel alloc] init];
        self.contentFont    = [[DCTFontInfoModel alloc] init];
        self.unitFont       = [[DCTFontInfoModel alloc] init];
    }
    return self;
}
@end

@implementation DCTContentCellWithoutTitleInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"contentFont":[DCTFontInfoModel class]};
}

- (instancetype)init {
    if (self = [super init]) {
        self.content        = @[];
        self.contentFont    = [[DCTFontInfoModel alloc] init];
    }
    return self;
}
@end

@implementation DCTTextFieldCellInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"titleFont":[DCTFontInfoModel class],
             @"contentFont":[DCTFontInfoModel class],
             @"unitFont":[DCTFontInfoModel class],
             @"placeholderFont":[DCTFontInfoModel class],
             @"canEdit":[DCTDataBindInfoModel class],
             @"necessary":[DCTDataBindInfoModel class]};
}

- (instancetype)init {
    if (self = [super init]) {
        self.titleFont          = [[DCTFontInfoModel alloc] init];
        self.contentFont        = [[DCTFontInfoModel alloc] init];
        self.unitFont           = [[DCTFontInfoModel alloc] init];
        self.placeholderFont    = [[DCTFontInfoModel alloc] init];
        self.placeholderFont.color = @"#C7C7CDFF";
        self.contentType        = @(DCTContentType_Content);
        self.regularExpressions = @[];
    }
    return self;
}
@end

@implementation DCTTextViewCellInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"contentFont":[DCTFontInfoModel class],
             @"placeholderFont":[DCTFontInfoModel class],
             @"canEdit":[DCTDataBindInfoModel class],
             @"necessary":[DCTDataBindInfoModel class]};
}

- (instancetype)init {
    if (self = [super init]) {
        self.content            = @[];
        self.contentFont        = [[DCTFontInfoModel alloc] init];
        self.placeholderFont    = [[DCTFontInfoModel alloc] init];
        self.placeholderFont.color = @"#C7C7CDFF";
        self.minLength          = @(0);
        self.maxLength          = @(-1);
    }
    return self;
}
@end

@implementation DCTPickCellInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"titleFont":[DCTFontInfoModel class],
             @"contentFont":[DCTFontInfoModel class],
             @"placeholderFont":[DCTFontInfoModel class],
             @"canEdit":[DCTDataBindInfoModel class],
             @"necessary":[DCTDataBindInfoModel class],
             @"dictionaryKey":[DCTDataBindInfoModel class]};
}

- (instancetype)init {
    if (self = [super init]) {
        self.content = @[];
        self.titleFont          = [[DCTFontInfoModel alloc] init];
        self.contentFont        = [[DCTFontInfoModel alloc] init];
        self.placeholderFont    = [[DCTFontInfoModel alloc] init];
        self.placeholderFont.color = @"#C7C7CDFF";
    }
    return self;
}
@end

@implementation DCTPickFromServerCellInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"request":[DCTURLInfoModel class],
             @"titleFont":[DCTFontInfoModel class],
             @"contentFont":[DCTFontInfoModel class],
             @"placeholderFont":[DCTFontInfoModel class]};
}

 - (instancetype)init {
     if (self = [super init]) {
         self.content = @[];
         self.titleFont          = [[DCTFontInfoModel alloc] init];
         self.contentFont        = [[DCTFontInfoModel alloc] init];
         self.placeholderFont    = [[DCTFontInfoModel alloc] init];
         self.placeholderFont.color = @"#C7C7CDFF";
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

