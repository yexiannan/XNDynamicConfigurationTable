//
//  UITextField+XNTextField.h
//  XNBaseUI
//
//  Created by Luigi on 2019/12/6.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (XNTextField)
#pragma mark -
- (UITextField *(^)(NSString *))textFieldText;
- (UITextField *(^)(NSAttributedString *))textFieldAttributedString;
- (UITextField *(^)(UIColor *))textFieldTextColor;
- (UITextField *(^)(NSString *))textFieldPlaceholder;
- (UITextField *(^)(UIColor *))textFieldBackgroundColor;
- (UITextField *(^)(UIFont *))textFieldFont;
- (UITextField *(^)(NSTextAlignment))textFieldTextAlignment;

@end

NS_ASSUME_NONNULL_END
