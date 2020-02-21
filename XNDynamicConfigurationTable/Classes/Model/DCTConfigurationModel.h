//
//  DCTConfigurationModel.h
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 通用Model

//数据绑定model 用于算式计算与设置数据绑定关系
@interface DCTDataBindInfoModel : NSObject
/**绑定字段数组*/
@property (nonatomic, copy) NSArray<NSString *> *bindData;
/**响应字段数组*/
@property (nonatomic, copy) NSArray<NSString *> *responseData;
/**舍入方式 default NSRoundDown*/
@property (nonatomic, copy) NSNumber *roundingType;
/**小数位数 default 2*/
@property (nonatomic, copy) NSNumber *decimalNumber;
/**算式字符串*/
@property (nonatomic, copy) NSString *formulaString;
/**针对算式字符串得出的结果进行验证的算式字符串*/
@property (nonatomic, copy) NSString *resultJudge;
/**提示文字*/
@property (nonatomic, copy) NSString *resultTip;
/**结果不符合预期是否依然更新值 default YES*/
@property (nonatomic, copy) NSNumber *canReplace;
@end

//请求数据model 用于向服务器请求数据
@interface DCTURLInfoModel : NSObject
/**配置的url域名类型*/
@property (nonatomic, copy) NSNumber *host;
/**url域名后的路径*/
@property (nonatomic, copy) NSString *path;
/**请求参数*/
@property (nonatomic, copy) NSDictionary *params;
@end



typedef NS_ENUM(NSInteger, DCTFontWeightType) {
    DCTFontWeightType_Light     = 0,
    DCTFontWeightType_Regular   = 1,
    DCTFontWeightType_Medium    = 2,
    DCTFontWeightType_Bold      = 3,
};
//文字样式model
@interface DCTFontInfoModel : NSObject
/**字体大小 default 14*/
@property (nonatomic, copy) NSNumber *fontSize;
/**字重 default DCTFontWeightType_Regular*/
@property (nonatomic, copy) NSNumber *fontWeight;
/**颜色RRGGBBAA default #333333FF*/
@property (nonatomic, copy) NSString *color;
@end

#pragma mark - 表格结构
@interface DCTTableHandleModel : NSObject
/**操作名称 用于在按钮上显示*/
@property (nonatomic, copy) NSString *handleName;
/**操作类型 不同的操作类型执行不同的处理*/
@property (nonatomic, copy) NSNumber *handleType;
/**判断是否显示此操作*/
@property (nonatomic, strong) DCTDataBindInfoModel *handleShow;
/**执行操作前是否需要判断表格是否填写完成*/
@property (nonatomic, copy) NSNumber *integrityVerificationBeforeHandle;
/**表格操作请求*/
@property (nonatomic, strong) DCTURLInfoModel *handleRequest;
@end

@interface DCTSectionInfoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, strong) DCTFontInfoModel *titleFont;
@property (nonatomic, copy) NSNumber *sort;
@property (nonatomic, strong) DCTDataBindInfoModel *show;
@property (nonatomic, copy) NSArray<NSDictionary *> *cells;
@end

