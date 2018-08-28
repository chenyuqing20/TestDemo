//
//  AppDelegate.m
//  test
//
//  Created by 盒子 on 2018/6/1.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "AppDelegate.h"
#import "BackgroundViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) BackgroundViewController *backgroundVC;  // 回到后台显示页
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [self loadInjectionIII];
    
    return YES;
}

- (void)showBackgroundVC {
    if (_backgroundVC == nil) {
        _backgroundVC = [[BackgroundViewController alloc] init];
        [_backgroundVC.view setFrame:self.window.bounds];
        [self.window addSubview:_backgroundVC.view];
    }
}
- (void)hideBackgroundVC {
    if (_backgroundVC) {
        [UIView animateWithDuration:0.6 animations:^{
            [self.backgroundVC.view setAlpha:0];
        } completion:^(BOOL finished) {
            [self.backgroundVC.view removeFromSuperview];
            self.backgroundVC = nil;
        }];
        
    }
}

#pragma mark -InjectionIII
- (void)loadInjectionIII {
#if DEBUG
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"];
    [bundle load];
#endif
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.scheme isEqualToString:@"jump"]) {
        return YES;
    }
    return false;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"APPWillResignActive");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"APPDidEnterBackground");
    [self showBackgroundVC];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    NSLog(@"APPDidFinishLaunching");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"APPWillEnterForeground");
    [self hideBackgroundVC];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"APPDidBecomeActive");
    [self hideBackgroundVC];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"APPWillTerminate");
}


@end
