//
//  KCIMTableViewCell.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/7/14.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCIMTableViewCell.h"
@interface KCIMTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *avator;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *emergency;
@property (weak, nonatomic) IBOutlet UILabel *lastTime;
@end
@implementation KCIMTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self setBackgroundColor:UIColor.blackColor];
    
    UIGraphicsBeginImageContextWithOptions(_avator.bounds.size, NO, 0.0);
    //使用贝塞尔曲线画出一个圆形图
    [[UIBezierPath bezierPathWithRoundedRect:_avator.bounds cornerRadius:_avator.frame.size.width] addClip];
    [_avator drawRect:_avator.bounds];
    _avator.image = UIGraphicsGetImageFromCurrentImageContext();
     //结束画图
    UIGraphicsEndImageContext();
    self.emergency.layer.cornerRadius = 9.5;
    self.emergency.layer.masksToBounds = YES;

}
-(void)updateWithName:(NSString*)name avater:(NSString*)avater message:(NSString*)message emergency:(BOOL)isEmergency lastTime:(NSString*)time{
    self.nameLabel.text = name;
    self.message.text = message;
    self.emergency.hidden = isEmergency;
    self.lastTime.text = time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
