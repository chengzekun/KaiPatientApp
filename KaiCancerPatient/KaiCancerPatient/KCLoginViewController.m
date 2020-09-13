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
    [self.wrongCodeLabel setHidden:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.wrongCodeLabel.hidden = YES;

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneNumberTextFeild resignFirstResponder];
}

-(void)goBack{
    NSLog(@"To pre View");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)passwordLogin{
    NSLog(@"To passwordLogin View");
    passwordInViewController* vc = [passwordInViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)verify{
    // && self.phoneNumberTextFeild.text.length == 11)  self.phoneNumberTextFeild.text
    if(self.phoneNumberTextFeild.text) {
        self.wrongCodeLabel.hidden = YES;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 15;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager GET:@"http://sfp.dev.hins.work/api/v1/sms"  parameters:@{
            @"phone":@"13693405365"
        } headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            KCVerifyCodeViewController* vc = [KCVerifyCodeViewController new];
            vc.PhoneNumber = @"13693405365";
            vc.verifyCode = responseObject[@"data"];
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self showAlert:error];
        }];
        
    }else{
        self.wrongCodeLabel.hidden = NO;
        
    }
    return;
}
-(void)showAlert:(NSError*)error{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"ERROR"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"action = %@", action);
                                                          }];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
