//
//  DCTFormulaCalculation.m
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/11/25.
//

#import "DCTFormulaCalculation.h"

@implementation DCTFormulaCalculation
/**
 * formulaString:算式字符串 dataDict:数据字典 roundingType:取整方式 digitsAfterPoint:取小数点后几位
 */
+ (id)getResultWithFormulaString:(NSString *)formulaString DataDictionary:(NSDictionary *)dataDict RoundingType:(DCTRoundingType)roundingType DecimalNumber:(NSInteger)decimalNumber {
    //当传入的算式字符串为空或非字符串时 返回空
    if (STRING_IsNull(formulaString)) {
        return @"";
    }
    
    NSInteger leftParenthesisCount = [NSMutableArray arrayWithArray:[formulaString componentsSeparatedByString:@"("]].count;
    NSInteger rightParenthesisCount = [NSMutableArray arrayWithArray:[formulaString componentsSeparatedByString:@")"]].count;
    if (leftParenthesisCount != rightParenthesisCount) {
        return [self createErrorWithErrorString:@"左右括号数量不一致"];
    }
    
    return [self getResultWithCorrectFormulaString:formulaString DataDictionary:dataDict RoundingType:roundingType DecimalNumber:decimalNumber];
}


+ (id)getResultWithCorrectFormulaString:(NSString *)formulaString DataDictionary:(NSDictionary *)dataDict RoundingType:(DCTRoundingType)roundingType DecimalNumber:(NSInteger)decimalNumber{
    
    NSRange firstTernaryOperatorRange = [formulaString rangeOfString:@" ? "];
    //三目运算
    if (firstTernaryOperatorRange.length > 0) {
        NSString *forntString = [formulaString substringToIndex:firstTernaryOperatorRange.location];
        NSString *behindString = [formulaString substringFromIndex:firstTernaryOperatorRange.location + firstTernaryOperatorRange.length];
        id ternaryOperatorResult = [self getResultWithFormulaString:forntString DataDictionary:dataDict RoundingType:roundingType DecimalNumber:decimalNumber];
        if ([ternaryOperatorResult isKindOfClass:[NSError class]]) {
            return ternaryOperatorResult;
        }
        //去除前部逻辑判断字符串
        forntString = [self stringOfTernaryOperatorForntPart:forntString];
        //根据结果去除后部结果字符串
        behindString = [self stringOfTernaryOperatorBehindPart:behindString TernaryOperatorResult:[ternaryOperatorResult boolValue]];
    
        return [self getResultWithFormulaString:[forntString stringByAppendingString:behindString] DataDictionary:dataDict RoundingType:roundingType DecimalNumber:decimalNumber];
    }

    NSMutableArray *leftParenthesis = [NSMutableArray arrayWithArray:[formulaString componentsSeparatedByString:@"("]];
    NSInteger leftParenthesisCount = leftParenthesis.count;

    NSMutableArray *rightParenthesis = [NSMutableArray arrayWithArray:[[leftParenthesis lastObject] componentsSeparatedByString:@")"]];
    //无算式只有一个keyPath时 直接返回绑定的值
    if (leftParenthesisCount  == 1) {
        return [self getValueFromDictionary:dataDict KeyPath:[leftParenthesis firstObject] RoundingType:roundingType DecimalNumber:decimalNumber];
    }
    
    //计算最里层的算式
    NSString *formula = [rightParenthesis firstObject];
    id result = [self getResultOfSingleFormula:formula DataDictionart:dataDict RoundingType:roundingType DecimalNumber:decimalNumber];

    if ([result isKindOfClass:[NSError class]]) {
        return result;
    }
    
    //只有单个算式时 直接返回计算后的值
    if (rightParenthesis.count == 2) {
        return result;
    }
    
    //当rightParenthesis.count > 2时表示算式还未结束，需将得出的结果传递至下一个循环
    if (![result isKindOfClass:[NSString class]]) {
        return [self createErrorWithErrorString:[NSString stringWithFormat:@"%@根据参数获取到的数据格式不正确",formula]];
    }
    
    NSString *newRightFormula = [(NSString *)result stringByAppendingString:rightParenthesis[1]];
    [rightParenthesis replaceObjectAtIndex:0 withObject:newRightFormula];
    [rightParenthesis removeObjectAtIndex:1];
    
    NSString *newLegtFormula = [[leftParenthesis objectAtIndex:leftParenthesis.count - 2] stringByAppendingString:[rightParenthesis componentsJoinedByString:@")"]];
    [leftParenthesis replaceObjectAtIndex:leftParenthesis.count - 1 withObject:newLegtFormula];
    [leftParenthesis removeObjectAtIndex:leftParenthesis.count - 2];

    NSString *newFormula = [leftParenthesis componentsJoinedByString:@"("];
    
    return [self getResultWithFormulaString:newFormula DataDictionary:dataDict RoundingType:roundingType DecimalNumber:decimalNumber];
}

