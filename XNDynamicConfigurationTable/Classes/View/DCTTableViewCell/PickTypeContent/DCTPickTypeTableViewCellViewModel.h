//
//  DCTPickTypeTableViewCellViewModel.h
//  Pods
//
//  Created by Luigi on 2019/12/18.
//

#import "DCTBaseTableViewCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCTPickTypeTableViewCellViewModel : DCTBaseTableViewCellViewModel

- (void)pickTypeWithTableView:(UITableView *)tableView
                    IndexPath:(NSIndexPath *)indexPath
                   CellConfig:(NSDictionary *)cellConfig
                DataInfoBlock:(DataInfoBlock)dataInfoBlock
                UserInfoBlock:(UserInfoBlock)userInfoBlock
               CompletedBlock:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
