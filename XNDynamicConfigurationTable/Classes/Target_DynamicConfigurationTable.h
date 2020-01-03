//
//  Target_DynamicConfigurationTable.h
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_DynamicConfigurationTable : NSObject
/**
 *根据创建自定义表格，params应包含以下参数：
 *
    @{  @"params" : @{ @"configurationInfo" : @{} }, //配置表信息
        @"block" : @{ @"saveBlock" : saveBlock,    //保存操作
                  @"nextBlock" : nextBlock,     //下一步操作
                  @"dataInfoBlock" : dataInfoBlock     //获取数据操作
                  @"userInfoBlock" : userInfoBlock   //获取用户信息操作
                  @"configBlock" : configBlock   //获取字典表信息操作
                  @"dataInfoBind" : dataInfoBind    //绑定数据操作
                  @"userInfoBind" : userInfoBInd  //绑定用户信息操作
                  @"setDataInfoBlock" : setDataInfoBlock }  //设置更新数据操作
 }
 *
 *
 *
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
