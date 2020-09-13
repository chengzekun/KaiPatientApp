//
//  ZZKSheet.h
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/8/11.
//  Copyright © 2020 CZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ZKSheetViewDelegate;
@interface ZKSheet : NSObject

//声明代理
@property (nonatomic, weak) id<ZKSheetViewDelegate> delegate;

//Action的title数组
@property (nonatomic, strong) NSArray * actionTitles;

//自定义构造方法
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

//跳转展示方法
- (void)showWithController:(UIViewController *)controller;
@end
//设置代理协议及方法
@protocol ZKSheetViewDelegate <NSObject>

@optional   //非必须实现代理方法
//返回Action的样式
- (UIAlertActionStyle)sheetView:(ZKSheet *)sheetView actionStyleAtIndex:(NSInteger)index;

//点击相应的Action之后触发的方法
- (void)sheetView:(ZKSheet *)sheetView didSelectedAtIndex:(NSInteger)index;

@end
