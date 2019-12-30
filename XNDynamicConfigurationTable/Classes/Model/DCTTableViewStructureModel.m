//
//  DCTTableViewStructureModel.m
//  Pods
//
//  Created by Luigi on 2019/12/26.
//

#import "DCTTableViewStructureModel.h"

@implementation DCTCellStructureModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cellViewModel":[DCTBaseTableViewCellViewModel class]};
}
@end

@implementation DCTSectionStructureModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.cells = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cells":[DCTCellStructureModel class], @"sectionHeaderViewModel":[DCTSectionHeaderViewModel class]};
}
@end

@implementation DCTTableViewStructureModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.sections = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"sections":[DCTTableViewStructureModel class]};
}
@end
