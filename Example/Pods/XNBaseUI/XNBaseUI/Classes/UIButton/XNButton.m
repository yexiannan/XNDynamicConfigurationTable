//
//  XNButton.m
//  XNUtils
//
//  Created by Luigi on 2019/7/2.
//
//此类的图片位置布局方法引用https://github.com/shunFSKi/FSCustomButtonDemo

#import "XNButton.h"
#import "FSCommenDefine.h"

@implementation XNButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    // iOS7以后的button，sizeToFit后默认会自带一个上下的contentInsets，为了保证按钮大小即为内容大小，这里直接去掉，改为一个最小的值。
    // 不能设为0，否则无效；也不能设置为小数点，否则无法像素对齐
    self.contentEdgeInsets = UIEdgeInsetsMake(1, 0, 1, 0);
    
    self.buttonImagePosition = UIRectEdgeLeft;//默认布局
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //size存在空的情况
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    //默认布局不用处理
    if (self.buttonImagePosition == UIRectEdgeLeft) {
        return;
    }
    //content的实际size
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets), CGRectGetHeight(self.bounds) - UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets));
    
    //垂直布局
    if (self.buttonImagePosition & UIRectEdgeTop
        || self.buttonImagePosition & UIRectEdgeBottom) {
        
        CGFloat imageLimitWidth = contentSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets);
        CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(imageLimitWidth, CGFLOAT_MAX)];// 假设图片高度必定完整显示
        CGRect imageFrame = CGRectMakeWithSize(imageSize);
        
        CGSize titleLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) - imageSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
        CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
        titleSize.height = fminf(titleSize.height, titleLimitSize.height);
        CGRect titleFrame = CGRectMakeWithSize(titleSize);
        //到这里image和title都是扣除了偏移量后的实际size，frame重置为x/y=0
        
        
        switch (self.contentHorizontalAlignment) {//重置X坐标
            case UIControlContentHorizontalAlignmentLeft:
                imageFrame = CGRectSetX(imageFrame, self.contentEdgeInsets.left + self.imageEdgeInsets.left);
                titleFrame = CGRectSetX(titleFrame, self.contentEdgeInsets.left + self.titleEdgeInsets.left);
                break;
            case UIControlContentHorizontalAlignmentCenter:
                imageFrame = CGRectSetX(imageFrame, self.contentEdgeInsets.left + self.imageEdgeInsets.left + CGFloatGetCenter(imageLimitWidth, imageSize.width));
                titleFrame = CGRectSetX(titleFrame, self.contentEdgeInsets.left + self.titleEdgeInsets.left + CGFloatGetCenter(titleLimitSize.width, titleSize.width));
                break;
            case UIControlContentHorizontalAlignmentRight:
                imageFrame = CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.imageEdgeInsets.right - imageSize.width);
                titleFrame = CGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.titleEdgeInsets.right - titleSize.width);
                break;
            case UIControlContentHorizontalAlignmentFill://此时要铺满button，所以要重置width
                imageFrame = CGRectSetX(imageFrame, self.contentEdgeInsets.left + self.imageEdgeInsets.left);
                imageFrame = CGRectSetWidth(imageFrame, imageLimitWidth);
                titleFrame = CGRectSetX(titleFrame, self.contentEdgeInsets.left + self.titleEdgeInsets.left);
                titleFrame = CGRectSetWidth(titleFrame, titleLimitSize.width);
                break;
            case UIControlContentHorizontalAlignmentLeading:
                
                break;
            case UIControlContentHorizontalAlignmentTrailing:
                
                break;
        }
        
        if (self.buttonImagePosition & UIRectEdgeTop) {//重置Y坐标
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    imageFrame = CGRectSetY(imageFrame, self.contentEdgeInsets.top + self.imageEdgeInsets.top);
                    titleFrame = CGRectSetY(titleFrame, CGRectGetMaxY(imageFrame) + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top);
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = CGRectGetHeight(imageFrame) + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) + CGRectGetHeight(titleFrame) + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets);
                    CGFloat minY = CGFloatGetCenter(contentSize.height, contentHeight) + self.contentEdgeInsets.top;
                    imageFrame = CGRectSetY(imageFrame, minY + self.imageEdgeInsets.top);
                    titleFrame = CGRectSetY(titleFrame, CGRectGetMaxY(imageFrame) + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top);
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    titleFrame = CGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame));
                    imageFrame = CGRectSetY(imageFrame, CGRectGetMinY(titleFrame) - self.titleEdgeInsets.top - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame));
                    break;
                case UIControlContentVerticalAlignmentFill:
                    // 图片按自身大小显示，剩余空间由标题占满
                    imageFrame = CGRectSetY(imageFrame, self.contentEdgeInsets.top + self.imageEdgeInsets.top);
                    titleFrame = CGRectSetY(titleFrame, CGRectGetMaxY(imageFrame) + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top);
                    titleFrame = CGRectSetHeight(titleFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame));
                    break;
            }
        } else {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    titleFrame = CGRectSetY(titleFrame, self.contentEdgeInsets.top + self.titleEdgeInsets.top);
                    imageFrame = CGRectSetY(imageFrame, CGRectGetMaxY(titleFrame) + self.titleEdgeInsets.bottom + self.imageEdgeInsets.top);
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = CGRectGetHeight(titleFrame) + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets) + CGRectGetHeight(imageFrame) + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets);
                    CGFloat minY = CGFloatGetCenter(contentSize.height, contentHeight) + self.contentEdgeInsets.top;
                    titleFrame = CGRectSetY(titleFrame, minY + self.titleEdgeInsets.top);
                    imageFrame = CGRectSetY(imageFrame, CGRectGetMaxY(titleFrame) + self.titleEdgeInsets.bottom + self.imageEdgeInsets.top);
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    imageFrame = CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame));
                    titleFrame = CGRectSetY(titleFrame, CGRectGetMinY(imageFrame) - self.imageEdgeInsets.top - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame));
                    
                    break;
                case UIControlContentVerticalAlignmentFill:
                    // 图片按自身大小显示，剩余空间由标题占满
                    imageFrame = CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame));
                    titleFrame = CGRectSetY(titleFrame, self.contentEdgeInsets.top + self.titleEdgeInsets.top);
                    titleFrame = CGRectSetHeight(titleFrame, CGRectGetMinY(imageFrame) - self.imageEdgeInsets.top - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame));
                    break;
            }
        }
        
        self.imageView.frame = CGRectFlatted(imageFrame);
        self.titleLabel.frame = CGRectFlatted(titleFrame);
        
    } else if (self.buttonImagePosition & UIRectEdgeRight) {//水平布局
        
        CGFloat imageLimitHeight = contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets);
        CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, imageLimitHeight)];// 假设图片宽度必定完整显示，高度不超过按钮内容
        CGRect imageFrame = CGRectMakeWithSize(imageSize);
        
        CGSize titleLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) - CGRectGetWidth(imageFrame) - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), contentSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
        CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
        titleSize.height = fminf(titleSize.height, titleLimitSize.height);
        CGRect titleFrame = CGRectMakeWithSize(titleSize);
        
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentLeft:
                titleFrame = CGRectSetX(titleFrame, self.contentEdgeInsets.left + self.titleEdgeInsets.left);
                imageFrame = CGRectSetX(imageFrame, CGRectGetMaxX(titleFrame) + self.titleEdgeInsets.right + self.imageEdgeInsets.left);
                break;
            case UIControlContentHorizontalAlignmentCenter: {
                CGFloat contentWidth = CGRectGetWidth(titleFrame) + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) + CGRectGetWidth(imageFrame) + UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets);
                CGFloat minX = self.contentEdgeInsets.left + CGFloatGetCenter(contentSize.width, contentWidth);
                titleFrame = CGRectSetX(titleFrame, minX + self.titleEdgeInsets.left);
                imageFrame = CGRectSetX(imageFrame, CGRectGetMaxX(titleFrame) + self.titleEdgeInsets.right + self.imageEdgeInsets.left);
            }
                break;
            case UIControlContentHorizontalAlignmentRight:
                imageFrame = CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame));
                titleFrame = CGRectSetX(titleFrame, CGRectGetMinX(imageFrame) - self.imageEdgeInsets.left - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame));
                break;
            case UIControlContentHorizontalAlignmentFill:
                // 图片按自身大小显示，剩余空间由标题占满
                imageFrame = CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame));
                titleFrame = CGRectSetX(titleFrame, self.contentEdgeInsets.left + self.titleEdgeInsets.left);
                titleFrame = CGRectSetWidth(titleFrame, CGRectGetMinX(imageFrame) - self.imageEdgeInsets.left - self.titleEdgeInsets.right - CGRectGetMinX(titleFrame));
                break;
            case UIControlContentHorizontalAlignmentLeading:
                
                break;
            case UIControlContentHorizontalAlignmentTrailing:
                
                break;
        }
        
        switch (self.contentVerticalAlignment) {
            case UIControlContentVerticalAlignmentTop:
                titleFrame = CGRectSetY(titleFrame, self.contentEdgeInsets.top + self.titleEdgeInsets.top);
                imageFrame = CGRectSetY(imageFrame, self.contentEdgeInsets.top + self.imageEdgeInsets.top);
                break;
            case UIControlContentVerticalAlignmentCenter:
                titleFrame = CGRectSetY(titleFrame, self.contentEdgeInsets.top + self.titleEdgeInsets.top + CGFloatGetCenter(contentSize.height, CGRectGetHeight(titleFrame) + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets)));
                imageFrame = CGRectSetY(imageFrame, self.contentEdgeInsets.top + self.imageEdgeInsets.top + CGFloatGetCenter(contentSize.height, CGRectGetHeight(imageFrame) + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets)));
                break;
            case UIControlContentVerticalAlignmentBottom:
                titleFrame = CGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame));
                imageFrame = CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame));
                break;
            case UIControlContentVerticalAlignmentFill:
                titleFrame = CGRectSetY(titleFrame, self.contentEdgeInsets.top + self.titleEdgeInsets.top);
                titleFrame = CGRectSetHeight(titleFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame));
                imageFrame = CGRectSetY(imageFrame, self.contentEdgeInsets.top + self.imageEdgeInsets.top);
                imageFrame = CGRectSetHeight(imageFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetMinY(imageFrame));
                break;
        }
        
        self.imageView.frame = CGRectFlatted(imageFrame);
        self.titleLabel.frame = CGRectFlatted(titleFrame);
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    // 如果调用 sizeToFit，那么传进来的 size 就是当前按钮的 size，此时的计算不要去限制宽高
    if (CGSizeEqualToSize(self.bounds.size, size)) {
        size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    
    CGSize resultSize = CGSizeZero;
    CGSize contentLimitSize = CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets), size.height - UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets));
    switch (self.buttonImagePosition) {
        case UIRectEdgeTop:
        case UIRectEdgeBottom: {
            // 图片和文字上下排版时，宽度以文字或图片的最大宽度为最终宽度
            CGFloat imageLimitWidth = contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets);
            CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(imageLimitWidth, CGFLOAT_MAX)];// 假设图片高度必定完整显示
            
            CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), contentLimitSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) - imageSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
            CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
            titleSize.height = fminf(titleSize.height, titleLimitSize.height);
            
            resultSize.width = UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets);
            resultSize.width += fmaxf(UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets) + imageSize.width, UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) + titleSize.width);
            resultSize.height = UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets) + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) + imageSize.height + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets) + titleSize.height;
        }
            break;
            
        case UIRectEdgeLeft:
        case UIRectEdgeRight: {
            if (self.buttonImagePosition & UIRectEdgeLeft && self.titleLabel.numberOfLines == 1) {
                
                resultSize = [super sizeThatFits:size];
                
            } else {
                // 图片和文字水平排版时，高度以文字或图片的最大高度为最终高度
                
                CGFloat imageLimitHeight = contentLimitSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets);
                CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, imageLimitHeight)];// 假设图片宽度必定完整显示，高度不超过按钮内容
                
                CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) - imageSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), contentLimitSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
                CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
                titleSize.height = fminf(titleSize.height, titleLimitSize.height);
                
                resultSize.width = UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets) + UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets) + imageSize.width + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) + titleSize.width;
                resultSize.height = UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets);
                resultSize.height += fmaxf(UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) + imageSize.height, UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets) + titleSize.height);
            }
        }
            break;
        case UIRectEdgeNone:
            break;
        case UIRectEdgeAll:
            break;
    }
    return resultSize;
}

