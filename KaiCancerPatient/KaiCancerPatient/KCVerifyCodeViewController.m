//
//  KCVerifyCodeViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/30.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCVerifyCodeViewController.h"
#import "KCCodeView.h"
@interface KCVerifyCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Label;
@property (strong,nonatomic) KCCodeView* codeView;
@property (strong,nonatomic) UILabel* wrongNumberLabel;
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
        make.top.equalTo(self.Label.mas_bottom).offset(138);
        make.height.mas_equalTo(68);
    }];
    
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
    
    
    ZKButtonModel* model = [ZKButtonModel new];
    model.actionForTouchupInside = @selector(verifyCodeReSend);
    model.target = self;
    model.cornerRadius = 10;
    model.titleColorWhenNormal = ZKBuleButtonColor;
    model.titleWhenNormal = @"发送验证码";
    model.backgroundColor = UIColor.whiteColor;
    model.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    UIButton* verifyButton = [[UIButton alloc]initWithModel:model];
    [self.view addSubview:verifyButton];
    [verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.wrongNumberLabel.mas_bottom).offset(47);
        make.height.mas_equalTo(50);

    }];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.codeView resignFirstResponder];
}

-(void)verifyCodeReSend{
    return;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
