//
//  AppDelegate.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/5/12.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ZKNavigationViewController.h"
#import "KCLoginViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "KCLoginViewController.h"
#import "PreLoginViewController.h"
#import "CYLTabBarControllerConfig.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate,CYLTabBarControllerDelegate,UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self registerAPN];
    
    [SVProgressHUD setMaximumDismissTimeInterval:2];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootViewController) name:@"CHANGE_ROOT_VIEWCONTROLLER" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootLoginViewController) name:@"CHANGE_ROOT_VIEWCONTROLLER_LOGIN" object:nil];
//    [SVProgressHUD setMaximumDismissTimeInterval:2];
    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"ACCESS_KEY"]){
        self.window.rootViewController = tabBarControllerConfig.tabBarController;
    }else{
        PreLoginViewController *LoginVC = [[PreLoginViewController alloc] init];
        self.window.rootViewController = LoginVC;
    }
    return YES;
}


//#pragma mark - UISceneSession lifecycle
//
//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}



//
//-(void)changeRootViewController{
//    CYLTabBarController *tabBarVC = [[CYLTabBarController alloc]init];
//    tabBarVC.delegate = self;
//    ZKNavigationViewController *nav1 = [[ZKNavigationViewController alloc] initWithRootViewController:[KCMainViewController new]];
//    ZKNavigationViewController *nav2 = [[ZKNavigationViewController alloc] initWithRootViewController:[KCEducationViewController new]];
//    ZKNavigationViewController *nav3 = [[ZKNavigationViewController alloc] initWithRootViewController:[KCIMViewController new]];
//    ZKNavigationViewController *nav4 = [[ZKNavigationViewController alloc] initWithRootViewController:[KCNotificationViewController new]];
//    ZKNavigationViewController *nav5 = [[ZKNavigationViewController alloc] initWithRootViewController:[KCAccountViewController new]];
//    tabBarVC.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
//
//    [self customizeTabBarForController:tabBarVC];
//    tabBarVC.tabBar.barTintColor = BTTabBarColor;
//    tabBarVC.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
//    tabBarVC.selectedIndex = 1;
//    self.window.rootViewController = tabBarVC;
//}



- (void)registerAPN {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//          [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSInteger index = 0;
    if ([[viewController.class description] isEqualToString:@"KCMainViewController"]) {
        index = 0;
    }else if ([[viewController.class description] isEqualToString:@"KCEducationViewController"]) {
        index = 1;
    }else if ([[viewController.class description] isEqualToString:@"KCIMViewController"]) {
        index = 2;
    }else if ([[viewController.class description] isEqualToString:@"KCNotificationViewController"]) {
        index = 3;
    }else if([[viewController.class description] isEqualToString:@"KCAccountViewController"]){
        index = 4;
    }
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    CYLTabBarController* tab =  [CYLTabBarController cyl_tabBarController];
    tab.selectedIndex = 0;
    self.cyl_tabBarController.selectedIndex = 0;
    NSLog(@"ooooooo");
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"notification.userInfo = %@",notification.userInfo);
    CYLTabBarController* tab =  [CYLTabBarController cyl_tabBarController];
    tab.selectedIndex = 0;
}

- (void)changeRootLoginViewController{
    ZKNavigationViewController* vc = [[UINavigationController alloc]initWithRootViewController:[KCLoginViewController new]];
    self.window.rootViewController = vc;
}
@end
