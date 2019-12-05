//
//  DCTBaseTableView.h
//  XNDynamicConfigurationTable
//
//  Created by Luigi on 2019/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCTBaseTableView : UIView
@property (nonatomic, copy) NSDictionary *configurationInfo;//配置信息
@property (nonatomic, copy) NSDictionary *dataInfo;//数据
@property (nonatomic, strong) RACCommand *submitCommand;
@property (nonatomic, strong) RACCommand *saveCommand;
@end

/**
配置信息层级：
 configurationInfo
           ｜- title : 表格标题
           ｜-  sections : 分区信息字典数组
                   ｜- title : 分区标题
                   ｜- subTitle : 副标题
                   ｜- sort : 排序
                   ｜- defaultShow : 默认是否显示
                   ｜- cells : 单元格信息数组
                           ｜- cellType : 单元格类型
                           ｜- sort : 排序
                           ｜- content : 单元格存储的字段名数组
                           ｜- title : 单元格的标题数组
                           ｜- placeholder : 提示语数组
                           ｜- editStatus : 判断可编辑阶段数组
                           ｜- cellType : 单元格类型
                           ｜- cellType : 单元格类型


*/

NS_ASSUME_NONNULL_END
