//
//  AppDelegate.m
//  MSFMemoryDetectDemo
//
//  Created by apple on 2019/6/23.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

#import "MSFDetectManager.h"
#import "MSFCommonAlertBaseView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    RootViewController * rootVc = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:rootVc];
    self.window.rootViewController = nav;
    
    // 开启检测
    [[MSFDetectManager sharedManager] didDetectedTheMemFreeException:^(NSDictionary * _Nonnull exceptionInfo) {
        if (exceptionInfo.count > 0) {
            UITextView * textView = [[UITextView alloc] initWithFrame:CGRectZero];
            textView.text = exceptionInfo[@"info"];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(260, 200));
            }];
            
            [MSFCommonAlertBaseView showWithContentView:textView title:@"可能存在了内存泄漏，信息如下" subTitle:nil andButtonInfos:nil completionBlock:nil];
        }
    }];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
