//  KCRegisterViewController.m
//  KaiCancerPatient
//  Created by 成泽坤 on 2020/6/30.
//  Copyright © 2020 CZK. All rights reserved.
#import "KCRegisterViewController.h"
@interface KCRegisterViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGFloat textFeildPointY;
    int diseasesIndex;
    int hospitalIndex;
}
@property (weak, nonatomic) IBOutlet UILabel *varLabel;
@property (weak, nonatomic) IBOutlet KCTextFeildTool *nameFeild;
@property (weak, nonatomic) IBOutlet KCTextFeildTool *inputNewPassword;
@property (weak, nonatomic) IBOutlet KCTextFeildTool *reInputNewPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imageView; //上传图片
@property (weak, nonatomic) IBOutlet UIButton *imageButton; // 弹出chooseAction
//alert button
@property (weak, nonatomic) IBOutlet UIButton *lastName; //名字 弹出alert
@property (weak, nonatomic) IBOutlet UIButton *firstName;//姓氏 弹出alert
@property (weak, nonatomic) IBOutlet UIButton *otherPhone;//其他手机 弹出alert
@property (weak, nonatomic) IBOutlet UIButton *dieaseNo;//病案号 弹出alert

//sheet action button
@property (weak, nonatomic) IBOutlet UIButton *roleButton; //角色 sheet
@property (weak, nonatomic) IBOutlet UIButton *sexual; //男女 选择sheet
@property (weak, nonatomic) IBOutlet UIButton *birthday;//生日 选择sheet
@property (weak, nonatomic) IBOutlet UIButton *cancerType;//疾病的类型 选择sheet
@property (weak, nonatomic) IBOutlet UIButton *hospital;//医院 选择sheet

@property (weak, nonatomic) IBOutlet KCTextFeildTool *addressInput; //地址
@property (weak, nonatomic) IBOutlet UIButton *FinishBUtton; //完成了
@property (weak, nonatomic) IBOutlet UILabel *maxLengthLimit; //最大数量限制
@property (strong,nonatomic)NSMutableArray* diseasesArray;
@property (strong,nonatomic)NSMutableArray* hospitalArray;
@end

