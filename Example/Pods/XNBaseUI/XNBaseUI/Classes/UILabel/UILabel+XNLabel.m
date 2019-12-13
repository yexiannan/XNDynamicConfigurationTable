//
//  UILabel+XNLabel.m
//  XNUtils_Example
//
//  Created by Luigi on 2019/6/13.
//  Copyright © 2019 Luigi. All rights reserved.
//

#import "UILabel+XNLabel.h"

@implementation UILabel (XNLabel)
+ (UILabel *)initWithBackgroundColor:(UIColor *)backgroundColor TextAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = backgroundColor;
    label.textAlignment = textAlignment;
    return label;
}

+ (UILabel *)initWithText:(NSString *)text TextColor:(UIColor *)textColor Font:(UIFont *)font BackgroundColor:(UIColor *)backgroundColor TextAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.backgroundColor = backgroundColor;
    label.textAlignment = textAlignment;
    return label;
}

#pragma mark -
- (UILabel *(^)(NSString *))labelText {
    @weakify(self)
    return ^(NSString *text) {
        @strongify(self)
        [self setText:text];
        return self;
    };
}

- (UILabel *(^)(UIColor *))labelTextColor {
    @weakify(self)
    return ^(UIColor *textColor) {
        @strongify(self)
        [self setTextColor:textColor];
        return self;
    };
}

- (UILabel *(^)(UIColor *))labelBackgroundColor {
    @weakify(self)
    return ^(UIColor *backgroundColor) {
        @strongify(self)
        [self setBackgroundColor:backgroundColor];
        return self;
    };
}

- (UILabel *(^)(NSTextAlignment))labelTextAlignment {
    @weakify(self)
    return ^(NSTextAlignment textAlignment) {
        @strongify(self)
        [self setTextAlignment:textAlignment];
        return self;
    };
}

- (UILabel *(^)(UIFont *))labelFont {
    @weakify(self)
    return ^(UIFont *font) {
        @strongify(self)
        [self setFont:font];
        return self;
    };
}

- (UILabel * _Nonnull (^)(NSInteger))labelNumberOfLines {
    @weakify(self)
    return ^(NSInteger numberOfLines) {
        @strongify(self)
        [self setNumberOfLines:numberOfLines];
        return self;
    };
}

@end
