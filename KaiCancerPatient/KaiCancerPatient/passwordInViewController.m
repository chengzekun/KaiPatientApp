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
    [self.phoneTextfeild setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"PHONE"]];
    [self.passwordTextFeild setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"PASSWORD"]];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)LoginWithPassword:(id)sender {
    
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