@implementation KCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //basic component setting
    [self.FinishBUtton setBackgroundColor:ZKThemeColor];
    [self.FinishBUtton.titleLabel setFont:FontPingFangSCR(17)];
    [self.FinishBUtton setTintColor:UIColor.whiteColor];
    self.FinishBUtton.layer.cornerRadius =10;
    self.FinishBUtton.layer.masksToBounds = YES;
    
    [self.FinishBUtton addTarget:self action:@selector(FinishRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [self.imageButton addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    self.maxLengthLimit.hidden = YES;
    self.nameFeild.delegate = self;
    self.inputNewPassword.delegate = self;
    self.reInputNewPassword.delegate = self;
    self.addressInput.delegate = self;
    
    //Add Button Action -Alert
    [self.firstName addTarget:self action:@selector(firstNameInput) forControlEvents:UIControlEventTouchUpInside];
    [self.lastName addTarget:self action:@selector(lastNameInput) forControlEvents:UIControlEventTouchUpInside];
    [self.otherPhone addTarget:self action:@selector(otherPhoneInput) forControlEvents:UIControlEventTouchUpInside];
    [self.dieaseNo addTarget:self action:@selector(dieaseNoInput) forControlEvents:UIControlEventTouchUpInside];
    
    //Add Button Action -ActionSheet
    [self.roleButton addTarget:self action:@selector(roleTypeChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.sexual addTarget:self action:@selector(sexualChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.birthday addTarget:self action:@selector(birthdayChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.cancerType addTarget:self action:@selector(cancerTypeChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.hospital addTarget:self action:@selector(hospitalChoose) forControlEvents:UIControlEventTouchUpInside];
    
    //Array init
    self.diseasesArray = [[NSMutableArray alloc]initWithCapacity:100];
    self.hospitalArray = [[NSMutableArray alloc]initWithCapacity:100];
    self->textFeildPointY = 0.0f;
    self->diseasesIndex = 0;
    self->hospitalIndex = 0;
    
    //basic Info get
    [self getInfo];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - getBasicInfo diseasesArray hospitalArray
-(void)getInfo{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //GET diseases info
    [manager GET:@"http://sfp.dev.hins.work/api/v1/diseases" parameters:nil headers:@{
        @"Content-Type":@"application/json"
    }
        progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary* dic = (NSMutableDictionary*)responseObject;
        NSLog(@"%@",dic);
        self.diseasesArray = dic[@"data"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
    
    //GET hospital info
    [manager GET:@"http://sfp.dev.hins.work/api/v1/hospitals" parameters:nil
         headers:@{@"Content-Type":@"application/json"}
        progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary* dic = (NSMutableDictionary*)responseObject;
        self.hospitalArray = dic[@"data"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
    
}

#pragma mark - keyboard
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editviewBeginEdit:) name:UITextFieldTextDidBeginEditingNotification object:nil];
}
- (void)editviewBeginEdit:(NSNotification *)notification{
    UITextField *text = notification.object;
    self->textFeildPointY = text.frame.origin.y;
    NSLog(@"text point: %f" , text.frame.origin.y);
}
-(void)keyboardWillShow:(NSNotification *)sender{
    CGFloat durition = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGRect keyboardRect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    NSLog(@"keyboardHeight:%f",keyboardHeight);
    if(self->textFeildPointY < keyboardHeight){
        return;
    }
    [UIView animateWithDuration:durition animations:^{
        //向上平移
        self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    }];
}
-(void)keyboardWillHide:(NSNotification *)sender{
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

#pragma mark - finishPOST
-(void)FinishRegister{
    //1. update photo
    //2. update info
    //密码不一
    NSMutableArray* parameter = [NSMutableArray new];

    NSString* password = self.inputNewPassword.text;
    [parameter addObject:password];
    NSString* repassword = self.reInputNewPassword.text;
    [parameter addObject:repassword];
    NSString* userName = self.nameFeild.text;
    [parameter addObject:userName];
    NSString* gender = [self.sexual.titleLabel.text isEqualToString:@"男"]?@"MALE":@"FEMALE";
    [parameter addObject:gender];
    NSString* firstName = self.firstName.titleLabel.text;
    [parameter addObject:firstName];
    NSString* lastName = self.lastName.titleLabel.text;
    [parameter addObject:lastName];
    NSString* userType = [self.roleButton.titleLabel.text isEqualToString:@"患者"]?@"PATIENT":@"CAREGIVER";
    [parameter addObject:userType];
    NSString* birthday = self.birthday.titleLabel.text;
    [parameter addObject:birthday];
    NSString* medicalRecordNumber = self.dieaseNo.titleLabel.text;
    [parameter addObject:medicalRecordNumber];
    NSString* diseaseId = self.diseasesArray[self->diseasesIndex][@"id"];
    [parameter addObject:diseaseId];
    NSString* phone = self.otherPhone.titleLabel.text;
    [parameter addObject:phone];
    NSString* hospital = self.hospitalArray[self->diseasesIndex][@"id"];
    [parameter addObject:hospital];
    NSString* address = self.addressInput.text;
    [parameter addObject:address];
    for (NSString* str in parameter) {
        if(str == nil || [str isEqualToString:@"请输入"] || [str isEqualToString:@"请选择"]){
            [SVProgressHUD showWithStatus:@"注册信息不能为空"];
            return;
        }
        NSLog(@"%@",str);
    }
    if(![password isEqualToString:repassword]){
        [SVProgressHUD showWithStatus:@"两次输入密码不一致"];
        return;
    }
    if(self.imageView.image != nil){
        [SVProgressHUD show];
        //File POST
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"http://sfp.dev.hins.work/api/v1/files" parameters:nil headers:nil
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(self.imageView.image, 0.8)
                                        name:@"files"
                                    fileName:@"123.jpeg" mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //File POST Finish
            NSString* avatarPath = (NSString*)responseObject[@"data"][@"paths"][0];
            NSLog(@"avatarPath:%@",avatarPath);
            if([userType isEqualToString:@"PATIENT"]){
                //PATIENT TYPE
                NSDictionary* patientExtra = @{
                    @"address":address,
                    @"birthday":birthday,
                    @"diseaseId":diseaseId,
                    @"emergencyContact":phone,
                    @"hospitalId":hospital,
                    @"medicalRecordNumber":medicalRecordNumber
                };
                NSDictionary* PATIENT = @{
                    @"avatar":avatarPath,
                    @"lastname":lastName,
                    @"firstname":firstName,
                    @"gender":gender,
                    @"password":password,
                    @"registerToken":self.registerToken,
                    @"userType":userType,
                    @"username":userName,
                    @"patientExtra":patientExtra,
                };
                NSLog(@"%@",PATIENT);
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                [manager POST:@"http://sfp.dev.hins.work/api/v1/users/register" parameters:PATIENT headers:@{
                    @"Content-Type":@"application/json"}
                     progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"%@",responseObject);
//                    code = 0;
//                    data =     {
//                        avatar = "http://39.100.89.3/resources/avatar/5f6970087fa150221556fb80/123.jpeg";
//                        encodedAccessToken = "NWY2OTcwMDg3ZmExNTAyMjE1NTZmYjgxOlBBVElFTlQ6V0VCOlBIT05FX1NNU19DT0RFOjVmNjk3MDA4N2ZhMTUwMjIxNTU2ZmI4NDpQQVRJRU5UOmM3YTVlOGIzLTQxMjgtNDIyNi04MzU3LWU4ZTlhOGJlMjAxNA==";
//                        firstName = tttttt;
//                        gender = MALE;
//                        id = 5f6970087fa150221556fb81;
//                        lastName = rrrr;
//                        patientExtra =         {
//                            address = wwwww;
//                            birthday = "1997-12-30 00:00:00";
//                            disease =             {
//                                id = 5efdae4bd3e8af7b24d07026;
//                                name = 1111;
//                                remark = 22222ddd;
//                            };
//                            emergencyContact = 22222;
//                            hospital =             {
//                                id = 5ef3fdeff7a84005aeb136d6;
//                                location = "\U56db\U5ddd\U7701\U6210\U90fd\U5e02\U4eba\U6c11\U5357\U8def\U56db\U6bb555\U53f7";
//                                name = "\U56db\U5ddd\U7701\U80bf\U7624\U533b\U9662\Uff08\U56db\U5ddd\U7701\U7b2c\U4e8c\U4eba\U6c11\U533b\U9662\Uff09";
//                                telephone = "028-85420251";
//                            };
//                            medicalRecordNumber = 22222;
//                            registerQuestionnairesFinished = 0;
//                        };
//                        phone = 11111111111;
//                        registerDate = "2020-09-22 11:31:20";
//                        role = PATIENT;
//                        userType = PATIENT;
//                        username = qqqqq;
//                    };
//                    message = success;
                    NSDictionary* res = (NSDictionary*)responseObject[@"data"];
                    [[NSUserDefaults standardUserDefaults] setObject:res forKey:@"UserData"];
                    [[NSUserDefaults standardUserDefaults] setObject:res[@"encodedAccessToken"] forKey:@"encodedAccessToken"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    
                    
                    [SVProgressHUD dismiss];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVProgressHUD dismiss];
                    NSLog(@"%@",error.localizedDescription);
                }];
            }else{
                //PATIENT TYPE
                NSDictionary* caregiverExtra = @{
                    @"address":address,
                    @"birthday":birthday,
                    @"diseaseId":diseaseId,
                    @"relationshipWithPatient":phone,
                    @"hospitalId":hospital,
                    @"medicalRecordNumber":medicalRecordNumber
                };
                [manager POST:@"http://sfp.dev.hins.work/api/v1/users/register" parameters:@{
                    @"avatar":avatarPath,
                    @"lastname":lastName,
                    @"firstname":firstName,
                    @"gender":gender,
                    @"password":password,
                    @"registerToken":self.registerToken,
                    @"userType":userType,
                    @"username":userName,
                    @"caregiverExtra":caregiverExtra
                } headers:@{
                    @"Content-Type":@"application/json"}
                     progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //直接账号密码登陆
                    NSLog(@"%@",responseObject);
                    
                    
                    
                    
                    
                    
                    
                    
                    [SVProgressHUD dismiss];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVProgressHUD dismiss];
                    NSLog(@"%@",error.localizedDescription);
                }];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }else{
        [SVProgressHUD showWithStatus:@"头像为空"];
        return;
    }
}


#pragma mark - button&textfeild Action 选择控件+输入控件
-(void)chooseImage{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
//完成选择图片并处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.imageView.image = image;
    self.imageView.layer.cornerRadius =self.imageView.frame.size.width/2;
    self.imageView.layer.masksToBounds = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)firstNameInput{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"名" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *TextField = alertController.textFields.firstObject;
        [self.firstName setTitle:TextField.text forState:UIControlStateNormal]; ;
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardHIDUsageKeyboardReturn;
    }];
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)lastNameInput{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"姓" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *TextField = alertController.textFields.firstObject;
        [self.lastName setTitle:TextField.text forState:UIControlStateNormal]; ;
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardHIDUsageKeyboardReturn;
    }];
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)otherPhoneInput{
    if([self.varLabel.text isEqualToString:@"紧急联系人方式"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"手机号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *TextField = alertController.textFields.firstObject;
            [self.otherPhone setTitle:TextField.text forState:UIControlStateNormal]; ;}]];
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {textField.keyboardType = UIKeyboardTypePhonePad;}];
        [self presentViewController:alertController animated:true completion:nil];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"与患者的关系" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *TextField = alertController.textFields.firstObject;
            [self.otherPhone setTitle:TextField.text forState:UIControlStateNormal];}]];
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {textField.keyboardType = UIKeyboardTypeDefault;}];
        [self presentViewController:alertController animated:true completion:nil];
    }

}

