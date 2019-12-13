//
//  DCTFormulaCalculation.h
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DCTRoundingType) {
    DCTRoundingType_Round,//四舍五入
    DCTRoundingType_Up,//向上取整
    DCTRoundingType_Down,//向下取整
};

@interface DCTFormulaCalculation : NSObject
/**
 * formulaString:算式字符串 dataDict:数据字典 roundingType:取整方式 decimalNumber:取小数点后几位
 */
+ (id)getResultWithFormulaString:(NSString *)formulaString DataDictionary:(NSDictionary *)dataDict RoundingType:(DCTRoundingType)roundingType DecimalNumber:(NSInteger)decimalNumber;
@end

NS_ASSUME_NONNULL_END
