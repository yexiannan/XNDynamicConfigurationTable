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
 根据配置表创建自定义表格 @{ @"params" : @{ @"configurationInfo" : @{} },
                         @"block" : @{ @"saveBlock" : saveBlock,
                                       @"nextBlock" : nextBlock,
                                       @"dataInfoBlock" : dataInfoBlock
                                       @"userInfoBlock" : userInfoBlock
                                       @"dataInfoBind" : dataInfoBind
                                       @"userInfoBind" : userInfoBInd }
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
 
@property (nonatomic, strong) NSString *ppp;

@end

NS_ASSUME_NONNULL_END
