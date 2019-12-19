//
//  DCTBaseTableViewCellViewModel.h
//  Pods
//
//  Created by Luigi on 2019/12/13.
//

#import <Foundation/Foundation.h>
#import "DCTConfigurationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCTBaseTableViewCellViewModel : NSObject
@property (nonatomic, copy) UITableViewCell *(^cellBlock)(UITableView *tableView, NSIndexPath *indexPath, NSDictionary *cellConfig ,_Nullable DataInfoBlock dataInfoBlock, _Nullable UserInfoBlock userInfoBlock, _Nullable SetDataInfoBlock setDataInfoBlock);
@end

NS_ASSUME_NONNULL_END
