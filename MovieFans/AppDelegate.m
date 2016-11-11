//
//  AppDelegate.m
//  MovieFans
//
//  Created by hy on 16/1/7.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import "GuideView.h"
#import "HYOAuthModel.h"
#import "HYOAuthTool.h"
#import "MePageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bmob registerWithAppKey:@"2b2d654ab05cc285a0a670957015d8ea"];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //设置UIWindow的根视图控制器
    RootTabBarController * rootVC = [[RootTabBarController alloc]init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    //只运行一次
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *launched = [userDefaults objectForKey:@"launched"];
//    if (!launched)
//    {
//        [self guidePages];
//        launched = @"YES";
//        [userDefaults setObject:launched forKey:@"launched"];
//        [userDefaults synchronize];
//    }
    
    //一直运行
    [self guidePages];

//    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:APP_KEY];
    
    return YES;
}

- (void)guidePages
{
    //数据源
    NSArray *imageArray = @[ @"guide1.jpg", @"guide2.jpg", @"guide3.jpg", @"guide4.jpg" ];
    
    //  初始化方法1
    GuideView *guide = [[GuideView alloc] init];
    guide.imageDatas = imageArray;
    __weak typeof(GuideView) *weakMZ = guide;
    guide.buttonAction = ^{
        [UIView animateWithDuration:2.0f
                         animations:^{
                             weakMZ.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [weakMZ removeFromSuperview];
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"FirstReload" object:nil];
                         }];
    };
    [self.window addSubview:guide];

}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    HYOAuthModel *model = [HYOAuthModel new];
    model.access_token = [(WBAuthorizeResponse *)response accessToken];
    model.uid = [(WBAuthorizeResponse *)response userID];
        
    self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
    self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
    self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
    model.access_token = self.wbtoken;
    model.uid = self.wbCurrentUserID;
    [HYOAuthTool saveWith:model];
    if ([self.usersDelegate conformsToProtocol:@protocol(getUsersProfileProtocol)]) {
            [self.usersDelegate getUsersInfo];
        }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
