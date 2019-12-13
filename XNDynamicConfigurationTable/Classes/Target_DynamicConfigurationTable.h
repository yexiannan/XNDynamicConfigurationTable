//
//  Target_DynamicConfigurationTable.h
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_DynamicConfigurationTable : NSObject
/*
 根据配置表创建自定义表格 @{ @"params" : @{ @"configurationInfo" : @{},
                                        @"dataInfo" : @{} },
                         @"block" : @{ @"saveBlock" : saveBlock,
                                       @"nextBlock" : nextBlock,
                                       @"userInfoBlock" : userInfoBlock }
                      }
 */
- (UIView *)Action_createDynamicConfigurationTable:(NSDictionary *)params;

/*
 @{ @"params" : @{ @"configurationInfo" : @{} }
    @"block" : @{ @"successBlock" : successBlock,
                  @"failureBlock" : failureBlock}
 }
 */
- (void)Action_saveDynamicConfigurationTable:(NSDictionary *)params;
 
@end

NS_ASSUME_NONNULL_END