/**
 * 计算单个算式 @"carInfoObj.price + carInfoObj.payment" => @"1505"
 */
+ (id)getResultOfSingleFormula:(NSString *)formula DataDictionart:(NSDictionary *)dataDict RoundingType:(DCTRoundingType)roundingType DecimalNumber:(NSInteger)decimalNumber{
    NSArray<NSString *> *paramsArray = [formula componentsSeparatedByString:@" "];
    if (paramsArray.count != 3) {
        if (paramsArray.count == 1) {
            return [self getValueFromDictionary:dataDict KeyPath:[paramsArray firstObject] RoundingType:roundingType DecimalNumber:decimalNumber];
        }
        return [self createErrorWithErrorString:[NSString stringWithFormat:@"%@算式格式不正确,缺少参数或参数间未用空格分割",formula]];
    }
    
    id firstValue = [self getValueFromDictionary:dataDict KeyPath:[paramsArray firstObject] RoundingType:roundingType DecimalNumber:decimalNumber];
    id secondValue = [self getValueFromDictionary:dataDict KeyPath:[paramsArray lastObject] RoundingType:roundingType DecimalNumber:decimalNumber];
    NSString *equationSymbolString = paramsArray[1];
    NSSet *equationSymbols = [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"%", @"||", @"&&", @"==", @"<", @"<=", @">", @">=", @"^", @"&", @"|", @"equal", nil];

    //算式有效性验证
    if ([firstValue isKindOfClass:[NSError class]]) {
        return firstValue;
    }
    if ([secondValue isKindOfClass:[NSError class]]) {
        return secondValue;
    }
    if (![firstValue isKindOfClass:[NSString class]]) {
        return [self createErrorWithErrorString:[NSString stringWithFormat:@"%@根据参数获取到的数据格式不正确",[paramsArray firstObject]]];
    }
    if (![secondValue isKindOfClass:[NSString class]]) {
        return [self createErrorWithErrorString:[NSString stringWithFormat:@"%@根据参数获取到的数据格式不正确",[paramsArray lastObject]]];
    }
    if (![equationSymbols containsObject:equationSymbolString]) {
        return [self createErrorWithErrorString:[NSString stringWithFormat:@"%@算式格式不正确,请使用正确的计算符号",equationSymbolString]];
    }
    
    
    
    //根据算式符号计算值
    //字符相等判断
    if ([equationSymbolString isEqualToString:@"equal"]) {
        return [NSString stringWithFormat:@"%d",[[NSString stringWithFormat:@"%@",firstValue] isEqualToString:[NSString stringWithFormat:@"%@",secondValue]]];
    }
    
    //判断是否为数字
    if (![self stringIsNumber:firstValue]) {
        return [self createErrorWithErrorString:[NSString stringWithFormat:@"数据异常%@格式错误",[paramsArray firstObject]]];
    }
    if (![self stringIsNumber:secondValue]) {
        return [self createErrorWithErrorString:[NSString stringWithFormat:@"数据异常%@格式错误",[paramsArray lastObject]]];
    }
    
    //运算符号
    if ([equationSymbolString isEqualToString:@"+"]) {
        return [self getRoundResultWithValue:[firstValue doubleValue] + [secondValue doubleValue]
                                RoundingType:roundingType
                               DecimalNumber:decimalNumber];
    }
    
    if ([equationSymbolString isEqualToString:@"-"]) {
        return [self getRoundResultWithValue:[firstValue doubleValue] - [secondValue doubleValue]
                                RoundingType:roundingType
                               DecimalNumber:decimalNumber];
    }
    
    if ([equationSymbolString isEqualToString:@"*"]) {
        return [self getRoundResultWithValue:[firstValue doubleValue] * [secondValue doubleValue]
                                RoundingType:roundingType
                               DecimalNumber:decimalNumber];
    }
    
    if ([equationSymbolString isEqualToString:@"/"]) {
        return [self getRoundResultWithValue:[firstValue doubleValue] / [secondValue doubleValue]
                                RoundingType:roundingType
                               DecimalNumber:decimalNumber];
    }
    
    if ([equationSymbolString isEqualToString:@"%"]) {
        //分割字符判断小数位数 先将小数转为整数，取余后在转回小数
        NSString *firstValueString = [NSString stringWithFormat:@"%@",firstValue];
        NSString *secondValueString = [NSString stringWithFormat:@"%@",secondValue];

        NSInteger powNum = pow(10, 6);
        
        NSInteger intFirstValue = [firstValueString doubleValue] * powNum;
        NSInteger intSecondValue = [secondValueString doubleValue] * powNum;
    
        return [self getRoundResultWithValue:(intFirstValue % intSecondValue) / powNum
                                RoundingType:roundingType
                               DecimalNumber:decimalNumber];
    }
    
    
    //大小判断
    long double firstDoubleValue = [self getDoubleOfRoundResultWithValue:[firstValue doubleValue] RoundingType:roundingType DecimalNumber:decimalNumber];
    long double secondDoubleValue = [self getDoubleOfRoundResultWithValue:[secondValue doubleValue] RoundingType:roundingType DecimalNumber:decimalNumber];
    
    if ([equationSymbolString isEqualToString:@"=="]) {
        return [NSString stringWithFormat:@"%d",firstDoubleValue == secondDoubleValue];
    }
    
    if ([equationSymbolString isEqualToString:@"<"]) {
        return [NSString stringWithFormat:@"%d",firstDoubleValue < secondDoubleValue];
    }
    
    if ([equationSymbolString isEqualToString:@"<="]) {
        return [NSString stringWithFormat:@"%d",firstDoubleValue <= secondDoubleValue];
    }
    
    if ([equationSymbolString isEqualToString:@">"]) {
        return [NSString stringWithFormat:@"%d",firstDoubleValue > secondDoubleValue];
    }
    
    if ([equationSymbolString isEqualToString:@">="]) {
        return [NSString stringWithFormat:@"%d",firstDoubleValue >= secondDoubleValue];
    }
    
    //逻辑判断
    if ([equationSymbolString isEqualToString:@"||"]) {
        return [NSString stringWithFormat:@"%d",[firstValue boolValue] || [secondValue boolValue]];
    }
    
    if ([equationSymbolString isEqualToString:@"&&"]) {
        return [NSString stringWithFormat:@"%d",[firstValue boolValue] && [secondValue boolValue]];
    }
    
    if ([equationSymbolString isEqualToString:@"^"]) {
        return [NSString stringWithFormat:@"%d",[firstValue boolValue] ^ [secondValue boolValue]];
    }
    
    if ([equationSymbolString isEqualToString:@"&"]) {
        return [NSString stringWithFormat:@"%d",[firstValue boolValue] & [secondValue boolValue]];
    }
    
    if ([equationSymbolString isEqualToString:@"|"]) {
        return [NSString stringWithFormat:@"%d",[firstValue boolValue] | [secondValue boolValue]];
    }
    
    return [self createErrorWithErrorString:@"未知错误"];
}

