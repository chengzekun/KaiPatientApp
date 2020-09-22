//
//  KCEducationViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/23.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCEducationViewController.h"
@interface KCEducationViewController ()

@property (weak, nonatomic) IBOutlet UIView *cancerIntroView;
@property (weak, nonatomic) IBOutlet UIView *careIntroView;
@property (weak, nonatomic) IBOutlet UIView *recureIntroView;
@property (weak, nonatomic) IBOutlet UIView *sectionView;
@end

@implementation KCEducationViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    
//    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    scrollView.delegate = self;
//    [scrollView addSubview:self.sectionView];
//    [self.view addSubview:scrollView];
//    [self.view addSubview:self.articleTableView];
}

//-(UITableView*)articleTableView{
//    if(_modelArray == nil){
//        _articleTableView = [[UITableView alloc] init];
//        _articleTableView.delegate = self;
//        _articleTableView.dataSource =self;
//    }
//    return _articleTableView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 0;
//}
//
//- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    return nil;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 2;;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return nil;;
//}
//
//-(void)refreshData{
//    return;
//}

@end
