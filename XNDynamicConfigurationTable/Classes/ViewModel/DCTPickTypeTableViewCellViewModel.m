//
//  DCTPickTypeTableViewCellViewModel.m
//  Pods
//
//  Created by Luigi on 2019/12/18.
//

#import "DCTPickTypeTableViewCellViewModel.h"
#import "DCTContentTableViewCell.h"

@implementation DCTPickTypeTableViewCellViewModel
- (instancetype)init {
    if (self = [super init]) {
        @weakify(self)
        self.cellBlock = ^UITableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, NSDictionary * _Nonnull cellConfig, DataInfoBlock  _Nullable dataInfoBlock, UserInfoBlock  _Nullable userInfoBlock, SetDataInfoBlock  _Nullable setDataInfoBlock) {
          
            DCTPickCellInfoModel *model = [DCTPickCellInfoModel yy_modelWithJSON:cellConfig];
            DCTContentTableViewCell *cell = [DCTContentTableViewCell newCellWithTableView:tableView IndexPath:indexPath];
            
            cell.hiddenIcon = NO;
            cell.icon.image = [UIImage imageNamed:@"icon_arrow" inBundle:DCTBundle compatibleWithTraitCollection:nil];
            NSString *content = @"";
            
            @strongify(self)
            id result = [DCTUtilsClass getValueWithKeyPath:[model.content firstObject] UserInfoBlock:userInfoBlock DataInfoBlock:dataInfoBlock];
            
            if (![result isKindOfClass:[NSError class]]) {
                
                content = [NSString stringWithFormat:@"%@",result];
            } else {
                NSLog(@"-----取值失败:%@",result);
                content = [model.content firstObject];
            }
            
            if (STRING_IsNull(content)) {
                content = model.placeholder;
                cell.cellContentLabel.textColor = COLOR_PLACEHOLDER;
            } else {
                cell.cellContentLabel.textColor = COLOR_BLACK_2C;
            }
            
            [cell setDataWithTitle:model.title Content:content];
            
            return cell;
            
        };
    }
    return self;
}

- (void)pickTypeWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath CellConfig:(NSDictionary *)cellConfig DataInfoBlock:(DataInfoBlock)dataInfoBlock UserInfoBlock:(nonnull UserInfoBlock)userInfoBlock SetDataInfoBlock:(nonnull SetDataInfoBlock)setDataInfoBlock CompletedBlock:(nonnull void (^)(void))block {
    
    if (block) { block(); };
}
@end