#pragma mark - 舍入操作
/**
 * 舍入与取位数操作 支持17位有效数字的操作
 */
+ (NSString *)getRoundResultWithValue:(long double)value RoundingType:(DCTRoundingType)roundingType DecimalNumber:(NSInteger)decimalNumber {
    long double result = [self getDoubleOfRoundResultWithValue:value RoundingType:roundingType DecimalNumber:decimalNumber];
    NSString *resultString = [NSString stringWithFormat:@"%0.17Lf",result];
    if (decimalNumber > 0) {
        return [resultString substringToIndex:[resultString rangeOfString:@"."].location + 1 + decimalNumber];
    }
    return [resultString substringToIndex:[resultString rangeOfString:@"."].location];
}

/**
 * 舍入与取位数操作 支持17位有效数字的操作
 */
+ (long double)getDoubleOfRoundResultWithValue:(long double)value RoundingType:(DCTRoundingType)roundingType DecimalNumber:(NSInteger)decimalNumber {
    long double roundindResult = value;
    NSInteger powNum = pow(10, decimalNumber);

    if (roundingType == DCTRoundingType_Up) { roundindResult = ceill(value * powNum) / powNum; }
    if (roundingType == DCTRoundingType_Down) { roundindResult = floorl(value * powNum) / powNum; }
    if (roundingType == DCTRoundingType_Round) { roundindResult = roundl(value * powNum) / powNum; }
    
    return roundindResult;
}

#pragma mark - 取值操作
/**
 * 根据keyPath从字典中取出值 不以__开头的为数值直接返回
 */
