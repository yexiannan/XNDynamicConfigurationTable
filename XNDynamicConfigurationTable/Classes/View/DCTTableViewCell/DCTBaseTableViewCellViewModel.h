//
//  DCTBaseTableViewCellViewModel.h
//  Pods
//
//  Created by Luigi on 2019/12/13.
//

#import <Foundation/Foundation.h>
#import "DCTConfigurationModel.h"
#import "DCTFormulaCalculation.h"

NS_ASSUME_NONNULL_BEGIN

typedef id _Nullable (^userInfoBlock)(NSString *);

@interface DCTBaseTableViewCellViewModel : NSObject
@property (nonatomic, copy) UITableViewCell *(^cellBlock)(UITableView *tableView, NSIndexPath *indexPath, NSDictionary *cellConfig ,NSMutableDictionary *dataInfo, _Nullable userInfoBlock userInfoBlock);
- (id)getValueWithKeyPath:(NSString *)keyPath DataDictionary:(NSDictionary *)dataDictionary UserInfoBlock:(nullable userInfoBlock)userInfoBlock;
@end

NS_ASSUME_NONNULL_END
