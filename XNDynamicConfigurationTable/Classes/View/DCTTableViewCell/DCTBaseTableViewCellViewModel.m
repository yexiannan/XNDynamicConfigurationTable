//
//  DCTBaseTableViewCellViewModel.m
//  Pods
//
//  Created by Luigi on 2019/12/13.
//

#import "DCTBaseTableViewCellViewModel.h"

@implementation DCTBaseTableViewCellViewModel
- (id)getValueWithKeyPath:(NSString *)keyPath DataDictionary:(NSDictionary *)dataDictionary UserInfoBlock:(nonnull id  _Nonnull (^)(NSString * _Nonnull))userInfoBlock {
    
    if (STRING_IsNull(keyPath)) {
        return [NSError errorWithDomain:[NSString stringWithFormat:@"获取数据异常,%@路径不存在",keyPath] code:0 userInfo:nil];
    }
    
    if ([keyPath hasPrefix:@"__"]) {
        NSString *correctKeyPath = [keyPath substringFromIndex:2];
        id result = [dataDictionary valueForKeyPath:correctKeyPath];
        
        if (result) {
            return result;
        }
        
    } else if ([keyPath hasPrefix:@"##"]) {
        
        if (userInfoBlock) {
            id result = userInfoBlock(keyPath);
            
            if (result && ![result isKindOfClass:[NSError class]]) {
                return result;
            }
            
        }
        
    } else {
        return keyPath;
    }
    return [NSError errorWithDomain:[NSString stringWithFormat:@"获取数据异常,%@路径不存在",keyPath] code:0 userInfo:nil];
}
@end
