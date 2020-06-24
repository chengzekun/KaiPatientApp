//
//  ZKDateTools.h
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/22.
//  Copyright © 2020 CZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKDateTools : NSObject
//获取当前周的时间
+(NSArray *)backToPassedTimeWithWeeksNumber:(NSInteger)number;
+(NSMutableArray *)backWeeksTimeNumber:(NSInteger)number;
//获取某时区的时间
@end

