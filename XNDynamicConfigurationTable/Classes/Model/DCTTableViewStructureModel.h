//
//  DCTTableViewStructureModel.h
//  Pods
//
//  Created by Luigi on 2019/12/26.
//

#import <Foundation/Foundation.h>
#import "DCTSectionHeaderViewModel.h"
#import "DCTBaseTableViewCellViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCTCellStructureModel : NSObject
@property (nonatomic, copy) NSNumber *sort;
@property (nonatomic, strong) DCTBaseTableViewCellViewModel *cellViewModel;
@end

@interface DCTSectionStructureModel : NSObject
@property (nonatomic, copy) NSNumber *sort;
@property (nonatomic, strong) NSMutableArray<DCTCellStructureModel *> *cells;
@property (nonatomic, strong) DCTSectionHeaderViewModel *sectionHeaderViewModel;
@end

@interface DCTTableViewStructureModel : NSObject
@property (nonatomic, strong) NSMutableArray<DCTSectionStructureModel *> *sections;

@end

NS_ASSUME_NONNULL_END
