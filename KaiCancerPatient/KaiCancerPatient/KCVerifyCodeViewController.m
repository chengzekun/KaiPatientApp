//
//  KCVerifyCodeViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/30.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCVerifyCodeViewController.h"
#import "KCCodeView.h"
#import "KCRegisterViewController.h"
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
    model.actionForTouchupInside = @selector(verifyCodereSend);
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

-(void)verifyCodeResend{
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
//example:
//data =     {
//    encodedAccessToken = "NWYyNmRmYWQ1OTkzMGI3MjNkNGVjZmUwOlBBVElFTlQ6V0VCOlBIT05FX1NNU19DT0RFOjVmMjZkZmFkNTk5MzBiNzIzZDRlY2ZlMzpQQVRJRU5UOmQ0YzlmYzY2LTlhNGEtNDJmYi1hNGZiLTc5MTRkOGVmNmJhZA==";
//    firstName = "\U6cfd\U5764";
//    gender = MALE;
//    id = 5f26dfad59930b723d4ecfe0;
//    lastName = "\U6210";
//    patientExtra =         {
//        address = "\U7535\U5b50\U79d1\U6280\U5927\U5b66";
//        disease =             {
//            id = 5efdae4cd3e8af7b24d07027;
//            name = aaaa;
//            remark = fffff;
//        };
//        emergencyContact = 13693405365;
//        hospital =             {
//            id = 5ef3fdeff7a84005aeb136d7;
//            location = "xxxxxx"
//            name = "xxxxxxxxxxxxxxxxxxxx";
//            telephone = "028-85422114";
//        };
//        medicalRecordNumber = 123;
//        registerQuestionnairesFinished = 0;
//    };
//    phone = 13693405365;
//    registerDate = "2020-08-02 23:45:49";
//    role = PATIENT;
//    userType = PATIENT;
//    username = chengzekun; 注册的入口只有电话 好的
//};

-(void)login{
    NSDictionary* dict = @{
        @"principal":self.PhoneNumber,
        @"credential":self.verifyCode,
        @"authType":@"PHONE_SMS_CODE",
    };
    if(self.PhoneNumber && self.codeView.code.length == 6){
        self.wrongNumberLabel.hidden = YES;
        AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:@"http://sfp.dev.hins.work/api/login" parameters:dict headers:@{
            @"Content-Type":@"application/json"
        } progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary* res = (NSDictionary*)responseObject;
            if([((NSString*)res[@"message"]) isEqualToString:@"success"]){
                [[NSUserDefaults standardUserDefaults] setObject:res[@"data"] forKey:@"UserData"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE_ROOT_Vontroller" object:nil];
                NSLog(@"%@",res);
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前号码尚未注册，是否现在注册？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                    KCRegisterViewController* registerViewController = [KCRegisterViewController new];
                    registerViewController.registerToken = res[@"data"][@"registerToken"];
                    [self.navigationController pushViewController:registerViewController animated:YES];
                }];
                UIAlertAction* cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:okAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:true completion:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"ERROR:%@",error.description);
        }];
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
