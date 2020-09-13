//
//  bottomScrollView.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/7/9.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "bottomScrollView.h"

@implementation bottomScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
