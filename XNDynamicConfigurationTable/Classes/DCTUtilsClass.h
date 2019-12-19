//
//  DCTUtilsClass.h
//  Pods
//
//  Created by Luigi on 2019/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, DCTRoundingType) {
    DCTRoundingType_Round,//四舍五入
    DCTRoundingType_Up,//向上取整
    DCTRoundingType_Down,//向下取整
};

typedef id _Nullable (^UserInfoBlock)(NSString *_Nonnull);
typedef id _Nullable (^DataInfoBlock)(NSString *_Nonnull);

typedef RACSignal * _Nullable (^UserInfoBind)(NSString *_Nonnull);
typedef RACSignal * _Nullable (^DataInfoBind)(NSString *_Nonnull);

@interface DCTUtilsClass : NSObject

/**
 * formulaString:算式字符串 dataDict:数据字典 roundingType:取整方式 decimalNumber:取小数点后几位 userInfoBlock:用户信息取值block dataInfoBlock:数据取值block
 */
+ (id)getResultWithFormulaString:(NSString *)formulaString RoundingType:(DCTRoundingType)roundingType DecimalNumber:(NSInteger)decimalNumber UserInfoBlock:(UserInfoBlock)userInfoBlock DataInfoBlock:(DataInfoBlock)dataInfoBlock;
/**
 * 根据keyPath获取值 暂时只支持两种类型数据的获取 "__"开头表示从dataInfo中获取,“##”开头表示从userInfo中获取
 */
+ (id)getValueWithKeyPath:(NSString *)keyPath UserInfoBlock:(UserInfoBlock)userInfoBlock DataInfoBlock:(DataInfoBlock)dataInfoBlock;
/**
 * 带舍入操作的取值
 */
+ (id)getValueWithKeyPath:(NSString *)keyPath UserInfoBlock:(UserInfoBlock)userInfoBlock DataInfoBlock:(DataInfoBlock)dataInfoBlock RoundingType:(DCTRoundingType)roundingType DecimalNumber:(NSInteger)decimalNumber;

/**
 * 根据keyPath设置监听
 */
- (RACSignal *)setObserveWithKeyPath:(NSString *)keyPath UserInfoBind:(UserInfoBind)userInfoBind DataInfoBind:(DataInfoBind)dataInfoBind;

@property (nonatomic, strong) NSString *ppp;

@end

NS_ASSUME_NONNULL_END
