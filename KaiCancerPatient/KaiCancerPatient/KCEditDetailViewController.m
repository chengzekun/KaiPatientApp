//
//  KCEditDetailViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/8/11.
//  Copyright © 2020 CZK. All rights reserved.
//
#import "KCEditDetailViewController.h"
#import "KCUserModel.h"
#import "ZKSheet.h"
@interface KCEditDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>
@property (strong,nonatomic)UIImageView* image;
//@property (strong,nonatomic)KCTextFeildTool *nameText;
@property (strong,nonatomic)NSDictionary *UserDict;
@property (strong,nonatomic)UITableView* tableView;
@property (strong,nonatomic)UIDatePicker* picker;
@property (strong,nonatomic)KCUserModel* userModel;
@property (strong,nonatomic)NSArray* diseasesArray;
@property (strong,nonatomic)UITextField* text;
@end
@implementation KCEditDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem * litem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(quit)];
    UIBarButtonItem * ritem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishEdit)];
    self.navigationItem.leftBarButtonItem = litem;
    self.navigationItem.rightBarButtonItem = ritem;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //设置imageView
    self.image = [UIImageView new];
    [self.image setImage:[UIImage imageNamed:@"camera"]];
    self.image.userInteractionEnabled = YES;
    self.image.layer.cornerRadius =self.image.frame.size.width/2;
    self.image.layer.masksToBounds = YES;
    UITapGestureRecognizer *imageTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
    [self.image addGestureRecognizer:imageTouch];
    //nameText
    self.text = [[UITextField alloc]init];
    //设置用户的模型
    NSDictionary* UserDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_DATA"];
    self.userModel = [KCUserModel mj_objectWithKeyValues:UserDict[@"data"]];
    //设置时间picker
    self.picker = [[UIDatePicker alloc] init];
    self.picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    self.picker.datePickerMode = UIDatePickerModeDate;
    [self.picker setDate:[NSDate date]];
    [self.picker setMaximumDate:[NSDate date]];
    [self.picker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self.view setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:self.tableView];
    //设置其他picker
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.diseasesArray = [[NSArray alloc] init];
    [self getInfo];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.text resignFirstResponder];
}
//获得疾病的列表
-(void)getInfo{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://sfp.dev.hins.work/api/v1/diseases" parameters:nil headers:nil
        progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary* dic = (NSMutableDictionary*)responseObject;
        NSLog(@"%@",dic);
        self.diseasesArray = dic[@"data"];
        
        NSLog(@"%@",self.diseasesArray[0][@"name"]);
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}
//懒加载定义
-(UITableView*)tableView{
    if(_tableView == nil){
         _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
         _tableView.backgroundColor = rgba(0, 0, 0,0);
         _tableView.delegate = self;
         _tableView.dataSource = self;
        _tableView.frame = self.view.frame;
         _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
         if(is_iPhone_X){
             _tableView.contentInset = UIEdgeInsetsMake(0, 0, 96 + 69, 0);
         }else{
             _tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
         }
     }
     return _tableView;
}
//页面离开和完成
-(void)finishEdit{
    
}

-(void)quit{
    [self.navigationController popViewControllerAnimated:YES];
}
//业务逻辑
//imageView选择图片
-(void)chooseImage{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.image.image = image;
    self.image.layer.cornerRadius =self.image.frame.size.width/2;
    self.image.layer.masksToBounds = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//DatePicker时间选择并更新参数
- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]].detailTextLabel setText:dateStr];
}
//tableView delegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] init];
    UILabel *titile = [[UILabel alloc]init];
    [titile setText:@"编辑资料"];
    [titile setFont:FontPingFangSCS(34)];
    [view addSubview:titile];
    [titile mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(view).offset(10);
       make.left.equalTo(view).offset(16);
    }];
    return view ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 180;
    }
    if(indexPath.row == 1){
        return 65;
    }else if(indexPath.row == 4){
        return 215;
    }else{
        return 50;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if(indexPath.row == 2){ //性别
         NSArray *rows = @[@[@"男", @"女"]];
         NSArray *initialSelection = @[@0];
         [ActionSheetMultipleStringPicker showPickerWithTitle:@"选择性别"
                                                    rows:rows
                                        initialSelection:initialSelection
                                               doneBlock:^(ActionSheetMultipleStringPicker *picker,
                                                NSArray *selectedIndexes,
                                                NSArray *selectedValues) {
                                                    NSLog(@"%@", selectedIndexes);
                                                    NSLog(@"%@", [selectedValues componentsJoinedByString:@", "]);
                                                    [[tableView cellForRowAtIndexPath:indexPath].detailTextLabel setText:[selectedValues componentsJoinedByString:@""]];
                                                }
                                            cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
                                                NSLog(@"picker = %@", picker);} origin:self.view];
    }else if(indexPath.row == 5){//病案号
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入病案号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];

        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"病案号";
            textField.keyboardType = UIKeyboardTypeDecimalPad;
//            textField.text = [NSString stringWithFormat:@"%.2lf",[goods.taxPremium doubleValue]];
        }];
        [self presentViewController:alertController animated:true completion:nil];
    }else if(indexPath.row == 6){//病种
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
                                                        NSLog(@"%@", selectedIndexes);
                                                        NSLog(@"%@", [selectedValues componentsJoinedByString:@", "]);
                                                        [[tableView cellForRowAtIndexPath:indexPath].detailTextLabel setText:[selectedValues componentsJoinedByString:@""]];
                                                    }
                                                cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
                                                    NSLog(@"picker = %@", picker);} origin:self.view];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:id];
    if(indexPath.row == 0){
        if(cell == nil){
            cell = [UITableViewCell new];
        }
        [cell addSubview:self.image];
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerX.equalTo(cell.mas_centerX);
            make.top.equalTo(cell.mas_top).offset(20);
             make.width.mas_equalTo(120);
             make.height.mas_equalTo(120);
         }];
    }else if(indexPath.row == 1){
        if(cell == nil){
            cell = [UITableViewCell new];
        }
        
        [self.text setText:[NSString stringWithFormat:@"%@%@",self.userModel.lastName,self.userModel.firstName]];
        [self.text setFont:FontPingFangSCR(23)];
        self.text.borderStyle = UITextBorderStyleNone;
        [cell addSubview:self.text];
        [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(16);
            make.centerY.equalTo(cell.mas_centerY);
        }];
    }else if(indexPath.row == 2){
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:id];
        }
        cell.textLabel.text = @"性别";
        cell.detailTextLabel.text = [self.userModel.gender isEqualToString:@"MALE"]?@"男":@"女";
    }else if(indexPath.row == 3){
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:id];
        }
        cell.textLabel.text = @"生日年月";
        cell.detailTextLabel.text = @"1990年13月47日";
        [cell.detailTextLabel setTextColor:UIColor.systemBlueColor];
    }else if(indexPath.row == 4){
        if(cell == nil){
            cell = [UITableViewCell new];
        }
        [cell addSubview:self.picker];
        [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left);
            make.top.equalTo(cell.mas_top);
            make.width.mas_equalTo(Main_Screen_Width);
        }];
    }else if(indexPath.row == 5){
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:id];
        }
        cell.textLabel.text = @"病案号";
        cell.detailTextLabel.text = @"请输入";
    }else if(indexPath.row == 6){
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:id];
        }
        cell.textLabel.text = @"病种";
        cell.detailTextLabel.text = @"未选择";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
