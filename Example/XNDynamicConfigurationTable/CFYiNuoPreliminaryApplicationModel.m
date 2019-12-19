//
//  CFYiNuoPreliminaryApplicationModel.m
//  UnionCarFinancial
//
//  Created by Luigi on 2019/11/26.
//  Copyright © 2019 XiaMen Micro. All rights reserved.
//

#import "CFYiNuoPreliminaryApplicationModel.h"
#import <objc/runtime.h>

@implementation Borrower
- (instancetype)init{
    self = [super init];
    if (self) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i<count; i++) {
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:name];
            [self setValue:@""  forKey:propertyName];
        }
        free(properties);
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    Borrower *model = [[Borrower allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:[value copy] forKey:propertyName];
        }
    }
    free(properties);
    return model;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    Borrower *model = [[Borrower allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:[value copy] forKey:propertyName];
        }
    }
    free(properties);
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end

@implementation CarInfo
- (instancetype)init{
    self = [super init];
    if (self) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i<count; i++) {
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:name];
            [self setValue:@""  forKey:propertyName];
        }
        free(properties);
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    CarInfo *model = [[CarInfo allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:[value copy] forKey:propertyName];
        }
    }
    free(properties);
    return model;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    CarInfo *model = [[CarInfo allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:[value copy] forKey:propertyName];
        }
    }
    free(properties);
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}
@end


@interface CFYiNuoPreliminaryApplicationModel (){
    NSArray<NSDictionary *> *configurationList;
}
@end

@implementation CFYiNuoPreliminaryApplicationModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"borrower":[Borrower class],
             @"carInfo":[CarInfo class]};
}


- (instancetype)init{
    self = [super init];
    if (self) {
        self.borrower = [Borrower new];
        self.carInfo = [CarInfo new];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    CFYiNuoPreliminaryApplicationModel *model = [[CFYiNuoPreliminaryApplicationModel allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:[value copy] forKey:propertyName];
        }
    }
    free(properties);
    return model;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    CFYiNuoPreliminaryApplicationModel *model = [[CFYiNuoPreliminaryApplicationModel allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:[value copy] forKey:propertyName];
        }
    }
    free(properties);
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}
@end
