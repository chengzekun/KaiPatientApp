//
//  AppDelegate.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/5/12.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "AppDelegate.h"
#import "ZKNavigationViewController.h"
#import "KCLoginViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "KCLoginViewController.h"
//#import "PrePageController.h"
#import "CYLTabBarControllerConfig.h"
#import "KCUnRegisterViewController.h"
#import "KCRegisterViewController.h"

//目前计划 5天

//搞定通知和聊天 notification
//搞定预约
//搞定科普
//先上架一个
@interface AppDelegate ()<UNUserNotificationCenterDelegate,CYLTabBarControllerDelegate,UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self registerAPN];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootLoginViewController) name:@"CHANGE_ROOT_VIEWCONTROLLER_LOGIN" object:nil];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootViewController) name:@"CHANGE_ROOT_Vontroller" object:nil];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        // 1.注册UserNotification,以获取推送通知的权限
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
//        [application registerUserNotificationSettings:settings];
//        [application registerForRemoteNotifications];
    } else {
//        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeNewsstandContentAvailability | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"]){
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"]);
        self.window.rootViewController = tabBarControllerConfig.tabBarController;
    }else{
        KCUnRegisterViewController* LoginVC = [KCUnRegisterViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:LoginVC];
        self.window.rootViewController = nav;
    }
    return YES;
}
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
    KCUnRegisterViewController* LoginVC = [KCUnRegisterViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:LoginVC];
    self.window.rootViewController = nav;
}

- (void)changeRootViewController{
    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    self.window.rootViewController = tabBarControllerConfig.tabBarController;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    if (!deviceToken || ![deviceToken isKindOfClass:[NSData class]] || deviceToken.length==0) {
        return;
    }
    NSString *(^getDeviceToken)(void) = ^() {
        if (@available(iOS 13.0, *)) {
            const unsigned char *dataBuffer = (const unsigned char *)deviceToken.bytes;
            NSMutableString *myToken  = [NSMutableString stringWithCapacity:(deviceToken.length * 2)];
            for (int i = 0; i < deviceToken.length; i++) {
                [myToken appendFormat:@"%02x", dataBuffer[i]];
            }
            return (NSString *)[myToken copy];
        } else {
            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
            NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:characterSet];
            return [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    };
    NSString *myToken = getDeviceToken();
    [[NSUserDefaults standardUserDefaults]setObject:myToken forKey:@"DEVICE_TOKEN"];
    NSLog(@"mytoken:::::::%@",myToken);
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    
    NSLog(@"Regist fail%@",error);
}
@end
