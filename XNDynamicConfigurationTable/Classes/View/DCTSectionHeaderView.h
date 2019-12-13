//
//  DCTSectionHeaderView.h
//  Pods
//
//  Created by Luigi on 2019/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat const sectionHeaderHeight = 43;

@interface DCTSectionHeaderView : UIView
- (void)setDataWithTitle:(NSString *)title;
- (void)setDataWithAttributeTitle:(NSAttributedString *)attributeTitle;
@end

NS_ASSUME_NONNULL_END
