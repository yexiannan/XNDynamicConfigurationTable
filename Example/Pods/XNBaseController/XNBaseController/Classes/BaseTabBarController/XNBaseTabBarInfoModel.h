//
//  XNBaseTabBarInfoModel.h
//  XNBaseController
//
//  Created by Luigi on 2019/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XNBaseTabBarInfoModel : NSObject
@property (nonatomic, copy)     NSString    *title;
@property (nonatomic, strong)   UIFont      *titleFont;
@property (nonatomic, strong)   UIColor     *titleNormalColor;
@property (nonatomic, strong)   UIColor     *titleSelectedColor;

@property (nonatomic, strong)   UIImage *image;
@property (nonatomic, strong)   UIImage *selectedImage;

@property (nonatomic, strong)   UIViewController *vc;
@end

NS_ASSUME_NONNULL_END