@interface DCTTableViewInfoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<DCTTableHandleModel *> *tableHandle;
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
typedef NS_ENUM(NSInteger, DCTConfigurationCellType) {
    /**文本带标题*/
    DCTConfigurationCellType_Content                = 101,
    /**文本无标题*/
    DCTConfigurationCellType_ContentWithoutTitle    = 102,
    /**输入框*/
    DCTConfigurationCellType_TextField              = 201,
    /**输入文本框*/
    DCTConfigurationCellType_TextView               = 301,
    /**选择类型-字典表获取*/
    DCTConfigurationCellType_PickFromDictionary     = 401,
    /**选择类型-服务器获取*/
    DCTConfigurationCellType_PickFromServer         = 402,
    /**选择单个时间*/
    DCTConfigurationCellType_PickDate               = 501,
    /**选择时间区间*/
    DCTConfigurationCellType_PickDateZone           = 502,
    /**选择地址*/
    DCTConfigurationCellType_PickAddress            = 601,
    /**单个key图片*/
    DCTConfigurationCellType_PickPhotoSingleKey     = 701,
    /**选择多个key图片*/
    DCTConfigurationCellType_PickPhotoMutiKey       = 702,
    /**从服务器获取需要上传的图片*/
    DCTConfigurationCellType_PickPhotoFromServer    = 703,
    /**VIN码输入识别*/
    DCTConfigurationCellType_VINCodeRecognition     = 801,
    /**子表格*/
    DCTConfigurationCellType_SubTable               = 1001,
    /**分割单元格*/
    DCTConfigurationCellType_SeparatorCell          = 1101,
};
@interface DCTBaseCellInfoModel : NSObject
/**单元格类型*/
@property (nonatomic, copy) NSNumber *cellType;
/**排序 与indexPath.row不一致*/
@property (nonatomic, copy) NSNumber *sort;
/**是否显示*/
@property (nonatomic, strong) DCTDataBindInfoModel *show;
/**绑定数据*/
@property (nonatomic, copy) NSArray<DCTDataBindInfoModel *> *bindData;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) DCTFontInfoModel *titleFont;
@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, strong) DCTFontInfoModel *contentFont;
/**content拼接时的分割字符*/
@property (nonatomic, copy) NSString *separator;
@property (nonatomic, copy) NSArray<NSString *> *placeholder;
@property (nonatomic, strong) DCTFontInfoModel *placeholderFont;
@end

//101.文本单元格
@interface DCTContentCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, strong) DCTFontInfoModel *unitFont;
@end

//102.文本无标题
@interface DCTContentCellWithoutTitleInfoModel : DCTBaseCellInfoModel

@end


typedef NS_ENUM(NSInteger, DCTContentType) {
    DCTContentType_Content          = 1,
    DCTContentType_Phone            = 2,
    DCTContentType_Decimal          = 3,
    DCTContentType_Integer          = 4,
    DCTContentType_URL              = 5,
    DCTContentType_NumberAndLetter  = 6,
};
//201.输入框
@interface DCTTextFieldCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, strong) DCTDataBindInfoModel *canEdit;
@property (nonatomic, strong) DCTDataBindInfoModel *necessary;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, strong) DCTFontInfoModel *unitFont;
/**正则表达式数组*/
@property (nonatomic, copy) NSArray<NSString *> *regularExpressions;
/**文本/键盘类型 default DCTContentType_Content*/
@property (nonatomic, copy) NSNumber *contentType;
@end

//301.输入文本框
@interface DCTTextViewCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, strong) DCTDataBindInfoModel *canEdit;
@property (nonatomic, strong) DCTDataBindInfoModel *necessary;
@property (nonatomic, copy) NSNumber *minLength;
@property (nonatomic, copy) NSNumber *maxLength;
@end

//401.选择类型单元格-从字典表获取
@interface DCTPickCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, strong) DCTDataBindInfoModel *canEdit;
@property (nonatomic, strong) DCTDataBindInfoModel *necessary;
@property (nonatomic, copy) DCTDataBindInfoModel *dictionaryKey;
@end

//402.选择类型单元格-向服务器获取configList
@interface DCTPickFromServerCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, strong) DCTDataBindInfoModel *canEdit;
@property (nonatomic, strong) DCTDataBindInfoModel *necessary;
@property (nonatomic, strong) DCTURLInfoModel *request;
@end

