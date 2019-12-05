//
//  DCTTextFieldTableViewCell.h
//  Masonry
//
//  Created by Luigi on 2019/11/23.
//

#import "DCTBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DCTTextFieldCellType) {
    DCTTextFieldCellType_Normal            = 1,
    DCTTextFieldCellType_Phone             = 2,//电话
    DCTTextFieldCellType_Integer           = 3,//整数
    DCTTextFieldCellType_Decimal           = 4,//小数
    DCTTextFieldCellType_URL               = 5,//URL
    DCTTextFieldCellType_NumberAndProduct  = 6,//输入数字与字母
};

typedef void(^finishEditBlock)(NSString *text);

@interface DCTTextFieldTableViewCell : DCTBaseTableViewCell<UITextFieldDelegate>
@property (nonatomic, strong)   UILabel              *cellTitleLabel;
@property (nonatomic, strong)   UITextField          *cellTextField;

@property (nonatomic)           NSTextAlignment      textAlignment;        // default is NSTextAlignmentRight
@property (nonatomic, assign)   DCTTextFieldCellType textType;//文本类型 default is TextFieldCellType_Normal
@property (nonatomic, strong)   NSArray<NSString *>  *regularExpressions;//正则表达式数组
@property (nonatomic, copy)     NSString             *unitString;//单位
@property (nonatomic, copy)     NSAttributedString   *attributedUnitString;//单位 富文本

@property (nonatomic, copy)     finishEditBlock      block;//结束编辑

+ (DCTTextFieldTableViewCell *)newCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

//title副标题请使用__分割
- (void)setDataWithTitle:(NSString *)title Content:(NSString *)content Placeholder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
