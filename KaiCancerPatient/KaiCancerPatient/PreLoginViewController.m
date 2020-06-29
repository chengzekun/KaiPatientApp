//
//  PreLoginViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/26.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "PreLoginViewController.h"
#import "KCLoginViewController.h"
@interface PreLoginViewController ()

@end

@implementation PreLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.PushButton.frame = CGRectMake(0, 0, 0, 50);
//    self.PushButton.backgroundColor = rgba(254, 246, 216, 1);
//    [self.PushButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(16);
//        make.right.equalTo(self.view.mas_right).offset(-16);
//        make.bottom.equalTo(self.view).offset(-34);
//    }];
    self.PushButton.backgroundColor = ZKBuleButtonColor;
    self.PushButton.layer.cornerRadius = 10;
}

- (IBAction)PushButton:(id)sender {
    NSLog(@"进入Pre页面");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE_ROOT_VIEWCONTROLLER_LOGIN" object:nil];
}

@end
