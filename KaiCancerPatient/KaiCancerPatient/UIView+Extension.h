//
//  UIView+Extension.h
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/15.
//  Copyright © 2020 CZK. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Extension)
@property(nonatomic, assign)CGFloat x;
@property(nonatomic, assign)CGFloat y;
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, assign)CGSize size;
@property(nonatomic, assign)CGPoint origin;
@property(nonatomic, assign)CGFloat centerX;
@property(nonatomic, assign)CGFloat centerY;

- (void)addCenterLineWithHeight:(CGFloat )height;
- (void)addBottomSingleLineWithHeight:(CGFloat)height;
- (void)addShadow;
- (void)addTopSingleLineWithHeight:(CGFloat)height;
- (void)addLeftSingleLineWithWidth:(CGFloat )width;
@end

