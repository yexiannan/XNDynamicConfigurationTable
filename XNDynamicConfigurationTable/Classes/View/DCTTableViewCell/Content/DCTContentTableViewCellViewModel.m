//
//  DCTContentTableViewCellViewModel.m
//  Pods
//
//  Created by Luigi on 2019/12/16.
//

#import "DCTContentTableViewCellViewModel.h"
#import "DCTContentTableViewCell.h"


@implementation DCTContentTableViewCellViewModel
- (instancetype)init {
    if (self = [super init]) {
        
        @weakify(self)
        self.cellBlock = ^UITableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, NSDictionary * _Nonnull cellConfig, DataInfoBlock  _Nullable dataInfoBlock, UserInfoBlock  _Nullable userInfoBlock, SetDataInfoBlock  _Nullable setDataInfoBlock) {
            
            DCTContentCellInfoModel *model = [DCTContentCellInfoModel yy_modelWithJSON:cellConfig];
            DCTContentTableViewCell *cell = [DCTContentTableViewCell newCellWithTableView:tableView IndexPath:indexPath];
            NSMutableArray *contentArray = [[NSMutableArray alloc] initWithCapacity:model.content.count];
            
            [model.content enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                @strongify(self)
                id result = [DCTUtilsClass getValueWithKeyPath:obj UserInfoBlock:userInfoBlock DataInfoBlock:dataInfoBlock];
                
                if (![result isKindOfClass:[NSError class]]) {
                    
                    [contentArray addObject:[NSString stringWithFormat:@"%@",result]];
                } else {
                    NSLog(@"-----取值失败:%@",result);
                    [contentArray addObject:obj];
                }
            }];
            [cell setDataWithTitle:model.title Content:[contentArray componentsJoinedByString:model.separator]];
            return  cell;
        };
    }
    return  self;
}
@end
