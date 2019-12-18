//
//  DCTPickTypeView.h
//  Pods
//
//  Created by Luigi on 2019/12/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DCTPickResultBlock)(NSString *title, NSString *value);


@interface DCTPickTypeView : UIView
@property (nonatomic, strong)   UIButton    *cancelButton;
@property (nonatomic, strong)   UIButton    *confirmButton;
@property (nonatomic, strong)   UILabel     *titleLabel;
@property (nonatomic, copy)     NSString    *selectedValue;//设置当前选中的value
@property (nonatomic, copy)     NSString    *selectedTitle;//设置当前选中的title
@property (nonatomic, copy)     DCTPickResultBlock block;//选择结果回调

/**
 * dataArray : [ {"title":"value"}, {"title":"value"} ]
 */
- (instancetype)initWithTitle:(NSString *)title DataArray:(NSArray<NSDictionary<NSString *, NSString *> *> *)dataArray;
- (void)pickViewShow;
@end

NS_ASSUME_NONNULL_END
