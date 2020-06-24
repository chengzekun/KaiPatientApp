//
//  EventCalender.h
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/22.
//  Copyright © 2020 CZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventCalender : NSObject
+(instancetype)sharedEventCalendar;

- (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay;
//alarmArray:(NSArray *)alarmArray



@end


