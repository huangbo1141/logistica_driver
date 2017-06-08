//
//  AppDelegate.m
//  Logistika
//
//  Created by BoHuang on 4/18/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "AppDelegate.h"
#import "CGlobal.h"
#import "PersonalMainViewController.h"
#import <IQKeyboardManager.h>
#import "NetworkParser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [CGlobal initGlobal];
    EnvVar*env = [CGlobal sharedId].env;
    env.lastLogin = -1;
    env.quote = true;
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self defaultLogin];
    });
    
    return YES;
}
-(void)loadBasicData{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [manager ontemplateGeneralRequest2:data BasePath:BASE_DATA_URL Path:@"get_basic" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                if ([dict[@"result"] intValue] == 200) {
                    LoginResponse* data = [[LoginResponse alloc] initWithDictionary:dict];
                    if (data.area.count > 0) {
                        g_areaData = data;
                    }
                    
                }else{
                    [CGlobal AlertMessage:@"Fail" Title:nil];
                }
            }
        }else{
            NSLog(@"Error");
        }
        
    } method:@"POST"];
}
-(void)defaultLogin{
    
//    EnvVar* env = [CGlobal sharedId].env;
//    env.lastLogin = -1;
    
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController*vc = [ms instantiateViewControllerWithIdentifier:@"CLoginNav"] ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _window.rootViewController = vc;
    });
}
-(void)goHome:(UIViewController*)origin{
    EnvVar* env = [CGlobal sharedId].env;
    if (env.mode == c_PERSONAL || env.mode == c_GUEST ) {
        UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
        
        PersonalMainViewController*vc = [ms instantiateViewControllerWithIdentifier:@"PersonalMainViewController"] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            origin.navigationController.navigationBar.hidden = true;
            origin.navigationController.viewControllers = @[vc];
        });
    }else{
        UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Cor" bundle:nil];
        
        PersonalMainViewController*vc = [ms instantiateViewControllerWithIdentifier:@"CorMainViewController"] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            origin.navigationController.navigationBar.hidden = true;
            origin.navigationController.viewControllers = @[vc];
        });
    }
    
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
