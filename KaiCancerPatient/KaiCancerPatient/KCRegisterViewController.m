//
//  KCRegisterViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/30.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCRegisterViewController.h"

@interface KCRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *Label;
@property (strong, nonatomic) KCTextFeildTool *nameFeild;
@property (strong, nonatomic) KCTextFeildTool *inputNewPassword;
@property (strong, nonatomic) KCTextFeildTool *reInputNewPassword;
@property (strong, nonatomic) UILabel *nameExists;
@end

@implementation KCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameFeild = [[KCTextFeildTool alloc]init];
    [self.nameFeild setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17]];
    [self.nameFeild setPlaceholder:@"用户名(可用于密码登录)"];
    [self.nameFeild setDelegate:self];
    [self.nameFeild setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.nameFeild];
    [self.nameFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.Label).offset(46);
        make.height.mas_equalTo(40);
    }];
    
    self.inputNewPassword = [[KCTextFeildTool alloc]init];
    [self.inputNewPassword setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17]];
    [self.inputNewPassword setPlaceholder:@"密码"];
    [self.inputNewPassword setDelegate:self];
    [self.inputNewPassword setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.inputNewPassword];
    [self.inputNewPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.nameFeild.mas_bottom).offset(47);
        make.height.mas_equalTo(40);
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
        make.top.equalTo(self.inputNewPassword.mas_bottom).offset(47);
        make.height.mas_equalTo(40);
    }];
    
    ZKButtonModel* model = [ZKButtonModel new];
    model.actionForTouchupInside = @selector(nextStep);
    model.target = self;
    model.cornerRadius = 10;
    model.titleColorWhenNormal = UIColor.whiteColor;
    model.titleWhenNormal = @"下一步";
    model.backgroundColor = ZKBuleButtonColor;
    model.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    UIButton* verifyButton = [[UIButton alloc]initWithModel:model];
    [self.view addSubview:verifyButton];
    [verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-k_MagrinBottom+14));
        make.height.mas_equalTo(50);
    }];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.nameFeild resignFirstResponder];
    [self.inputNewPassword resignFirstResponder];
    [self.reInputNewPassword resignFirstResponder];
}
-(void)nextStep{
    
    
}

@end
