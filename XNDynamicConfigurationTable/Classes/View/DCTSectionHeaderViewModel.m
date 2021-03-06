//
//  DCTSectionHeaderViewModel.m
//  Pods
//
//  Created by Luigi on 2019/12/13.
//

#import "DCTSectionHeaderViewModel.h"
#import "DCTConfigurationModel.h"
#import "DCTSectionHeaderView.h"

@implementation DCTSectionHeaderViewModel
- (instancetype)init {
    if (self = [super init]) {
        
        self.sectionHeaderBlock = ^UIView * _Nonnull(NSInteger section, NSDictionary * _Nonnull sectionInfo) {
            DCTSectionInfoModel *model = [DCTSectionInfoModel yy_modelWithJSON:sectionInfo];
            DCTSectionHeaderView *header = [[DCTSectionHeaderView alloc] init];
            [header setDataWithTitle:model.title];
            return header;
        };
        
    }
    return  self;
}

+ (CGFloat)cellHeight {
    return sectionHeaderHeight;
}
@end
