//
//  passwordInViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/28.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "passwordInViewController.h"
#import "KCResetPasswordViewController.h"
@interface passwordInViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfeild;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFeild;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetpasswordbutton;
@end

@implementation passwordInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.LoginButton.backgroundColor = ZKBuleButtonColor;
    self.LoginButton.layer.cornerRadius = 10;
    self.phoneTextfeild.borderStyle = UITextBorderStyleNone;
    self.passwordTextFeild.borderStyle = UITextBorderStyleNone;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    self.passwordTextFeild.delegate = self;
    self.phoneTextfeild.delegate = self;
    [self.LoginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (IBAction)LoginWithPassword:(id)sender {
    
    //    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    //    if(_phoneTextfeild.text.length == 11){
    //        NSDictionary* dic = @{
    //            @"principal":_phoneTextfeild.text,
    //            @"credential":self.passwordTextFeild.text,
    //            @"authType":@"PHONE_PASSWORD",
    //            @"deviceToken":@"consequatadipisicing"
    //        };
    //    }
    NSDictionary* dict = @{
        @"principal":@"chengzekun",
        @"credential":@"123456",
        @"authType":@"USERNAME_PASSWORD",
        @"deviceToken":@"123456"
    };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
    NSDictionary *headers = @{
        @"Content-Type": @"application/json"
    };
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"http://sfp.dev.hins.work/api/login" parameters:dict headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *res = (NSDictionary*)responseObject;
        [[NSUserDefaults standardUserDefaults]setObject:res[@"data"][@"encodedAccessToken"] forKey:@"encodedAccessToken"];
        [[NSUserDefaults standardUserDefaults]setObject:res[@"data"] forKey:@"UserData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE_ROOT_Vontroller" object:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}
- (IBAction)forgetPassword:(id)sender {
    KCResetPasswordViewController * vc = [KCResetPasswordViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneTextfeild resignFirstResponder];
    [self.passwordTextFeild resignFirstResponder];
}
@end
