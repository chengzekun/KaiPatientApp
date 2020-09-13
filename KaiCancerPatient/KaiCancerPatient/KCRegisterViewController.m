//  KCRegisterViewController.m
//  KaiCancerPatient
//  Created by 成泽坤 on 2020/6/30.
//  Copyright © 2020 CZK. All rights reserved.
#import "KCRegisterViewController.h"
@interface KCRegisterViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSData* imageData;
}
@property (weak, nonatomic) IBOutlet KCTextFeildTool *nameFeild;
@property (weak, nonatomic) IBOutlet KCTextFeildTool *inputNewPassword;
@property (weak, nonatomic) IBOutlet KCTextFeildTool *reInputNewPassword;
@property (weak, nonatomic) IBOutlet UIButton *roleButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *lastName;
@property (weak, nonatomic) IBOutlet UIButton *firstName;
@property (weak, nonatomic) IBOutlet UIButton *sexual;
@property (weak, nonatomic) IBOutlet UIButton *birthday;
@property (weak, nonatomic) IBOutlet UIButton *dieaseNo;
@property (weak, nonatomic) IBOutlet UIButton *cancerType;
@property (weak, nonatomic) IBOutlet UIButton *otherPhone;
@property (weak, nonatomic) IBOutlet UIButton *hospital;
@property (weak, nonatomic) IBOutlet KCTextFeildTool *addressInput;
@property (weak, nonatomic) IBOutlet UIButton *FinishBUtton;
@property (weak, nonatomic) IBOutlet UILabel *maxLengthLimit;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@end

@implementation KCRegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.FinishBUtton setBackgroundColor:ZKThemeColor];
    [self.FinishBUtton setTintColor:UIColor.whiteColor];
    self.FinishBUtton.layer.cornerRadius =10;
    self.FinishBUtton.layer.masksToBounds = YES;
    [self.FinishBUtton addTarget:self action:@selector(FinishRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.imageButton addTarget:self action:@selector(singleTapAction) forControlEvents:UIControlEventTouchUpInside];
    self.maxLengthLimit.hidden = YES;
    self.nameFeild.delegate = self;
    self.inputNewPassword.delegate = self;
    self.reInputNewPassword.delegate = self;
    self.addressInput.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [image cropImageWithSize:CGSizeMake(160.0f, 160.0f)];
    self->imageData = UIImageJPEGRepresentation(image, 0.5f);
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"avatar.jpg"];
    [self->imageData writeToFile:path atomically:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)singleTapAction
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

-(void)didClickKeyboard:(NSNotification *)sender{
    CGFloat durition = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGRect keyboardRect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    [UIView animateWithDuration:durition animations:^{
    self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    }];
}
-(void)didKboardDisappear:(NSNotification *)sender{
    CGFloat duration = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
    self.view.transform = CGAffineTransformIdentity;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.nameFeild resignFirstResponder];
    [self.inputNewPassword resignFirstResponder];
    [self.reInputNewPassword resignFirstResponder];
    [self.addressInput resignFirstResponder];
}

-(void)FinishRegister{
    //need null solute
    NSString* userName = [self.nameFeild text];
    NSString* password = [self.inputNewPassword text];
    NSString* repassword = [self.reInputNewPassword text];
    if((password != repassword) || (!password || !repassword)){
        NSLog(@"alert here");
        return;
    }
    NSString* userType = [self.roleButton.titleLabel text];
    //DOCTOR,NURSE,PATIENT,CAREGIVER
    if(userType == @"DOCTOR"){
        
    }else{
    }
    NSDictionary * typeDict = @{
        
    };
    
    NSDictionary * dict = @{
        @"avatarUrl":@"",
        @"firstName":@"",
        @"gender":@"",
        @"lastName":@"",
        @"patientExtra":@"",
        @"registerToken":@"",
        @"userType":@"",
        @"username":@""
    };
    
    NSString* gender = [self.sexual.titleLabel text];
    NSString* firstName = [self.firstName.titleLabel text];
    NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:@"ACCESS_KEY"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://sfp.dev.hins.work/api/v1/users/register" parameters:dict error:nil];
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
}

-(void)nextStep{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}


@end
