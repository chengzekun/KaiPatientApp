//
//  ZKPageViewController.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/22.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "ZKPageViewController.h"

#define ButtonHeight 36

@interface ZKPageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)NSArray *titles;

@property (nonatomic, strong)UIView *indicatorView;

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, assign)BOOL shouldAnimate;

@end

@implementation ZKPageViewController
@dynamic dataSource;
@dynamic delegate;
- (instancetype)initWithDelegate:(id<ZKPageViewControllerDelegate>)delegate dataSource:(id<ZKPageViewControllerDataSource>)dataSource {
    self = [self init];
    self.delegate = delegate;
    self.dataSource = dataSource;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self initLabel];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.scrollView];
    [self.backView addSubview:self.indicatorView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@ButtonHeight);
        
    }];
    
    self.shouldAnimate = YES;
    [self scrollViewDidScroll:self.scrollView];
    
}



- (void)didClickButton:(UIButton *)ZKn {
    
    self.shouldAnimate = NO;
    CGFloat indicatorViewDistance = (self.titles.count - 1)*Main_Screen_Width/self.titles.count;
    CGFloat ratio = indicatorViewDistance/(Main_Screen_Width * (self.titles.count - 1));
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorView.centerX =  ZKn.tag * (Main_Screen_Width/self.titles.count) + (Main_Screen_Width/self.titles.count/2);
    }];
    
    [self.scrollView setContentOffset:CGPointMake((self.indicatorView.centerX - (Main_Screen_Width/self.titles.count/2))/ratio, 0) animated:YES];
    
}


- (void)initLabel {
    CGFloat labelWidth = Main_Screen_Width/self.titles.count;
    
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZKButtonModel *model = [ZKButtonModel new];
        model.titleWhenNormal = self.titles[idx];
        model.titleFont = FontArialR(13);
        model.titleTextAlignment = NSTextAlignmentCenter;
        model.target = self;
        model.actionForTouchupInside = @selector(didClickButton:);
        model.titleColorWhenNormal = rgb(245, 166, 35);
        model.backgroundColor = rgb(254,246,216);
        
        UIButton *ZKn = [[UIButton alloc]initWithModel:model];
        
        ZKn.frame = CGRectMake(idx * labelWidth, 0, labelWidth, ButtonHeight);
        
        ZKn.tag = idx;
        
        
        [self.backView addSubview:ZKn];
        
        
    }];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    self.shouldAnimate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.shouldAnimate) {
        CGFloat indicatorViewDistance = (self.titles.count - 1)*Main_Screen_Width/self.titles.count;
        CGFloat ratio = indicatorViewDistance/(Main_Screen_Width * (self.titles.count - 1));
        self.indicatorView.centerX = ratio * scrollView.contentOffset.x + (Main_Screen_Width/self.titles.count/2);
    }
    
}


#pragma mark -- setter && getter

- (NSArray *)titles {
    
    
    if (_titles == nil) {
        if ([self.dataSource respondsToSelector:@selector(ZKPageViewControllerTabsTitles)]) {
            _titles = [self.dataSource  ZKPageViewControllerTabsTitles];
            
        }
    }
    return _titles;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 36)];
        _backView.backgroundColor = rgb(254,246,216);
    }
    return _backView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = CGRectMake(0, 35, Main_Screen_Width, self.view.height - 36);
    self.scrollView.contentSize = CGSizeMake(self.titles.count * Main_Screen_Width, self.view.height - 36);
    if (self.scrollView.subviews.count) {
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.dataSource respondsToSelector:@selector(viewControllerAtIndex:)]) {
            UIViewController *vc = [self.dataSource viewControllerAtIndex:idx];
            vc.view.frame = CGRectMake(idx * self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);
            [self addChildViewController:vc];
            [self.scrollView addSubview:vc.view];
        }
    }];
}

- (UIView *)indicatorView {
    
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc]init];
        _indicatorView.backgroundColor = rgb(245, 166, 35);
        _indicatorView.y = 34;
        _indicatorView.height = 2;
        _indicatorView.width = 0.53 * Main_Screen_Width/self.titles.count;
        _indicatorView.centerX = 0.235 * Main_Screen_Width/self.titles.count;
        
    }
    
    return _indicatorView;
    
}

- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 36, Main_Screen_Width, self.view.height - 36)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(Main_Screen_Width * self.titles.count, self.view.height - ButtonHeight);
    }
    
    return _scrollView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
