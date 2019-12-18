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
        self.cellBlock = ^UITableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, NSDictionary * _Nonnull cellConfig, NSMutableDictionary * _Nonnull dataInfo, userInfoBlock  _Nonnull userInfoBlock) {
            
            DCTTextFieldCellInfoModel *model = [DCTTextFieldCellInfoModel yy_modelWithJSON:cellConfig];
            
            id canEdit = [DCTFormulaCalculation getResultWithFormulaString:model.canEdit.formulaString DataDictionary:dataInfo RoundingType:model.canEdit.roundingType DecimalNumber:model.canEdit.decimalNumber];
            
            DCTTextFieldTableViewCell *cell = [DCTTextFieldTableViewCell newCellWithTableView:tableView IndexPath:indexPath];

            @strongify(self)
            self.block = cell.block;
            id result = [self getValueWithKeyPath:model.content DataDictionary:dataInfo UserInfoBlock:userInfoBlock];
            cell.textType = [model.contentType integerValue];
            cell.regularExpressions = model.regularExpressions;
            cell.unitString = model.unit;

            NSString *content;
            if ([result isKindOfClass:[NSError class]]) {
                
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
