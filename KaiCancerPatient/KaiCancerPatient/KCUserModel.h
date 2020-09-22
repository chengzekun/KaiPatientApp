//
//  KCUserModel.h
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/8/16.
//  Copyright © 2020 CZK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCUserModel : NSObject
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *role;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *encodedAccessToken;
@property (nonatomic, copy)NSString *firstName;
@property (nonatomic, copy)NSString *lastName;
@property (nonatomic, copy)NSString *gender;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSMutableDictionary *patientExtra;
@end

NS_ASSUME_NONNULL_END
