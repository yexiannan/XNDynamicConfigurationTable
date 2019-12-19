//
//  DCTTextFieldTableViewCellViewModel.m
//  Pods
//
//  Created by Luigi on 2019/12/16.
//

#import "DCTTextFieldTableViewCellViewModel.h"
#import "DCTTextFieldTableViewCell.h"

@implementation DCTTextFieldTableViewCellViewModel
- (instancetype)init {
    if (self = [super init]) {
        @weakify(self)
        self.cellBlock = ^UITableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, NSDictionary * _Nonnull cellConfig, DataInfoBlock  _Nullable dataInfoBlock, UserInfoBlock  _Nullable userInfoBlock, SetDataInfoBlock  _Nullable setDataInfoBlock) {
            
            DCTTextFieldCellInfoModel *model = [DCTTextFieldCellInfoModel yy_modelWithJSON:cellConfig];
            
            id canEdit = [DCTUtilsClass getResultWithFormulaString:model.canEdit.formulaString
                                                      RoundingType:[model.canEdit.roundingType integerValue]
                                                     DecimalNumber:[model.canEdit.decimalNumber integerValue]
                                                     UserInfoBlock:userInfoBlock
                                                     DataInfoBlock:dataInfoBlock];
            
            DCTTextFieldTableViewCell *cell = [DCTTextFieldTableViewCell newCellWithTableView:tableView IndexPath:indexPath];

            @strongify(self)
            self.block = cell.block;
            id result = [DCTUtilsClass getValueWithKeyPath:model.content UserInfoBlock:userInfoBlock DataInfoBlock:dataInfoBlock];
            cell.textType = [model.contentType integerValue];
            cell.regularExpressions = model.regularExpressions;
            cell.unitString = model.unit;

            NSString *content;
            if ([result isKindOfClass:[NSError class]]) {
                NSLog(@"-----取值失败:%@",result);
                content = @"";
                
            } else {
                
                content = [NSString stringWithFormat:@"%@",content];
            }
            [cell setDataWithTitle:model.title Content:content Placeholder:model.placeholder];
            return  cell;
        };
    }
    return self;
}
@end
