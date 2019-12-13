//
//  DCTSectionHeaderViewModel.h
//  Pods
//
//  Created by Luigi on 2019/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCTSectionHeaderViewModel : NSObject
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, copy) UIView *(^sectionHeaderBlock)(NSInteger section, NSDictionary *sectionInfo);
@end

NS_ASSUME_NONNULL_END
