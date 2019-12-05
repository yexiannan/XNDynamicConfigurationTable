//
//  Target_DynamicConfigurationTable.h
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_DynamicConfigurationTable : NSObject
//判断数据是否填写完整 需传入数据和配置表 @{ @"data":@{}, @"configuration":@{} }
- (BOOL)Action_DataIsCompleted:(NSDictionary *)params;
- (UIView *)Action_CreateDynamicConfigurationTable:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