+ (id)getValueFromDictionary:(NSDictionary *)dataDict KeyPath:(NSString *)keyPath RoundingType:(DCTRoundingType)roundingType DecimalNumber:(NSInteger)decimalNumber{
    if (![keyPath hasPrefix:@"__"]) {
       if ([self stringIsNumber:keyPath]) {
            return [self getRoundResultWithValue:[keyPath doubleValue] RoundingType:roundingType DecimalNumber:decimalNumber];
        }
        return keyPath;
    }
    
    NSString *aKeyPath = [keyPath substringFromIndex:2];
    NSArray<NSString *> *keyPathArray = [aKeyPath componentsSeparatedByString:@"."];
    __block id value = dataDict;
    [keyPathArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[NSDictionary class]] && [[value allKeys] containsObject:obj]) {
            value = [value objectForKey:obj];
        } else {
            value = [self createErrorWithErrorString:[NSString stringWithFormat:@"获取数据异常,%@路径不存在",aKeyPath]];
            *stop = YES;
        }
    }];
    
    if ([self stringIsNumber:value]) {
        return [self getRoundResultWithValue:[value doubleValue] RoundingType:roundingType DecimalNumber:decimalNumber];
    }
    
    return value;
}

#pragma mark - 三目运算符
/**
 * 删除三目运算符前一个（）
 */
+ (NSString *)stringOfTernaryOperatorForntPart:(NSString *)formulaString {
    NSMutableArray *leftParenthesis = [NSMutableArray arrayWithArray:[formulaString componentsSeparatedByString:@"("]];
    NSInteger leftParenthesisCount = leftParenthesis.count;
    NSInteger rightParenthesisCount = [formulaString componentsSeparatedByString:@")"].count;

    NSInteger leftParenthesisIndex = leftParenthesisCount - rightParenthesisCount;

    return [formulaString substringToIndex:leftParenthesisIndex];
}

/**
 * 根据结果删除三目运算符后的值
 */
+ (NSString *)stringOfTernaryOperatorBehindPart:(NSString *)formulaString TernaryOperatorResult:(BOOL)ternaryOperatorResult{
    NSArray *resultFormulaArray = [formulaString componentsSeparatedByString:@" : "];
    NSMutableString *failureString = [NSMutableString stringWithString:[resultFormulaArray lastObject]];
    NSMutableString *successString = [NSMutableString stringWithString:[resultFormulaArray firstObject]];
    NSRange failureFirstParenthesisRange = [self rangeOfFirstParenthesis:failureString];
    if (ternaryOperatorResult) {
        [failureString replaceCharactersInRange:failureFirstParenthesisRange withString:@""];
        if ([successString containsString:@"("]) {
            [successString deleteCharactersInRange:NSMakeRange(successString.length - 1, 1)];
            [successString deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        
        [successString appendString:failureString];
        return successString;
    } else {
        if ([failureString containsString:@"("]) {
            [failureString deleteCharactersInRange:NSMakeRange(failureFirstParenthesisRange.length - 1, 1)];
            [failureString deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        
        return failureString;
    }
}

//第一个()的range 左括号的数量必须大于右括号的数量，否则会导致while循环无法跳出
+ (NSRange)rangeOfFirstParenthesis:(NSString *)formulaString {
    NSMutableString *mutableFormulaString = [NSMutableString stringWithString:formulaString];
    NSInteger tag = 0;
    NSInteger rightParenthesisLocation = 0;
    NSInteger leftParenthesisLocation = 0;

    while (tag != -1) {
        NSRange firstRightParenthesisRange = [mutableFormulaString rangeOfString:@")"];
        NSRange firstLeftParenthesisRange = [mutableFormulaString rangeOfString:@"("];
        
        if (firstLeftParenthesisRange.location < firstRightParenthesisRange.location && firstLeftParenthesisRange.length > 0) {
            tag += 1;
            [mutableFormulaString replaceCharactersInRange:firstLeftParenthesisRange withString:@" "];
        } else {
            tag += -1;
            [mutableFormulaString replaceCharactersInRange:firstRightParenthesisRange withString:@" "];
        }
        
        rightParenthesisLocation = firstRightParenthesisRange.location;
        leftParenthesisLocation = firstLeftParenthesisRange.location;
        if (tag == 0) {
            tag = -1;
        }
    }
        
    
    if ([formulaString rangeOfString:@"("].length > 0) {
        return NSMakeRange(0, rightParenthesisLocation + 1);
    } else {
        //若无括号只有值时
        return NSMakeRange(0, rightParenthesisLocation);
    }
}

#pragma mark -
/**
 * 快速创建错误
 */
+ (NSError *)createErrorWithErrorString:(NSString *)error {
    return [NSError errorWithDomain:error code:0 userInfo:nil];
}

/**
 * 匹配字符串是否为数字
 */
+ (BOOL)stringIsNumber:(NSString *)numberString {
    if (numberString.length == 0) {
        return NO;
    }
    NSString *regex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:numberString];
}

@end
