//
//  KCTextFeildTool.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/29.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCTextFeildTool.h"

@implementation KCTextFeildTool

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

- (void)drawRect:(CGRect)rect {
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextSetFillColorWithColor(context, rgba(139, 139, 139, 1).CGColor);
     CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

@end
