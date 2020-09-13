//
//  ZZKSheet.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/8/11.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "ZKSheet.h"

@interface ZKSheet ()

//声明UIAlertController对象
@property (nonatomic, strong) UIAlertController * alert;
@end
@implementation ZKSheet

#pragma mark - public

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    self = [super init];
    if (self) {
        //构造方法中创建声明的对象
        _alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    }
    return self;
}

- (void)showWithController:(UIViewController *)controller {
    NSLog(@"show");
    [controller presentViewController:_alert animated:YES completion:nil];
}

#pragma mark - setter

//重写声明的数组属性的setter方法
- (void)setActionTitles:(NSArray *)actionTitles {
    //对属性赋值
    _actionTitles = actionTitles;
    //for循环创建Action
    for (int i = 0; i < actionTitles.count; i++) {
        //如果通过代理返回了Action的样式，则根据返回的样式设置相应Action的样式
        if ([self.delegate respondsToSelector:@selector(sheetView:actionStyleAtIndex:)]) {
            
            UIAlertActionStyle style = [self.delegate sheetView:self actionStyleAtIndex:i];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:actionTitles[i] style:style handler:^(UIAlertAction * _Nonnull action) {

                //在此设置Action的点击代理方法
                if ([self.delegate respondsToSelector:@selector(sheetView:didSelectedAtIndex:)]) {
                    
                    [self.delegate sheetView:self didSelectedAtIndex:i];
                }

                 //点击之后返回到当前界面
                [_alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [_alert addAction:action];
        }else {

            //如果没有返回Action样式，则默认设置为UIAlertActionStyleDefault

            UIAlertAction * action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                 //在此设置Action的点击代理方法
                if ([self.delegate respondsToSelector:@selector(sheetView:didSelectedAtIndex:)]) {
                    
                    [self.delegate sheetView:self didSelectedAtIndex:i];
                }

                 //点击之后返回到当前界面
                [_alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [_alert addAction:action];
        }
    }
}
@end
