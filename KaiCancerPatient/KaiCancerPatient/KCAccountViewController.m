//
//  KCAccountViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/23.
//  Copyright © 2020 CZK. All rights reserved.
//
#import "KCAccountViewController.h"
#import "ZKSheet.h"
#import "KCResetPasswordViewController.h"
#import "KCResetPhoneViewController.h"
#import "KCEditDetailViewController.h"
#import "KCUserModel.h"
@interface KCAccountViewController ()<UIScrollViewDelegate,ZKSheetViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatorView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *roleAndYear;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (strong,nonatomic) ZKSheet* sheet;
@end
@implementation KCAccountViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.editButton.backgroundColor = ZKThemeColor;
    self.editButton.layer.cornerRadius = 17;
    [self.editButton setTintColor:UIColor.whiteColor];
    [self.moreButton setImage:[UIImage imageNamed:@"more_circle"] forState:UIControlStateNormal];
    self.cardView.layer.cornerRadius = 8;
    [self updateUserInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
-(void)updateUserInfo{
    NSDictionary* UserDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserData"];
    KCUserModel *user = [KCUserModel mj_objectWithKeyValues:UserDict[@"data"]];
//    NSLog(@"USER_NAME:%@",user.firstName );
//    [NSString stringWithFormat:@"%@%@",str1,UserDict[@"firstName"]]
    //[self.avatorView sd_setImageWithURL:[NSURL URLWithString:UserDict[@"avator"]]];
    self.userName.text = [NSString stringWithFormat:@"%@%@",user.lastName,user.firstName];
    [self.gender setText:[user.gender isEqual:@"MALE"]?@"男士":@"女士"];
    [self.roleAndYear setText:[NSString stringWithFormat:@"%@ 23",[user.role isEqual:@"PATIENT"]?@"患者":@"照顾者"]];
    [self.avatorView setImage:[UIImage imageNamed:@"avatar"]];
}

- (IBAction)clickEditButton:(id)sender {
    NSLog(@"in clickEditButton");
    [self.sheet showWithController:self];
}

- (ZKSheet* )sheet{
    if(!_sheet){
        _sheet = [[ZKSheet alloc] initWithTitle:nil message:nil];
        _sheet.delegate = self;
        _sheet.actionTitles = @[@"重设密码",@"绑定新手机号",@"退出登录",@"取消"];
    }
    return _sheet;
}

- (UIAlertActionStyle)sheetView:(ZKSheet*)sheetView actionStyleAtIndex:(NSInteger)index{
    if (index == 2) {
        return UIAlertActionStyleDestructive;
    }else if (index == sheetView.actionTitles.count - 1) {
        return UIAlertActionStyleCancel;
    }
    return UIAlertActionStyleDefault;
}

- (void)sheetView:(ZKSheet*)sheetView didSelectedAtIndex:(NSInteger)index{
    if(index == 0){
        KCResetPhoneViewController* vc = [KCResetPhoneViewController  new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(index == 1){
        KCResetPhoneViewController* vc = [KCResetPhoneViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(index == 2){
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"UserData"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"encodedAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE_ROOT_Vontroller_Login" object:nil];
    }
}
- (IBAction)clickMoreButton:(id)sender {
    KCEditDetailViewController* vc = [KCEditDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)switchNoti:(id)sender {
    
}

- (IBAction)clickAboutButton:(id)sender {
}

@end
