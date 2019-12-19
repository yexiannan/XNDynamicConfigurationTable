//
//  DCTContentTableViewCell.m
//  Pods-XNDynamicConfigurationTable_Example
//
//  Created by Luigi on 2019/11/23.
//

#import "DCTContentTableViewCell.h"

static CGFloat const _titleLeftInset = 15.f; //标题距离单元格左边间距
static CGFloat const _titleAndContentInset = 15.f;//标题与文本间距
static CGFloat const _contentAndImageInset = 15.f;//文本与提示图片间距
static CGFloat const _imageInset = 15.f;//提示图片距离单元格右边间距

@implementation DCTContentTableViewCell

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
        self.hiddenIcon = YES;
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setDataAccess];
    [self layoutUI];
}

+ (DCTContentTableViewCell *)newCellWithTableView:(UITableView *)tableView IndexPath:(nonnull NSIndexPath *)indexPath {
    NSString * cellID = @"DCTContentTableViewCell";
    DCTContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[DCTContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - SetData
- (void)setDataAccess {
    self.icon.hidden = self.hiddenIcon;
}

- (void)setDataWithTitle:(NSString *)title Content:(NSString *)content{
    
    //设置title
    NSArray *titleArray = [title componentsSeparatedByString:@"__"];
    NSString *titleString = [titleArray firstObject];
    if (titleArray.count > 1) {
        titleString = [NSString stringWithFormat:@"%@ (%@)",[titleArray firstObject],[titleArray lastObject]];
    }
    NSMutableAttributedString *titleAttStr = [[NSMutableAttributedString alloc] initWithString:titleString];
    [titleAttStr addAttribute:NSForegroundColorAttributeName
                        value:self.cellTitleLabel.textColor
                        range:[titleString rangeOfString:titleString]];
    
    [titleAttStr addAttribute:NSFontAttributeName
                        value:self.cellTitleLabel.font
                        range:[titleString rangeOfString:titleString]];
    
    if (titleArray.count > 1) {
        [titleAttStr addAttribute:NSForegroundColorAttributeName
                            value:cHEXCOLOR(#FF4444)
                            range:[titleString rangeOfString:[titleArray lastObject]]];
    }
    self.cellTitleLabel.attributedText = titleAttStr;

    //设置content
    if (STRING_IsNull(self.attributedUnitString.string)) {
        self.cellContentLabel.text = STRING_IsNull(self.unitString) ? STRING_Safe(content) : [NSString stringWithFormat:@"%@%@", STRING_Safe(content), STRING_Safe(self.unitString)];
    } else {
        NSMutableAttributedString *contentAttString = [[NSMutableAttributedString alloc] initWithString:content];
        [contentAttString addAttribute:NSForegroundColorAttributeName
                                 value:self.cellContentLabel.textColor
                                 range:[content rangeOfString:content]];
        
        [contentAttString addAttribute:NSFontAttributeName
                                 value:self.cellContentLabel.font
                                 range:[content rangeOfString:content]];
        
        [contentAttString appendAttributedString:self.attributedUnitString];
        self.cellContentLabel.attributedText = contentAttString;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGFloat)cellHeight {
    CGFloat titleWidth = [NSString getSizeWithString:STRING_Safe(self.cellTitleLabel.attributedText.string) withFont:self.cellTitleLabel.font LimitWidth:SCREEN_WIDTH].width;
    
    CGFloat cellContentLabelWidth = SCREEN_WIDTH - (_titleLeftInset + titleWidth + (STRING_IsNull(self.cellTitleLabel.attributedText.string) ? 0 : _titleAndContentInset) + (self.hiddenIcon ? _imageInset : (_imageInset + 6 + _contentAndImageInset)));
    
    CGFloat height = [NSString getSizeWithString:self.cellContentLabel.attributedText.string withFont:self.cellContentLabel.font LimitWidth:cellContentLabelWidth].height;
    
    return height + 20 > 50 ? height + 20 : 50;
}

#pragma mark - LayoutUI
- (void)createUI {
    self.cellTitleLabel = [UILabel initWithText:@"" TextColor:COLOR_BLACK_4C Font:RFont(15) BackgroundColor:COLOR_WHITE TextAlignment:NSTextAlignmentLeft];
    
    self.cellContentLabel = [UILabel initWithText:@"" TextColor:COLOR_BLACK_2C Font:MFont(15) BackgroundColor:COLOR_WHITE TextAlignment:NSTextAlignmentRight];
    _cellContentLabel.numberOfLines = 0;
    
    self.icon = [[UIImageView alloc] initWithImage:IMG(icon_next_black_light)];
    
    [self.contentView addSubview:self.cellTitleLabel];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.cellContentLabel];
}

- (void)layoutUI {
    self.icon.hidden = self.hiddenIcon;
    
    CGFloat titleWidth = [NSString getSizeWithString:STRING_Safe(self.cellTitleLabel.attributedText.string) withFont:self.cellTitleLabel.font LimitWidth:SCREEN_WIDTH].width;
    CGFloat cellContentLabelWidth = SCREEN_WIDTH - (_titleLeftInset + titleWidth + (STRING_IsNull(self.cellTitleLabel.attributedText.string) ? 0 : _titleAndContentInset) + (self.hiddenIcon ? _imageInset : (_imageInset + 6 + _contentAndImageInset)));

    
    [self.cellTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.contentView);
        make.left.offset(_titleLeftInset);
        make.width.offset(titleWidth);
    }];
    
    [self.icon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-_imageInset);
        make.width.offset(6);
        make.height.offset(12);
    }];
    
    [self.cellContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellTitleLabel.mas_right).offset(STRING_IsNull(self.cellTitleLabel.attributedText.string) ? 0 : _titleAndContentInset);
        make.right.offset(self.hiddenIcon ? -_imageInset : -(_imageInset + 6 + _contentAndImageInset));
        //设置约束决定单元格高度
        CGFloat height = [NSString getSizeWithString:self.cellContentLabel.attributedText.string withFont:self.cellContentLabel.font LimitWidth:cellContentLabelWidth].height;
        make.top.bottom.equalTo(self.contentView);
        make.height.offset(height + 20 > 50 ? height + 20 : 50).priority(900);
    }];
}

@end
