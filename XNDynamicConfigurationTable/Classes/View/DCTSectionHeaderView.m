//
//  DCTSectionHeaderView.m
//  Pods
//
//  Created by Luigi on 2019/12/13.
//

#import "DCTSectionHeaderView.h"

@interface DCTSectionHeaderView ()
@property (nonatomic, strong) UILabel *headerTitleLabel;

@end

@implementation DCTSectionHeaderView
- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)setDataWithTitle:(NSString *)title{
    self.headerTitleLabel.text = STRING_Safe(title);
}

- (void)setDataWithAttributeTitle:(NSAttributedString *)attributeTitle{
    self.headerTitleLabel.attributedText = attributeTitle;
}

- (void)createUI{
    self.backgroundColor = COLOR_GARY_BG;
    
    self.headerTitleLabel = [UILabel initWithText:@"" TextColor:COLOR_BLACK_2C Font:MFont(15) BackgroundColor:COLOR_GARY_BG TextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.headerTitleLabel];
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.height.equalTo(self);
        make.right.offset(-15);
    }];
}


@end
