//
//  DCTTextFieldTableViewCellViewModel.m
//  Pods
//
//  Created by Luigi on 2019/12/16.
//

#import "DCTTextFieldTableViewCellViewModel.h"
#import "DCTTextFieldTableViewCell.h"
#import "DCTContentTableViewCell.h"

@interface DCTTextFieldTableViewCellViewModel ()
@property (nonatomic, strong) NSMutableArray<RACDisposable *> *RACObserveCache;
@end

@implementation DCTTextFieldTableViewCellViewModel
- (instancetype)init {
    if (self = [super init]) {
                
        self.RACObserveCache = [NSMutableArray new];
        @weakify(self)
        self.cellBlock = ^UITableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, NSDictionary * _Nonnull cellConfig, DataInfoBlock  _Nullable dataInfoBlock, UserInfoBlock  _Nullable userInfoBlock, SetDataInfoBlock  _Nullable setDataInfoBlock) {
            
            DCTTextFieldCellInfoModel *model = [DCTTextFieldCellInfoModel yy_modelWithJSON:cellConfig];
            
            //判断是否可编辑
            id canEdit = [DCTUtilsClass getResultWithFormulaString:model.canEdit.formulaString
                                                      RoundingType:[model.canEdit.roundingType integerValue]
                                                     DecimalNumber:[model.canEdit.decimalNumber integerValue]
                                                     UserInfoBlock:userInfoBlock
                                                     DataInfoBlock:dataInfoBlock];
    
            //根据是否可编辑返回不同类型的单元格
            if (![canEdit isKindOfClass:[NSError class]] && [canEdit boolValue]) {
                @strongify(self)
                return [self createTextFieldCellWithTableView:tableView
                                                    IndexPath:indexPath
                                                        Model:model
                                                UserInfoBlock:userInfoBlock
                                                DataInfoBlock:dataInfoBlock
                                             SetDataInfoBlock:setDataInfoBlock];
                
            } else {
                @strongify(self)
               return [self createContentCellWithTableView:tableView
                                                 IndexPath:indexPath
                                                     Model:model
                                             UserInfoBlock:userInfoBlock
                                             DataInfoBlock:dataInfoBlock];
            }
        };
    }
    return self;
}

- (DCTTextFieldTableViewCell *)createTextFieldCellWithTableView:(UITableView *)tableView
                                                      IndexPath:(NSIndexPath *)indexPath
                                                          Model:(DCTTextFieldCellInfoModel *)model
                                                  UserInfoBlock:(UserInfoBlock)userInfoBlock
                                                  DataInfoBlock:(DataInfoBlock)dataInfoBlock
                                               SetDataInfoBlock:(SetDataInfoBlock)setDataInfoBlock {
    
    DCTTextFieldTableViewCell *cell = [DCTTextFieldTableViewCell newCellWithTableView:tableView IndexPath:indexPath];
    cell.block = ^(NSString * _Nonnull text) {
        if (setDataInfoBlock) {
            if (!STRING_IsNull(model.content) && [model.content hasPrefix:@"__"]) {
                id result = setDataInfoBlock([model.content substringFromIndex:2], text);
                NSLog(@"-----赋值结果 keyPath:%@, value:%@, result:%@", [model.content substringFromIndex:2], text, result);
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }
    };
    
    id result = [DCTUtilsClass getValueWithKeyPath:model.content UserInfoBlock:userInfoBlock DataInfoBlock:dataInfoBlock];
    cell.textType = [model.contentType integerValue];
    cell.regularExpressions = model.regularExpressions;
    cell.unitString = model.unit;

    NSString *content;
    if ([result isKindOfClass:[NSError class]]) {
        NSLog(@"-----取值失败:%@",result);
        content = @"";
    } else {
        content = [NSString stringWithFormat:@"%@",result];
    }
    
    [cell setDataWithTitle:model.title Content:content Placeholder:model.placeholder];
    return cell;
}

- (DCTContentTableViewCell *)createContentCellWithTableView:(UITableView *)tableView
                                                  IndexPath:(NSIndexPath *)indexPath
                                                      Model:(DCTTextFieldCellInfoModel *)model
                                              UserInfoBlock:(UserInfoBlock)userInfoBlock
                                              DataInfoBlock:(DataInfoBlock)dataInfoBlock {
    
    DCTContentTableViewCell *cell = [DCTContentTableViewCell newCellWithTableView:tableView IndexPath:indexPath];
    id result = [DCTUtilsClass getValueWithKeyPath:model.content
                                     UserInfoBlock:userInfoBlock
                                     DataInfoBlock:dataInfoBlock];
    
    NSString *content = @"";
    if (![result isKindOfClass:[NSError class]]) {
        content = [NSString stringWithFormat:@"%@",result];
    } else {
        NSLog(@"-----取值失败:%@",result);
        content = model.content;
    }
    
    [cell setDataWithTitle:model.title Content:content];
    cell.unitString = model.unit;
    return cell;
}

- (void)dealloc {
    //取消订阅
    [self.RACObserveCache enumerateObjectsUsingBlock:^(RACDisposable * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dispose];
    }];
}

@end
