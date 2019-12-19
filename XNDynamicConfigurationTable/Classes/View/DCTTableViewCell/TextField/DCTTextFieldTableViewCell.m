//
//  DCTTextFieldTableViewCell.m
//  Masonry
//
//  Created by Luigi on 2019/11/23.
//

#import "DCTTextFieldTableViewCell.h"

@implementation DCTTextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textAlignment = NSTextAlignmentRight;
        self.textType = DCTTextFieldCellType_Normal;
        self.regularExpressions = [NSArray new];
        
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setDataAccess];
    [self layoutUI];
}

- (void)setDataAccess {
    _cellTextField.textAlignment = self.textAlignment;
    
    //设置键盘类型
    switch (self.textType) {
        case DCTTextFieldCellType_Normal:  [_cellTextField setKeyboardType:UIKeyboardTypeDefault]; break;
        case DCTTextFieldCellType_Phone:   [_cellTextField setKeyboardType:UIKeyboardTypePhonePad]; break;
        case DCTTextFieldCellType_Integer: [_cellTextField setKeyboardType:UIKeyboardTypeNumberPad]; break;
        case DCTTextFieldCellType_Decimal: [_cellTextField setKeyboardType:UIKeyboardTypeDecimalPad]; break;
        case DCTTextFieldCellType_URL:     [_cellTextField setKeyboardType:UIKeyboardTypeURL]; break;
        case DCTTextFieldCellType_NumberAndProduct: [_cellTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation]; break;
        default:  break;
    }
    
    //设置单位
    [self.cellTextField setRightViewMode:UITextFieldViewModeNever];
    
    if (!STRING_IsNull(self.attributedUnitString.string) || !STRING_IsNull(self.unitString)) {
        UILabel *unitLabel = [UILabel initWithText:STRING_Safe(self.unitString)
                                         TextColor:self.cellTextField.textColor
                                              Font:self.cellTextField.font
                                   BackgroundColor:COLOR_WHITE
                                     TextAlignment:NSTextAlignmentRight];
        
        if (!STRING_IsNull(self.attributedUnitString.string)) {
            unitLabel.attributedText = self.attributedUnitString;
        }
        
        [unitLabel sizeToFit];
        unitLabel.frame = CGRectMake(0, 0, unitLabel.width + 20, 20);
        [self.cellTextField setRightView:unitLabel];
        [self.cellTextField setRightViewMode:UITextFieldViewModeAlways];
    }

}

+ (DCTTextFieldTableViewCell *)newCellWithTableView:(UITableView *)tableView IndexPath:(nonnull NSIndexPath *)indexPath {
    NSString * cellID = @"DCTTextFieldTableViewCell";
    DCTTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[DCTTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithTitle:(NSString *)title Content:(NSString *)content Placeholder:(NSString *)placeholder {
    NSArray *titleArray = [title componentsSeparatedByString:@"__"];
    NSString *string = [titleArray firstObject];
    if (titleArray.count > 1) {
        string = [NSString stringWithFormat:@"%@ (%@)",[titleArray firstObject],[titleArray lastObject]];
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:COLOR_BLACK_4C
                   range:[string rangeOfString:string]];
    
    [attStr addAttribute:NSFontAttributeName
                   value:RFont(15)
                   range:[string rangeOfString:string]];
    
    if (titleArray.count > 1) {
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:cHEXCOLOR(#FF4444)
                       range:[string rangeOfString:[titleArray lastObject]]];
    }
    
    self.cellTitleLabel.attributedText = attStr;
    [self.cellTitleLabel sizeToFit];
    self.cellTextField.text = STRING_Safe(content);
    self.cellTextField.placeholder = STRING_Safe(placeholder);
}

- (void)createUI {
    self.contentView.backgroundColor = COLOR_WHITE;

    self.cellTitleLabel = [UILabel initWithText:@"" TextColor:COLOR_BLACK_4C Font:RFont(15) BackgroundColor:COLOR_WHITE TextAlignment:NSTextAlignmentLeft];
    
    self.cellTextField = [[UITextField alloc] init];
    _cellTextField.delegate = self;
    _cellTextField.backgroundColor = COLOR_WHITE;
    _cellTextField.font = MFont(15);
    _cellTextField.textColor = COLOR_BLACK_4C;
    _cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)layoutUI {
    [self.contentView addSubview:self.cellTitleLabel];
    [self.contentView addSubview:self.cellTextField];
    
    CGFloat width = self.cellTitleLabel.width + 5;
    [self.cellTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15.f);
        make.width.offset(width);
        //设置约束决定单元格高度
        make.top.bottom.equalTo(self.contentView);
        make.height.offset(50.f).priority(900);
    }];

    [self.cellTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.contentView);
        make.left.equalTo(self.cellTitleLabel.mas_right).offset(15);
        make.right.offset(-15);
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.block) {
        self.block(STRING_Safe(textField.text));
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //对输入的文字做正则判断
    NSString * predString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSMutableArray *regularArray = [[NSMutableArray alloc] initWithCapacity:self.regularExpressions.count];
    [self.regularExpressions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",obj];
        [regularArray addObject:pred];
    }];
    
    NSCompoundPredicate *andMatchPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:regularArray];
    if ([andMatchPredicate evaluateWithObject:predString]  || [string isEqualToString:@""]) {
        return YES;
    }

    return NO;
}

@end
