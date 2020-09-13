//
//  KCIMTableViewCell.h
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/7/14.
//  Copyright © 2020 CZK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCIMTableViewCell : UITableViewCell
-(void)updateWithName:(NSString*)name avater:(NSString*)avater message:(NSString*)message emergency:(BOOL)isEmergency lastTime:(NSString*)time;
@end

NS_ASSUME_NONNULL_END
