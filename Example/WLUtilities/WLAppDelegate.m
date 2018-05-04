//
//  WLAppDelegate.m
//  WLUtilities
//
//  Created by nomeqc@gmail.com on 03/26/2018.
//  Copyright (c) 2018 nomeqc@gmail.com. All rights reserved.
//

#import "WLAppDelegate.h"
#import "WLLocationManager.h"

@implementation WLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

//    [[WLLocationManager sharedInstance] requestLocation];
    
    [[WLLocationManager sharedInstance] requestLocationWithUpdateHandler:^(NSArray<CLPlacemark *> *placemarks, CLLocationDegrees longitude, CLLocationDegrees latitude, NSError *error) {
        NSLog(@"经度:%lf,纬度:%lf",longitude,latitude);
    } deniedHandler:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置中开启定位" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL]];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:NULL];
    }];
    
//     NSURL *URL = [NSURL URLWithString:@"http://www.baidu.com"];
//    NSLog(@"abs string:%@",URL.absoluteString);
//    [[WLLocationManager sharedInstance] queryAuthorizationStatusWithDeniedHandler:^{
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置中开启定位" preferredStyle:UIAlertControllerStyleAlert];
//        [self.window.rootViewController presentViewController:alertController animated:YES completion:NULL];
//    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