typedef NS_ENUM(NSInteger, DCTDatePickType) {
    DCTDatePickType_YY              = 101,
    DCTDatePickType_MM              = 102,
    DCTDatePickType_DD              = 103,
    DCTDatePickType_HH              = 104,
    DCTDatePickType_mm              = 105,
    DCTDatePickType_ss              = 106,
    DCTDatePickType_YYMM            = 201,
    DCTDatePickType_MMDD            = 202,
    DCTDatePickType_DDHH            = 203,
    DCTDatePickType_HHmm            = 204,
    DCTDatePickType_mmss            = 205,
    DCTDatePickType_YYMMDD          = 301,
    DCTDatePickType_MMDDHH          = 302,
    DCTDatePickType_DDHHmm          = 303,
    DCTDatePickType_HHmmss          = 304,
    DCTDatePickType_YYMMDDHH        = 401,
    DCTDatePickType_MMDDHHmm        = 402,
    DCTDatePickType_DDHHmmss        = 403,
    DCTDatePickType_YYMMDDHHmm      = 501,
    DCTDatePickType_MMDDHHmmss      = 502,
    DCTDatePickType_YYMMDDHHmmss    = 601,
};
//501.选择单个时间单元格
@interface DCTPickDateCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, strong) DCTDataBindInfoModel *canEdit;
@property (nonatomic, strong) DCTDataBindInfoModel *necessary;
/**选择时间类型 default DCTDatePickType_YYMMDDHHmmss*/
@property (nonatomic, copy) NSNumber *datePickType;
@property (nonatomic, copy) NSDictionary *minPickDate;
@property (nonatomic, copy) NSDictionary *maxPickDate;
@end

//502.选择时间区间单元格
@interface DCTPickDateZoneCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, strong) DCTDataBindInfoModel *canEdit;
@property (nonatomic, strong) DCTDataBindInfoModel *necessary;
/**选择时间类型 default DCTDatePickType_YYMMDDHHmmss*/
@property (nonatomic, copy) NSNumber *datePickType;
@property (nonatomic, copy) NSDictionary *startMinPickDate;
@property (nonatomic, copy) NSDictionary *startMaxPickDate;
@property (nonatomic, copy) NSDictionary *endMinPickDate;
@property (nonatomic, copy) NSDictionary *endMaxPickDate;
@end

typedef NS_ENUM(NSInteger, DCTAddressPickRange) {
    DCTAddressPickRange_Country                         = 101,
    DCTAddressPickRange_Province                        = 102,
    DCTAddressPickRange_City                            = 103,
    DCTAddressPickRange_Area                            = 104,
    DCTAddressPickRange_Street                          = 105,
    DCTAddressPickRange_CountryProvince                 = 201,
    DCTAddressPickRange_ProvinceCity                    = 202,
    DCTAddressPickRange_CityArea                        = 203,
    DCTAddressPickRange_AreaStreet                      = 204,
    DCTAddressPickRange_CountryProvinceCity             = 301,
    DCTAddressPickRange_ProvinceCityArea                = 302,
    DCTAddressPickRange_CityAreaStreet                  = 303,
    DCTAddressPickRange_CountryProvinceCityArea         = 401,
    DCTAddressPickRange_ProvinceCityAreaStreet          = 402,
    DCTAddressPickRange_CountryProvinceCityAreaStreet   = 501,
};
//601.选择地址单元格-本地数据
@interface DCTPickAddressCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, strong) DCTDataBindInfoModel *canEdit;
@property (nonatomic, strong) DCTDataBindInfoModel *necessary;
//存储地址信息的keyPath
@property (nonatomic, copy, nullable) NSString *countryID;
@property (nonatomic, copy, nullable) NSString *provinceID;
@property (nonatomic, copy, nullable) NSString *cityID;
@property (nonatomic, copy, nullable) NSString *areaID;
@property (nonatomic, copy, nullable) NSString *streetID;
/**选择地址范围 default DCTAddressPickRange_CountryProvinceCityAreaStreet*/
@property (nonatomic, copy) NSNumber *pickRange;
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
@property (nonatomic, strong) DCTDataBindInfoModel *canEdit;
@property (nonatomic, strong) DCTDataBindInfoModel *necessary;
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
@property (nonatomic, strong) DCTURLInfoModel *request;
@property (nonatomic, copy) NSArray<NSString *> *carInfo;
@end

//901.多列显示
@interface DCTMultiColumnCellInfoModel : DCTBaseCellInfoModel
@end

//1001.子表格
@interface DCTSubTableCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSNumber *integrityVerification;
@property (nonatomic, strong) DCTTableViewInfoModel *tableInfo;
@end

//1101.分隔单元格
@interface DCTSeparatorCellInfoModel : DCTBaseCellInfoModel
@property (nonatomic, copy) NSString *separator;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSNumber *rowHeight;
@end

NS_ASSUME_NONNULL_END
