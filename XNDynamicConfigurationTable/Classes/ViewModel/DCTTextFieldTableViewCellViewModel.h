//
//  DCTTextFieldTableViewCellViewModel.h
//  Pods
//
//  Created by Luigi on 2019/12/16.
//

#import "DCTBaseTableViewCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^finishEditBlock)(NSString *text);

@interface DCTTextFieldTableViewCellViewModel : DCTBaseTableViewCellViewModel

@end

NS_ASSUME_NONNULL_END