-(void)dieaseNoInput{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入病案号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *TextField = alertController.textFields.firstObject;
        [self.dieaseNo setTitle:TextField.text forState:UIControlStateNormal];}]];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"病案号";
        textField.keyboardType = UIKeyboardTypeNumberPad;}];
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)roleTypeChoose{
    NSArray *initialSelection = @[@0];
    [ActionSheetMultipleStringPicker showPickerWithTitle:@"选择角色"
                                                    rows:@[@[@"患者",@"照顾者"]]
                                        initialSelection:initialSelection
                                               doneBlock:^(ActionSheetMultipleStringPicker *picker,
                                                           NSArray *selectedIndexes,
                                                           NSArray *selectedValues) {
        
        [self.roleButton setTitle:selectedValues[0] forState:UIControlStateNormal];
        if([selectedValues[0] isEqualToString:@"患者"]){
            [self.varLabel setText:@"紧急联系人方式"];
        }else{
            [self.varLabel setText:@"与被照顾者关系"];
        }
        NSLog(@"%@",selectedValues[0]);
    }cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
        NSLog(@"picker = %@", picker);
    } origin:self.view];
}

-(void)sexualChoose{
    NSArray *initialSelection = @[@0];
    [ActionSheetMultipleStringPicker showPickerWithTitle:@"选择性别"
                                                    rows:@[@[@"男",@"女"]]
                                        initialSelection:initialSelection
                                               doneBlock:^(ActionSheetMultipleStringPicker *picker,
                                                           NSArray *selectedIndexes,
                                                           NSArray *selectedValues) {
        [self.sexual setTitle:selectedValues[0] forState:UIControlStateNormal];
        NSLog(@"%@",selectedValues[0]);
    }cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
        NSLog(@"picker = %@", picker);
    } origin:self.view];
}

