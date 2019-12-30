//
//  DCTConfigurationModel.h
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/2.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DCTConfigurationCellType) {
    DCTConfigurationCellType_Content = 101,
    DCTConfigurationCellType_ContentWithoutTitle = 102,
    DCTConfigurationCellType_TextField = 201,
    DCTConfigurationCellType_TextView = 301,
    DCTConfigurationCellType_PickFromDictionary = 401,
    DCTConfigurationCellType_PickFromServer = 402,
    DCTConfigurationCellType_PickFromConfig = 403,
    DCTConfigurationCellType_PickDate = 501,
    DCTConfigurationCellType_PickDateZone = 502,
    DCTConfigurationCellType_PickAddress = 601,
    DCTConfigurationCellType_PickAddressFromServer = 602,
    DCTConfigurationCellType_PickPhotoSingleKey = 701,
    DCTConfigurationCellType_PickPhotoMutiKey = 702,
    DCTConfigurationCellType_PickPhotoFromServer = 703,
    DCTConfigurationCellType_VINCodeRecognition = 801,
    DCTConfigurationCellType_MultiColumn = 901,
    DCTConfigurationCellType_SubTable = 1001,
    DCTConfigurationCellType_SeparatorCell = 1101,
};

NS_ASSUME_NONNULL_BEGIN
@interface DCTDataBindInfoModel : NSObject
@property (nonatomic, copy) NSArray<NSString *> *bindData;
@property (nonatomic, copy) NSArray<NSString *> *responseData;
@property (nonatomic, copy) NSNumber *roundingType;
@property (nonatomic, copy) NSNumber *decimalNumber;
@property (nonatomic, copy) NSString *formulaString;
@end

@interface DCTURLInfoModel : NSObject
@property (nonatomic, copy) NSNumber *host;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSDictionary *params;
@end

#pragma mark - 表格结构
@interface DCTSectionInfoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSNumber *sort;
@property (nonatomic, strong) DCTDataBindInfoModel *show;
@property (nonatomic, copy) NSArray<NSDictionary *> *cells;
@end

@interface DCTTableViewInfoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) DCTDataBindInfoModel *saveShow;
@property (nonatomic, strong) DCTDataBindInfoModel *nextShow;
@property (nonatomic, copy) NSNumber *integrityVerificationBeforeSave;
@property (nonatomic, copy) NSArray<DCTSectionInfoModel *> *sections;
@end

@interface DCTStagesInfoModel : NSObject
@property (nonatomic, copy) NSString *stageName;
@property (nonatomic, copy) NSArray<NSNumber *> *showStatus;
@property (nonatomic, strong) DCTTableViewInfoModel *tableInfo;
@end

@interface DCTConfigurationModel : NSObject
@property (nonatomic, copy) NSString *configVersion;
@property (nonatomic, copy) NSArray<DCTStagesInfoModel *> *stagesArray;
@property (nonatomic, strong) DCTTableViewInfoModel *tableInfo;
@end

#pragma mark - 单元格信息
@interface DCTBaseCellInfoModel : NSObject
@property (nonatomic, copy) NSNumber *cellType;
@property (nonatomic, copy) NSNumber *sort;
@property (nonatomic, strong) DCTDataBindInfoModel *show;
@property (nonatomic, strong) DCTDataBindInfoModel *canEdit;
@property (nonatomic, copy) NSNumber *necessary;
@property (nonatomic, copy) NSArray<DCTDataBindInfoModel *> *bindData;
@end

//101.文本单元格
@interface DCTContentCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, copy) NSString *separator;
@property (nonatomic, copy) NSString *unit;
@end

//102.文本无标题
@interface DCTContentCellWithoutTitleInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, copy) NSString *separator;
@end

//201.输入框
@interface DCTTextFieldCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSArray<NSString *> *regularExpressions;
@property (nonatomic, copy) NSNumber *contentType;
@end

//301.输入文本框
@interface DCTTextViewCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSNumber *minLength;
@property (nonatomic, copy) NSNumber *maxLength;
@end

//401.选择类型单元格-从字典表获取
@interface DCTPickCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSDictionary *dictionaryKey;
@end

//402.选择类型单元格-向服务器获取configList
@interface DCTPickFromServerCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) DCTURLInfoModel *request;
@end

//403.选择类型单元格-配置表带configList
@interface DCTPickFromConfigCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSArray<NSDictionary *> *configList;
@end

//501.选择单个时间单元格
@interface DCTPickDateCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSNumber *datePickType;
@property (nonatomic, copy) NSDictionary *minPickDate;
@property (nonatomic, copy) NSDictionary *maxPickDate;
@end

//502.选择时间区间单元格
@interface DCTPickDateZoneCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSNumber *datePickType;
@property (nonatomic, copy) NSDictionary *startMinPickDate;
@property (nonatomic, copy) NSDictionary *startMaxPickDate;
@property (nonatomic, copy) NSDictionary *endMinPickDate;
@property (nonatomic, copy) NSDictionary *endMaxPickDate;
@end

//601.选择地址单元格-本地数据
@interface DCTPickAddressCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *separator;
@property (nonatomic, copy) NSNumber *pickRange;
@end

//602.选择地址单元格-服务端数据
@interface DCTPickAddressFromServerCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *separator;
@property (nonatomic, copy) NSNumber *pickRange;
@property (nonatomic, strong) DCTURLInfoModel *request;
@end

@interface DCTImagesInfoModel : NSObject
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) DCTDataBindInfoModel *show;
@property (nonatomic, copy) NSNumber *necessary;
@property (nonatomic, copy) NSNumber *minNumber;
@property (nonatomic, copy) NSNumber *maxNumber;
@property (nonatomic, copy) NSNumber *sort;
@end

//701.选择图片-单key
@interface DCTPickPhotoSingleKeyCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, copy) NSNumber *minNumber;
@property (nonatomic, copy) NSNumber *maxNumber;
@end

//702.选择图片-多key
@interface DCTPickPhotoMutiKeyCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSArray<DCTImagesInfoModel *> *imagesInfo;
@end

//703.选择图片-从服务器获取
@interface DCTPickPhotoFromServerCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, strong) DCTURLInfoModel *request;
@end

//801.VIN码识别
@interface DCTVINCodeRecognitionCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) DCTURLInfoModel *request;
@property (nonatomic, copy) NSArray<NSString *> *carInfo;
@end

//901.多列显示
@interface DCTMultiColumnCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSArray<NSString *> *title;
@property (nonatomic, copy) NSArray<NSString *> *content;
@end

//1001.子表格
@interface DCTSubTableCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSNumber *integrityVerification;
@property (nonatomic, strong) DCTTableViewInfoModel *tableInfo;
@end

//1101.分隔单元格
@interface DCTSeparatorCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *separator;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSNumber *rowHeight;
@end

NS_ASSUME_NONNULL_END
