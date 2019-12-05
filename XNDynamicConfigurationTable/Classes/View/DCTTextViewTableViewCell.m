//
//  DCTTextViewTableViewCell.m
//  Masonry
//
//  Created by Luigi on 2019/11/23.
//

#import "DCTTextViewTableViewCell.h"

@implementation DCTTextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        [self setDataAccess];
        [self layoutUI];
    }
}

+ (DCTTextViewTableViewCell *)newCellWithTableView:(UITableView *)tableView IndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString * cellID = @"DCTTextViewTableViewCell";
    DCTTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[DCTTextViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - SetData
- (void)setDataWithTitle:(NSString *)title Text:(NSString *)text Placeholder:(NSString *)placeholder CanEdit:(BOOL)canEdit{
    self.titleLabel.text = STRING_Safe(title);
    self.cellTextView.attributedText = [self getAttributeStringWithString:STRING_Safe(text) Font:self.cellTextView.font LineSpacing:4];
    self.placeholderLabel.text = STRING_Safe(placeholder);
    self.cellTextView.editable = canEdit;
}

- (void)setDataAccess {

}

#pragma mark - LayoutUI
- (void)createUI {
    self.contentView.backgroundColor = COLOR_WHITE;
    
    self.titleLabel = [UILabel initWithText:@"" TextColor:COLOR_BLACK_2C Font:MFont(14) BackgroundColor:COLOR_WHITE TextAlignment:NSTextAlignmentLeft];
    
    self.cellTextView = [UITextView new];
    self.cellTextView.backgroundColor = COLOR_GARY_BG;
    self.cellTextView.textColor = COLOR_BLACK_2C;
    self.cellTextView.font = RFont(14);
    self.cellTextView.delegate = self;
    
    // _placeholderLabel
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.text = @"请输入";
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.textColor = COLOR_PLACEHOLDER;
    [self.placeholderLabel sizeToFit];
    self.placeholderLabel.font = self.cellTextView.font;
    [self.cellTextView addSubview:self.placeholderLabel];
    [self.cellTextView setValue:self.placeholderLabel forKey:@"_placeholderLabel"];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.cellTextView];
}

- (void)layoutUI {
    
    if (STRING_IsNull(self.titleLabel.text)) { self.titleLabel.hidden = YES; }
                                        else { self.titleLabel.hidden = NO; }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 1)];
    label.numberOfLines = 0;
    label.attributedText = [self getAttributeStringWithString:self.cellTextView.text Font:self.cellTextView.font LineSpacing:4];
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    CGFloat height = size.height + 10*2;
    height = height < 100 ? 100 : height;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        //设置约束决定单元格高度
        make.top.offset(10);
        make.bottom.offset(-height - (STRING_IsNull(self.titleLabel.text) ? 10 : 20));
        make.height.offset(STRING_IsNull(self.titleLabel.text) ? 0 : 20).priority(900);
    }];

    [self.cellTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-10);
        make.height.offset(height);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(STRING_IsNull(self.titleLabel.text) ? 0 : 10);
    }];
}

- (NSAttributedString *)getAttributeStringWithString:(NSString *)string Font:(UIFont *)font LineSpacing:(CGFloat)lineSpacing{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    return attributeString;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.block) {
        self.block(STRING_Safe(textView.text));
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //对输入的文字做正则判断
    NSString * predString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSMutableArray *regularArray = [[NSMutableArray alloc] initWithCapacity:self.regularExpressions.count];
    [self.regularExpressions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",obj];
        [regularArray addObject:pred];
    }];
    
    NSCompoundPredicate *andMatchPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:regularArray];
    if ([andMatchPredicate evaluateWithObject:predString]  || [text isEqualToString:@""]) {
        return YES;
    }

    return NO;
}

@end
