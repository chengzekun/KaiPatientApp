//
//  CYLTabBarControllerConfig.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/6/24.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "CYLTabBarControllerConfig.h"
#import "KCMainViewController.h"
#import "KCEducationViewController.h"
#import "KCIMViewController.h"
#import "KCNotificationViewController.h"
#import "KCAccountViewController.h"
#import "ZKNavigationViewController.h"

@implementation CYLTabBarControllerConfig

- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        ZKNavigationViewController *nav1 = [[ZKNavigationViewController alloc] initWithRootViewController:[KCMainViewController new]];
        ZKNavigationViewController *nav2 = [[ZKNavigationViewController alloc] initWithRootViewController:[KCEducationViewController new]];
        ZKNavigationViewController *nav3 = [[ZKNavigationViewController alloc] initWithRootViewController:[KCIMViewController new]];
        ZKNavigationViewController *nav4 = [[ZKNavigationViewController alloc] initWithRootViewController:[KCNotificationViewController new]];
        ZKNavigationViewController *nav5 = [[ZKNavigationViewController alloc] initWithRootViewController:[KCAccountViewController new]];
        NSArray * tabBarItemsAttributes = [self tabBarItemsAttributes];
        NSArray * viewControllers = @[nav1,nav2,nav3,nav4,nav5];
        CYLTabBarController * tabBarController = [[CYLTabBarController alloc] init];
        tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
        tabBarController.viewControllers = viewControllers;
        _tabBarController = tabBarController;
          
    }
      
    return _tabBarController;
}
  
  
- (NSArray *)tabBarItemsAttributes {
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"Notification_nomal",
                            CYLTabBarItemSelectedImage : @"Notification_selected",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"科普教育",
                            CYLTabBarItemImage : @"Class_nomal",
                            CYLTabBarItemSelectedImage : @"Class_selected",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"在线咨询",
                            CYLTabBarItemImage : @"Account_nomal",
                            CYLTabBarItemSelectedImage : @"Account_selected",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"消息",
                            CYLTabBarItemImage : @"Account_nomal",
                            CYLTabBarItemSelectedImage : @"Account_selected",
                            };
    NSDictionary *dict5 = @{
                            CYLTabBarItemTitle : @"个人",
                            CYLTabBarItemImage : @"Account_nomal",
                            CYLTabBarItemSelectedImage : @"Account_selected",
                            };
    NSArray * tarBarItemsAttrbutes = @[dict1,dict2,dict3,dict4,dict5];
      
    return tarBarItemsAttrbutes;
}
  
  
/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
 */
+ (void)customizeTabBarAppearance {
      
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
      
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
      
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
      
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
      
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    [[UITabBar appearance] setSelectionIndicatorImage:[self imageFromColor:[UIColor colorWithRed:26 / 255.0 green:163 / 255.0 blue:133 / 255.0 alpha:1] forSize:CGSizeMake([UIScreen mainScreen].bounds.size.width / 5.0f, 49) withCornerRadius:0]];
      
    // set the bar background color
    // 设置背景图片
}
  
+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
      
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
      
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
      
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
      
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
      
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
      
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    return image;
}


@end
