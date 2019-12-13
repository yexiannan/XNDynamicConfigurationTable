//
//  UITextField+XNTextField.m
//  XNBaseUI
//
//  Created by Luigi on 2019/12/6.
//

#import "UITextField+XNTextField.h"

@implementation UITextField (XNTextField)
#pragma mark -
- (UITextField *(^)(NSString *))textFieldText {
    @weakify(self)
       return ^(NSString *text) {
           @strongify(self)
           [self setText:text];
           return self;
       };
}

- (UITextField *(^)(NSAttributedString *))textFieldAttributedString {
    @weakify(self)
       return ^(NSAttributedString *attributedString) {
           @strongify(self)
           [self setAttributedText:attributedString];
           return self;
       };
}

- (UITextField *(^)(UIColor *))textFieldTextColor {
    @weakify(self)
       return ^(UIColor *textColor) {
           @strongify(self)
           [self setTextColor:textColor];
           return self;
       };
}

- (UITextField *(^)(NSString *))textFieldPlaceholder {
    @weakify(self)
       return ^(NSString *placeholder) {
           @strongify(self)
           [self setPlaceholder:placeholder];
           return self;
       };
}

- (UITextField *(^)(UIColor *))textFieldBackgroundColor {
    @weakify(self)
       return ^(UIColor *backgroundColor) {
           @strongify(self)
           [self setBackgroundColor:backgroundColor];
           return self;
       };
}

- (UITextField *(^)(UIFont *))textFieldFont {
    @weakify(self)
       return ^(UIFont *font) {
           @strongify(self)
           [self setFont:font];
           return self;
       };
}

- (UITextField *(^)(NSTextAlignment))textFieldTextAlignment {
    @weakify(self)
       return ^(NSTextAlignment textAlignment) {
           @strongify(self)
           [self setTextAlignment:textAlignment];
           return self;
       };
}
@end
