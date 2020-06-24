//
//  ZKPageViewController.h
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/22.
//  Copyright © 2020 CZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKPageViewController;

@protocol ZKPageViewControllerDelegate <NSObject>
@required
- (void)ZKPageViewController:(ZKPageViewController *)vc didScrollToIndex:(NSInteger )index;
- (void)ZKPageViewController:(ZKPageViewController *)vc didClickButtonAtIndex:(NSInteger)index;
@end

@protocol ZKPageViewControllerDataSource <NSObject>
@required
- (NSArray *)ZKPageViewControllerTabsTitles;
- (UIViewController *)viewControllerAtIndex:(NSInteger  )index;
@end

@interface ZKPageViewController : UIPageViewController

- (instancetype)initWithDelegate:(id<ZKPageViewControllerDelegate>)delegate dataSource:(id<ZKPageViewControllerDataSource>)dataSource;
@property (nonatomic, weak)id<ZKPageViewControllerDelegate> delegate;
@property (nonatomic, weak)id<ZKPageViewControllerDataSource> dataSource;
@end