- (void)setButtonImagePosition:(UIRectEdge)buttonImagePosition
{
    _buttonImagePosition = buttonImagePosition;
    [self setNeedsLayout];
}

//快速创建按钮
+ (UIButton *)newButtonWithBackgroundImage:(nullable UIImage *)image TitleNormalColor:(UIColor *)titleNormalColor Font:(UIFont *)font TitleNormal:(NSString *)titleNormal Taget:(nullable id)taget Action:(nullable SEL)action{
    XNButton *button = [XNButton new];
    [image isKindOfClass:[UIImage class]] ? [button setBackgroundImage:image forState:UIControlStateNormal] : nil;
    [button.titleLabel setFont:font];
    [button setTitleColor:titleNormalColor forState:UIControlStateNormal];
    [button setTitle:titleNormal forState:UIControlStateNormal];
    
    if (taget) {
        if (action) {
            [button addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return button;
}

#pragma mark - 链式编程
- (XNButton * _Nonnull (^)(NSString * _Nonnull, UIControlState))title {
    @weakify(self)
    return ^(NSString *title, UIControlState state) {
        @strongify(self)
        [self setTitle:title forState:state];
        return self;
    };
}

- (XNButton * _Nonnull (^)(UIColor * _Nonnull, UIControlState))titleColor {
    @weakify(self)
    return ^(UIColor *titleColor, UIControlState state) {
        @strongify(self)
        [self setTitleColor:titleColor forState:state];
        return self;
    };
}

- (XNButton *(^)(NSAttributedString *, UIControlState))attributedString {
    @weakify(self)
    return ^(NSAttributedString *attributedString, UIControlState state) {
        @strongify(self)
        [self setAttributedTitle:attributedString forState:state];
        return self;
    };
}

- (XNButton * _Nonnull (^)(UIFont * _Nonnull))titleFont {
    @weakify(self)
    return ^(UIFont *font) {
        @strongify(self)
        self.titleLabel.font = font;
        return self;
    };
}

- (XNButton * _Nonnull (^)(UIImage * _Nonnull, UIControlState))image {
    @weakify(self)
    return ^(UIImage *image, UIControlState state) {
        @strongify(self)
        [self setImage:image forState:state];
        return self;
    };
}

- (XNButton * _Nonnull (^)(UIImage * _Nonnull, UIControlState))backgroundImage {
    @weakify(self)
    return ^(UIImage *backgroundImage, UIControlState state) {
        @strongify(self)
        [self setBackgroundImage:backgroundImage forState:state];
        return self;
    };
}

- (XNButton * _Nonnull (^)(id _Nonnull, SEL _Nonnull, UIControlEvents))addTargetAction {
    @weakify(self)
    return ^(id target, SEL sel, UIControlEvents state) {
        @strongify(self)
        [self addTarget:target action:sel forControlEvents:state];
        return self;
    };
}

- (XNButton * _Nonnull (^)(UIRectEdge))imagePosition {
    @weakify(self)
       return ^(UIRectEdge edg) {
           @strongify(self)
           self.buttonImagePosition = edg;
           return self;
       };
}



@end


@implementation UIButton (XNButton)

//快速创建按钮
+ (UIButton *)newButtonWithBackgroundImage:(nullable UIImage *)image TitleNormalColor:(UIColor *)titleNormalColor Font:(UIFont *)font TitleNormal:(NSString *)titleNormal Taget:(nullable id)taget Action:(nullable SEL)action{
    UIButton *button = [UIButton new];
    [image isKindOfClass:[UIImage class]] ? [button setBackgroundImage:image forState:UIControlStateNormal] : nil;
    [button.titleLabel setFont:font];
    [button setTitleColor:titleNormalColor forState:UIControlStateNormal];
    [button setTitle:titleNormal forState:UIControlStateNormal];
    
    if (taget) {
        if (action) {
            [button addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return button;
}

- (UIButton * _Nonnull (^)(NSString * _Nonnull, UIControlState))title {
    @weakify(self)
    return ^(NSString *title, UIControlState state) {
        @strongify(self)
        [self setTitle:title forState:state];
        return self;
    };
}

- (UIButton * _Nonnull (^)(UIColor * _Nonnull, UIControlState))titleColor {
    @weakify(self)
    return ^(UIColor *titleColor, UIControlState state) {
        @strongify(self)
        [self setTitleColor:titleColor forState:state];
        return self;
    };
}

- (UIButton *(^)(NSAttributedString *, UIControlState))attributedString {
    @weakify(self)
    return ^(NSAttributedString *attributedString, UIControlState state) {
        @strongify(self)
        [self setAttributedTitle:attributedString forState:state];
        return self;
    };
}

- (UIButton * _Nonnull (^)(UIFont * _Nonnull))titleFont {
    @weakify(self)
    return ^(UIFont *font) {
        @strongify(self)
        self.titleLabel.font = font;
        return self;
    };
}

- (UIButton * _Nonnull (^)(UIImage * _Nonnull, UIControlState))image {
    @weakify(self)
    return ^(UIImage *image, UIControlState state) {
        @strongify(self)
        [self setImage:image forState:state];
        return self;
    };
}

- (UIButton * _Nonnull (^)(UIImage * _Nonnull, UIControlState))backgroundImage {
    @weakify(self)
    return ^(UIImage *backgroundImage, UIControlState state) {
        @strongify(self)
        [self setBackgroundImage:backgroundImage forState:state];
        return self;
    };
}

- (UIButton * _Nonnull (^)(id _Nonnull, SEL _Nonnull, UIControlEvents))addTargetAction {
    @weakify(self)
    return ^(id target, SEL sel, UIControlEvents state) {
        @strongify(self)
        [self addTarget:target action:sel forControlEvents:state];
        return self;
    };
}

@end
