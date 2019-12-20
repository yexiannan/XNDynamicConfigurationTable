//
//  DCTContentTableViewCell.h
//  Pods-XNDynamicConfigurationTable_Example
//
//  Created by Luigi on 2019/11/23.
//

#import "DCTBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCTContentTableViewCell : DCTBaseTableViewCell
@property (nonatomic, strong)   UILabel     *cellTitleLabel;
@property (nonatomic, strong)   UILabel     *cellContentLabel;

@property(nonatomic)            NSTextAlignment     textAlignment;// default is NSTextAlignmentRight
@property (nonatomic, assign)   BOOL                hiddenIcon;//是否隐藏图片 default YES
@property (nonatomic, strong)   UIImageView         *icon;
@property (nonatomic, copy)     NSString            *unitString;//单位
@property (nonatomic, copy)     NSAttributedString  *attributedUnitString;//单位 富文本

+ (DCTContentTableViewCell *)newCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

//title副标题请使用__分割 content如需显示单位,请在调用此方法设置数据前先设置单位
- (void)setDataWithTitle:(NSString *)title Content:(NSString *)content;
//当不使用自适应行高时计算行高使用
- (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
