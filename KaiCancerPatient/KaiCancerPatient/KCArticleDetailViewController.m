//
//  KCArticleDetailViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/7/1.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCArticleDetailViewController.h"

@interface KCArticleDetailViewController ()
@property (strong,nonatomic) UIImage* Cover;
@property (strong,nonatomic) UILabel* Title;
@property (strong,nonatomic) UITextView* Content;
@property (nonatomic,strong) KCArticleModel *Model;
@end

@implementation KCArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationController.navigationBar.hidden = YES;
}

-(instancetype)initWithModel:(KCArticleModel*) model{
    self.Model = model;
    return  self;
}

@end
