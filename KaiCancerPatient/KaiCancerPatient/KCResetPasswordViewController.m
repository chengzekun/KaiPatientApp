//
//  KCResetPasswordViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/28.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCResetPasswordViewController.h"
//还没做resign处理
@interface KCResetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) KCTextFeildTool *phoneNumber;
@property (strong, nonatomic) KCTextFeildTool *verifyCode;
@property (strong, nonatomic) KCTextFeildTool *inputNewPassword;
@property (strong, nonatomic) KCTextFeildTool *reInputNewPassword;
@property (strong, nonatomic) UILabel *wrongNumberLabel;
@property (strong, nonatomic) UILabel *wrongVerifyCodeLabel;
@property (strong, nonatomic) UILabel *wrongPasswordLenLabel;



@end

@implementation KCResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem* litem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonSystemItemCancel target:self action:@selector(quit)];
    self.navigationItem.leftBarButtonItem = litem;
    
    self.phoneNumber = [[KCTextFeildTool alloc]init];
    [self.phoneNumber setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17]];
    [self.phoneNumber setPlaceholder:@"输入手机号"];
    [self.phoneNumber setDelegate:self];
    [self.phoneNumber setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.phoneNumber];
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.label).offset(46);
        make.height.mas_equalTo(40);
    }];
    
    
    self.wrongNumberLabel = [[UILabel alloc] init];
    [self.wrongNumberLabel setText:@"手机号码格式不正确"];
    [self.wrongNumberLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12]];
    [self.wrongNumberLabel setTextColor:rgba(255, 72, 83, 1)];
    [self.view addSubview:self.wrongNumberLabel];
    [self.wrongNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumber.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(18);
    }];
    
    ZKButtonModel* model = [ZKButtonModel new];
    model.actionForTouchupInside = @selector(verifyCodeSend);
    model.target = self;
    model.cornerRadius = 10;
    model.titleColorWhenNormal = ZKBuleButtonColor;
    model.titleWhenNormal = @"发送验证码";
    model.backgroundColor = rgba(245, 245, 245, 1);
    model.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    UIButton* verifyButton = [[UIButton alloc]initWithModel:model];
    [self.view addSubview:verifyButton];
    [verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.wrongNumberLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(50);

    }];
    
    
    self.verifyCode = [[KCTextFeildTool alloc]init];
    [self.verifyCode setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17]];
    [self.verifyCode setPlaceholder:@"输入验证码"];
    [self.verifyCode setDelegate:self];
    [self.verifyCode setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.verifyCode];
    [self.verifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(verifyButton.mas_bottom).offset(21);
        make.height.mas_equalTo(40);
    }];
    
    self.wrongVerifyCodeLabel = [[UILabel alloc] init];
    [self.wrongVerifyCodeLabel setText:@"验证码不正确"];
    [self.wrongVerifyCodeLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12]];
    [self.wrongVerifyCodeLabel setTextColor:rgba(255, 72, 83, 1)];
    [self.view addSubview:self.wrongVerifyCodeLabel];
    [self.wrongVerifyCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyCode.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(18);
    }];
    
    
    self.inputNewPassword = [[KCTextFeildTool alloc]init];
    [self.inputNewPassword setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17]];
    [self.inputNewPassword setPlaceholder:@"新密码"];
    [self.inputNewPassword setDelegate:self];
    [self.inputNewPassword setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.inputNewPassword];
    [self.inputNewPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.wrongVerifyCodeLabel.mas_bottom).offset(21);
        make.height.mas_equalTo(40);
    }];
    
    self.wrongVerifyCodeLabel = [[UILabel alloc] init];
    [self.wrongVerifyCodeLabel setText:@"验证码不正确"];
    [self.wrongVerifyCodeLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12]];
    [self.wrongVerifyCodeLabel setTextColor:rgba(255, 72, 83, 1)];
    [self.view addSubview:self.wrongVerifyCodeLabel];
    [self.wrongVerifyCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputNewPassword.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(18);
    }];
    
    
    self.reInputNewPassword = [[KCTextFeildTool alloc]init];
    [self.reInputNewPassword setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17]];
    [self.reInputNewPassword setPlaceholder:@"确认密码"];
    [self.reInputNewPassword setDelegate:self];
    [self.reInputNewPassword setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.reInputNewPassword];
    [self.reInputNewPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.wrongVerifyCodeLabel.mas_bottom).offset(21);
        make.height.mas_equalTo(40);
    }];
    
    
    
    model.backgroundColor = ZKBuleButtonColor;
    model.actionForTouchupInside = @selector(verifyReset);
    model.target = self;
    model.cornerRadius = 10;
    model.titleColorWhenNormal = UIColor.whiteColor;
    model.titleWhenNormal = @"确认重设";
    model.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    UIButton* verifyResetButton = [[UIButton alloc]initWithModel:model];
    [self.view addSubview:verifyResetButton];
    [verifyResetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-k_MagrinBottom+14));
        make.height.mas_equalTo(50);
    }];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneNumber resignFirstResponder];
    [self.verifyCode resignFirstResponder];
    [self.inputNewPassword resignFirstResponder];
    [self.reInputNewPassword resignFirstResponder];
}
-(void)verifyCodeSend{
    return;
}
-(void)verifyReset{
    return;
}
-(void)quit{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
