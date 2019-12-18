//
//  DCTSectionHeaderViewModel.h
//  Pods
//
//  Created by Luigi on 2019/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCTSectionHeaderViewModel : NSObject
@property (nonatomic, copy) UIView *(^sectionHeaderBlock)(NSInteger section, NSDictionary *sectionInfo);
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