-(void)birthdayChoose{
    [ActionSheetDatePicker showPickerWithTitle:@"birthday" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate czk_dateWithYear:2000 month:12 day:30] minimumDate:[NSDate czk_dateWithYear:1900 month:12 day:30] maximumDate:[NSDate now] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSLog(@"%@",selectedDate);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [formatter  stringFromDate:(NSDate*)selectedDate];
        [self.birthday setTitle:dateStr forState:UIControlStateNormal];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
    } origin:self.view];
}

-(void)cancerTypeChoose{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in self.diseasesArray) {
        [array addObject:dict[@"name"]];
    }
    NSArray *initialSelection = @[@0];
    [ActionSheetMultipleStringPicker showPickerWithTitle:@"选择病种"
                                                    rows:@[array]
                                        initialSelection:initialSelection
                                               doneBlock:^(ActionSheetMultipleStringPicker *picker,
                                                           NSArray *selectedIndexes,
                                                           NSArray *selectedValues) {
        [self.cancerType setTitle:selectedValues[0] forState:UIControlStateNormal];
        self->diseasesIndex = [selectedIndexes[0] intValue];
    }cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
        NSLog(@"picker = %@", picker);} origin:self.view];
}

-(void)hospitalChoose{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in self.hospitalArray) {
        [array addObject:dict[@"name"]];
    }
    NSArray *initialSelection = @[@0];
    [ActionSheetMultipleStringPicker showPickerWithTitle:@"选择医院"
                                                    rows:@[array]
                                        initialSelection:initialSelection
                                               doneBlock:^(ActionSheetMultipleStringPicker *picker,
                                                           NSArray *selectedIndexes,
                                                           NSArray *selectedValues) {
        [self.hospital setTitle:selectedValues[0] forState:UIControlStateNormal];
        self->hospitalIndex = [selectedIndexes[0] intValue];
    }cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
        NSLog(@"picker = %@", picker);} origin:self.view];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
#pragma mark -

@end
