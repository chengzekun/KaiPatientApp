//
//  KCIMViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/23.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCIMViewController.h"
#import "KCIMTableViewCell.h"
@interface KCIMViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *IMTable;
@property (strong,nonatomic) UILabel* unreadLabel;
@property (strong,nonatomic) UILabel* bigTitle;
@property (strong,nonatomic) UIButton* moreButton;
@end

@implementation KCIMViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
        self.navigationController.navigationBar.hidden = YES;
    self.unreadLabel = [[UILabel alloc] init];
    [_unreadLabel setFont:FontPingFangSCB(14)];
    [_unreadLabel setText:@"未读消息0则"];
    [self.view addSubview:_unreadLabel];
    [_unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(self.view).offset(0);
    }];
    self.bigTitle = [[UILabel alloc] init];
    [_bigTitle setText:@"消息"];
    [_bigTitle setFont:FontPingFangSCS(34)];
    [self.view addSubview:_bigTitle];
    [_bigTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(_unreadLabel.mas_bottom).offset(12);
    }];
    
    self.IMTable.emptyDataSetSource = self;
    self.IMTable.emptyDataSetDelegate = self;
    self.IMTable.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.view addSubview:self.IMTable];
    [_IMTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bigTitle.mas_bottom).offset(30);
        make.width.mas_equalTo(Main_Screen_Width);
        make.height.mas_equalTo(Main_Screen_Height);
    }];
//    [self refreshData];
}


- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -[UIImage imageNamed:@"Favourite-empty"].size.height/2-100;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableView*)IMTable{
    if(_IMTable == nil){
        _IMTable = [[UITableView alloc] init];
        _IMTable.delegate = self;
        _IMTable.dataSource = self;
        _IMTable.tableFooterView = [UIView new];
//        _IMTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        if(is_iPhone_X){
            _IMTable.contentInset = UIEdgeInsetsMake(10, 0, 96 + 69, 0);
        }else{
            _IMTable.contentInset = UIEdgeInsetsMake(10, 0, 250, 0);
        }
    }
    return _IMTable;
}

-(void)refreshData{

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KCIMTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    BTClassModel* model = self.modelArray[indexPath.row];
    if(!cell){
        NSBundle *bundle = [NSBundle mainBundle];//加载cell的xib 文件
        NSArray *objs = [bundle loadNibNamed:@"KCIMTableViewCell" owner:nil options:nil];
        cell = [objs lastObject];
//        cell.delegate = self;
        [cell updateWithName:@"王翠花" avater:@"nonono" message:@"我不想写了" emergency:NO lastTime:@"11:45"];
        return cell;
    }
//    cell.delegate = self;
    [cell updateWithName:@"王翠花" avater:@"nonono" message:@"我不想写了" emergency:NO lastTime:@"11:45"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"click");
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
    }];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}
@end
