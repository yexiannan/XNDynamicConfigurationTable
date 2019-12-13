//
//  Target_DynamicConfigurationTable.m
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/2.
//

#import "Target_DynamicConfigurationTable.h"
#import "DCTBaseTableView.h"

@implementation Target_DynamicConfigurationTable
- (UIView *)Action_createDynamicConfigurationTable:(NSDictionary *)params {
    /*
    根据配置表创建自定义表格 @{ @"params" : @{ @"configurationInfo" : @{},
                                           @"dataInfo" : @{} },
                            @"block" : @{ @"saveBlock" : saveBlock,
                                          @"nextBlock" : nextBlock,
                                          @"userInfoBlock" : userInfoBlock}
                         }
    */
    id param = [params objectForKey:@"params"];
    id block = [params objectForKey:@"block"];
    id configurationInfo, dataInfo;
    
    void (^saveBlock)(NSDictionary *dataInfo);
    void (^nextBlock)(NSDictionary *dataInfo);
    id (^userInfoBlock)(NSString *keyPath);

    if ([param isKindOfClass:[NSDictionary class]]) {
        configurationInfo = [(NSDictionary *)param objectForKey:@"configurationInfo"];
        dataInfo = [(NSDictionary *)param objectForKey:@"dataInfo"];
    }
    
    if ([block isKindOfClass:[NSDictionary class]]) {
        saveBlock = [(NSDictionary *)block objectForKey:@"saveBlock"];
        nextBlock = [(NSDictionary *)block objectForKey:@"nextBlock"];
        userInfoBlock = [(NSDictionary *)block objectForKey:@"userInfoBlock"];
    }
        
    NSAssert([configurationInfo isKindOfClass:[NSDictionary class]], @"配置表信息为空或类型错误");
//    NSAssert([dataInfo isKindOfClass:[NSDictionary class]], @"表格数据为空或类型错误");
    
    DCTBaseTableView *view = [[DCTBaseTableView alloc] initWithConfigurationInfo:configurationInfo
                                                                        DataInfo:dataInfo
                                                                       SaveBlock:saveBlock
                                                                       NextBlock:nextBlock
                                                                   UserInfoBlock:userInfoBlock];
    return view;
}

- (void)Action_saveDynamicConfigurationTable:(NSDictionary *)params {
    
}

@end
