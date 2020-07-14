//
//  KCIMViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/23.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCIMViewController.h"

@interface KCIMViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *IMTable;
@property (strong,nonatomic) UILabel* unreadLabel;
@property (strong,nonatomic) UILabel* bigTitle;
@property (strong,nonatomic) UIButton* moreButton;
@end

@implementation KCIMViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}


@end
