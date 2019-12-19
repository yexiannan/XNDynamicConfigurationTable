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
    根据配置表创建自定义表格 @{ @"params" : @{ @"configurationInfo" : @{} },
                            @"block" : @{ @"saveBlock" : saveBlock,
                                          @"nextBlock" : nextBlock,
                                          @"dataInfoBlock" : dataInfoBlock
                                          @"userInfoBlock" : userInfoBlock
                                          @"dataInfoBind" : dataInfoBind
                                          @"userInfoBind" : userInfoBInd
                                          @"setDataInfoBlock" : setDataInfoBlock }
                         }
    */
    id param = [params objectForKey:@"params"];
    id block = [params objectForKey:@"block"];
    id configurationInfo;
    
    void (^saveBlock)(NSDictionary *dataInfo);
    void (^nextBlock)(NSDictionary *dataInfo);
    DataInfoBlock dataInfoBlock;
    UserInfoBlock userInfoBlock;
    DataInfoBind dataInfoBind;
    UserInfoBind userInfoBind;
    SetDataInfoBlock setDataInfoBlock;
    
    if ([param isKindOfClass:[NSDictionary class]]) {
        configurationInfo = [(NSDictionary *)param objectForKey:@"configurationInfo"];
    }
    
    if ([block isKindOfClass:[NSDictionary class]]) {
        saveBlock = [(NSDictionary *)block objectForKey:@"saveBlock"];
        nextBlock = [(NSDictionary *)block objectForKey:@"nextBlock"];
        dataInfoBlock = [(NSDictionary *)block objectForKey:@"dataInfoBlock"];
        userInfoBlock = [(NSDictionary *)block objectForKey:@"userInfoBlock"];
        dataInfoBind = [(NSDictionary *)block objectForKey:@"dataInfoBind"];
        userInfoBind = [(NSDictionary *)block objectForKey:@"userInfoBind"];
        setDataInfoBlock = [(NSDictionary *)block objectForKey:@"setDataInfoBlock"];
    }
        
    NSAssert([configurationInfo isKindOfClass:[NSDictionary class]], @"配置表信息为空或类型错误");
    
    DCTBaseTableView *view = [[DCTBaseTableView alloc] initWithConfigurationInfo:configurationInfo
                                                                       SaveBlock:saveBlock
                                                                       NextBlock:nextBlock
                                                                   DataInfoBlock:dataInfoBlock
                                                                   UserInfoBlock:userInfoBlock
                                                                    DataInfoBind:dataInfoBind
                                                                    UserInfoBind:userInfoBind
                                                                SetDataInfoBlock:setDataInfoBlock];
    return view;
}

- (void)Action_saveDynamicConfigurationTable:(NSDictionary *)params {
    
}

@end
