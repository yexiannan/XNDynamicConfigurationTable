//
//  CFYiNuoPreliminaryApplicationModel.h
//  UnionCarFinancial
//
//  Created by Luigi on 2019/11/26.
//  Copyright © 2019 XiaMen Micro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface Borrower : NSObject<NSCopying,NSMutableCopying>
@property (nonatomic, copy) NSString *workEducation;
@property (nonatomic, copy) NSString *livingTime;
@property (nonatomic, copy) NSString *livingRegion;
@property (nonatomic, copy) NSString *livingAddress;
@property (nonatomic, copy) NSString *workCompany;
@property (nonatomic, copy) NSString *monthIncome;
@property (nonatomic, copy) NSString *workYear;
@property (nonatomic, copy) NSString *workRegion;
@property (nonatomic, copy) NSString *workAddress;
@property (nonatomic, copy) NSString *workNature;
@property (nonatomic, copy) NSString *workJob;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *livingCondiction;
@property (nonatomic, copy) NSString *familyAnnualIncome;
@property (nonatomic, copy) NSString *workIndustry;
@property (nonatomic, copy) NSString *existingRepayment;
@property (nonatomic, copy) NSString *maritalStatus;
@property (nonatomic, copy) NSString *maritalSpouse;
@property (nonatomic, copy) NSString *maritalSpouseIdcard;
@property (nonatomic, copy) NSString *maritalSpousePhone;
@property (nonatomic, copy) NSString *maritalSpouseWorkAddress;
@property (nonatomic, copy) NSString *maritalSpouseValidityStart;
@property (nonatomic, copy) NSString *maritalSpouseValidityEnd;
@property (nonatomic, copy) NSString *maritalSpouseYearIncome;
@property (nonatomic, copy) NSString *maritalSpouseRegisterAddress;
@property (nonatomic, copy) NSString *maritalSpouseWorkEducation;
@property (nonatomic, copy) NSString *maritalSpouseHouseType;
@property (nonatomic, copy) NSString *maritalSpouseHouseNature;
@property (nonatomic, copy) NSString *maritalSpouseProfessionType;
@property (nonatomic, copy) NSString *maritalSpouseCompany;
@property (nonatomic, copy) NSString *bankAccount;
@property (nonatomic, copy) NSString *bankPhone;
@end

@interface CarInfo : NSObject<NSCopying,NSMutableCopying>
@property (nonatomic, copy) NSString *personProperty;
@end

@interface CFYiNuoPreliminaryApplicationModel : NSObject
@property (nonatomic, strong) Borrower *borrower;
@property (nonatomic, strong) CarInfo *carInfo;

@end

NS_ASSUME_NONNULL_END
