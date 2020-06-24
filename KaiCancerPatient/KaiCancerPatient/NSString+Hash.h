//
//  NSString+Hash.h
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/22.
//  Copyright © 2020 CZK. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger ,HashType){
    HashTypeMD5 = 0,
    HashTypeSHA1,
};

@interface NSString(Hash)

/**
 *  MD5值函数－无嵌套
 *
 *  @return MD5字符串
 */
- (NSString *)MD5Value;

/**
 *  Hash值函数－无嵌套
 *
 *  @param type   Hash方式
 *
 *  @return Hash值
 */
- (NSString *)hashValueWithType:(HashType)type;

/**
 *  SHA1值函数－无嵌套
 *
 *
 *  @return SHA1值
 */
- (NSString *)SHA1Value;

/**
 *  Hash值函数
 *
 *  @param times  嵌套次数
 *  @param type   Hash方式
 *
 *  @return Hash值
 */
- (NSString *)hashValueWithCirculationTimes:(NSUInteger )times type:(HashType)type;



@end
