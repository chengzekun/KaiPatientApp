//
//  KCLoginViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/22.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCLoginViewController.h"
#import "PreLoginViewController.h"
#import "passwordInViewController.h"
#import "KCVerifyCodeViewController.h"
@interface KCLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *wrongCodeLabel;

@end

@implementation KCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"inLoginView");
    [self.wrongCodeLabel setTextColor:rgb(255, 72, 83)];
    self.verifyCodeButton.backgroundColor = ZKBuleButtonColor;
    self.verifyCodeButton.layer.cornerRadius = 10;
    self.phoneNumberTextFeild.borderStyle = UITextBorderStyleNone;
    self.phoneNumberTextFeild.delegate = self;
    [self.phoneNumberTextFeild setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"PHONE"]];
    
    [self.verifyCodeButton addTarget:self action:@selector(verify) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lbtnItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = lbtnItem;
    UIBarButtonItem *rbtnItem = [[UIBarButtonItem alloc]  initWithTitle:@"密码登录" style:UIBarButtonItemStylePlain target:self action:@selector(passwordLogin)];
    self.navigationItem.rightBarButtonItem = rbtnItem;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneNumberTextFeild resignFirstResponder];
}
-(void)goBack{
    NSLog(@"To pre View");
    PreLoginViewController* vc = [PreLoginViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)passwordLogin{
    NSLog(@"To passwordLogin View");
    passwordInViewController* vc = [passwordInViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)verify{
    KCVerifyCodeViewController* vc = [KCVerifyCodeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    return;
}
@end
