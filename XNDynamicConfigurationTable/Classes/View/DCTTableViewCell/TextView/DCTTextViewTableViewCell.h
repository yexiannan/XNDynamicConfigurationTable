//
//  DCTTextViewTableViewCell.h
//  Masonry
//
//  Created by Luigi on 2019/11/23.
//

#import "DCTBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^finishEditBlock)(NSString *text);

@interface DCTTextViewTableViewCell : DCTBaseTableViewCell<UITextViewDelegate>
@property (nonatomic, strong)   UILabel             *titleLabel;
@property (nonatomic, strong)   UITextView          *cellTextView;
@property (nonatomic, strong)   UILabel             *placeholderLabel;
@property (nonatomic, copy)     finishEditBlock     block;//结束编辑
@property (nonatomic, strong)   NSArray<NSString *> *regularExpressions;//正则表达式数组

//字数限制暂未实现，待讨论需求与字数显示位置
@property (nonatomic, assign) NSInteger maxNum;//最大字数
@property (nonatomic, assign) NSInteger minNum;//最小字数

+ (DCTTextViewTableViewCell *)newCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;
- (void)setDataWithTitle:(nullable NSString *)title Text:(nullable NSString *)text Placeholder:(nullable NSString *)placeholder CanEdit:(BOOL)canEdit;
@end

NS_ASSUME_NONNULL_END
