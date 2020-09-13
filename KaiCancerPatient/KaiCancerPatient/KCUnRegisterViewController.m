//
//  KCUnRegisterViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/7/17.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCUnRegisterViewController.h"
//#import "KCRegisterViewController.h"
#import "KCLoginViewController.h"
@interface KCUnRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@end

@implementation KCUnRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.registerButton setTintColor:ZKThemeColor];
    [_registerButton setTitle:@"注册并开始" forState:UIControlStateNormal];
    [_registerButton.titleLabel setFont:FontPingFangSCS(17)];
    [_registerButton setBackgroundColor:UIColor.whiteColor];
    _registerButton.layer.cornerRadius = 10.0f;
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)registerIn:(id)sender {
    KCLoginViewController *vc = [[KCLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

@end
