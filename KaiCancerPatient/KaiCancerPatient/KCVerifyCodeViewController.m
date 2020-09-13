//
//  KCVerifyCodeViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/30.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCVerifyCodeViewController.h"
#import "KCCodeView.h"
#define TIMECOUNT 60

@interface KCVerifyCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Label;
@property (strong,nonatomic) KCCodeView* codeView;
@property (strong,nonatomic) UILabel* wrongNumberLabel;
@property (strong,nonatomic) UIButton* LoginButton;
@property (strong,nonatomic) UIButton* verifyButton;
@property (assign, nonatomic) int count;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation KCVerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.codeView = [[KCCodeView alloc] initWithCount:6 margin: 20];
    self.codeView.userInteractionEnabled = YES;
    [self.view addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.Label.mas_bottom).offset(80);
        make.height.mas_equalTo(68);
    }];
    self.count = TIMECOUNT;
    self.wrongNumberLabel = [[UILabel alloc] init];
    [self.wrongNumberLabel setText:@"验证码不正确"];
    [self.wrongNumberLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12]];
    [self.wrongNumberLabel setTextColor:rgba(255, 72, 83, 1)];
    [self.view addSubview:self.wrongNumberLabel];
    [self.wrongNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(18);
    }];
    
    self.wrongNumberLabel.hidden = YES;
    
    ZKButtonModel* modelL = [ZKButtonModel new];
    modelL.actionForTouchupInside = @selector(login);
    modelL.target = self;
    modelL.cornerRadius = 10;
    modelL.titleColorWhenNormal = UIColor.whiteColor ;
    modelL.titleWhenNormal = @"登录";
    modelL.backgroundColor = ZKBuleButtonColor;
    modelL.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    self.LoginButton = [[UIButton alloc] initWithModel:modelL];
    [self.view addSubview:self.LoginButton];
    [self.LoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.view).offset(16);
       make.right.equalTo(self.view).offset(-16);
       make.top.equalTo(self.wrongNumberLabel.mas_bottom).offset(50);
       make.height.mas_equalTo(50);
    }];
    
    ZKButtonModel* model = [ZKButtonModel new];
    model.actionForTouchupInside = @selector(verifyCodeReSend);
    model.target = self;
    model.titleColorWhenNormal = ZKBuleButtonColor;
    model.titleWhenNormal = @"点击获取验证码(60)";
    model.backgroundColor = UIColor.whiteColor;
    model.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    self.verifyButton = [[UIButton alloc]initWithModel:model];
    self.verifyButton.userInteractionEnabled = NO;
    [self.view addSubview:self.verifyButton];
    [self.verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.LoginButton.mas_bottom).offset(23);
        make.height.mas_equalTo(24);
    }];
    
    [self performSelectorInBackground:@selector(timerThread) withObject:nil];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

-(void)verifyCodeReSend{
    self.count = TIMECOUNT;
    [self performSelectorInBackground:@selector(timerThread) withObject:nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:@"http://sfp.dev.hins.work/api/v1/sms"  parameters:@{
        @"phone":self.PhoneNumber
    } headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.verifyCode = responseObject[@"data"];
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showAlert:error];
    }];
}


-(void)login{
    //[[NSUserDefaults standardUserDefaults]objectForKey:@"DEVICE_TOKEN"]
    NSDictionary* dict = @{
        @"principal":self.PhoneNumber,
        @"credential":self.verifyCode,
        @"authType":@"PHONE_SMS_CODE",
        @"deviceToken":@"consequatadipisicing"
    };
    NSLog(@"registerToken:::::::%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"registerToken"]);
    if(self.PhoneNumber && self.codeView.code){
        if(self.codeView.code.length == 6){
            self.wrongNumberLabel.hidden = YES;
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://sfp.dev.hins.work/api/login" parameters:dict error:nil];
            request.timeoutInterval = 10.f;
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                NSLog(@"-----responseObject===%@+++++",responseObject);
                if (!error) {
                    NSString *str = responseObject[@"message"];
                    if([str isEqual:@"用户短信验证通过，但是尚未注册"]){
                        NSLog(@"%@", responseObject[@"data"][@"registerToken"]);
                        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][@"registerToken"] forKey:@"registerToken"];
                    }
                } else {
                    NSLog(@"请求失败error=%@", error);
                }
            }];
            [task resume];
        }else{
            self.wrongNumberLabel.hidden = NO;
        }
    }else{
        self.wrongNumberLabel.hidden = NO;
    }

}
- (void)viewDidDisappear:(BOOL)animated {
    [self.timer invalidate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)timerThread {
    for (int i = TIMECOUNT; i > 0 ; i--) {
        self.count--;
        [self performSelectorOnMainThread:@selector(updateFirstBtn) withObject:nil waitUntilDone:YES];
        sleep(1);
    }
}

- (void)updateFirstBtn {
    NSString *str = nil;
    if (self.count == 0) {
        str = [NSString stringWithFormat:@"点击获取验证码(60)"];
        self.verifyButton.userInteractionEnabled = YES;
    } else {
        str = [NSString stringWithFormat:@"点击获取验证码(%d)",self.count];
        self.verifyButton.userInteractionEnabled = NO;
    }
    [self.verifyButton setTitle:str forState:UIControlStateNormal];
}

- (void)showAlert:(NSError *)error{
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
