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
#import "IQKeyboardManager.h"
#import "NetworkParser.h"

#import "MyNavViewController.h"
#import "OrderMapViewController.h"
#import "MyPopupDialog.h"
#import "BreakView.h"

#import <KSCrash/KSCrash.h> // TODO: Remove this
#import <KSCrash/KSCrashInstallation+Alert.h>
#import <KSCrash/KSCrashInstallationStandard.h>
#import <KSCrash/KSCrashInstallationQuincyHockey.h>
#import <KSCrash/KSCrashInstallationEmail.h>
#import <KSCrash/KSCrashInstallationVictory.h>


// AIzaSyD6411yESCnRFYvjLbE4IvoagnN4j4t61s
@interface AppDelegate ()

@property (nonatomic, strong) MyPopupDialog* dialog_BreakTime;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self startLocationService];
    [CGlobal initGlobal];
    [self initData];
    EnvVar*env = [CGlobal sharedId].env;
    env.lastLogin = -1;
    env.quote = true;
    g_isii = false;
    
//    [self installCrashHandler];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [GMSServices provideAPIKey:@"AIzaSyAPN34OpSc-JfgEi_bCO08qmd1GOTTmeF0"];
    
    return YES;
}
-(void)startOrStopTraccar{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    // Initialize device identifier
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults stringForKey:@"device_id_preference"]) {
        srandomdev();
        NSString *identifier = [NSString stringWithFormat:@"%ld", (random() % 900000) + 100000];
        [userDefaults setValue:identifier forKey:@"device_id_preference"];
    }
    
    [userDefaults setValue:@"192.168.1.106" forKey:@"server_address_preference"];
    
    
    
    [userDefaults setInteger:100 forKey:@"server_port_preference"];
    [userDefaults setInteger:1 forKey:@"frequency_preference"];
    [userDefaults setInteger:0 forKey:@"angle_preference"];
    [userDefaults setInteger:0 forKey:@"distance_preference"];
    
    NSUserDefaults *defaults = userDefaults;
    BOOL status = [defaults boolForKey:@"service_status_preference"];
    if (status) {
        
        NSString *validHost = @"^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$";
        NSPredicate *hostPredicate  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validHost];
        
        NSString *address = [defaults stringForKey:@"server_address_preference"];
        long port = [defaults integerForKey:@"server_port_preference"];
        long frequency = [defaults integerForKey:@"frequency_preference"];
        
        if (![hostPredicate evaluateWithObject:address]) {
            NSLog(@"Invalid server address");
        } else if (port <= 0 || port > 65535) {
            NSLog(@"Invalid server port");
        } else if (frequency <= 0) {
            NSLog(@"Invalid frequency value");
        } else {
            self.trackingController = [[TCTrackingController alloc] init];
            [self.trackingController start];
        }
        
    } else if (!status && self.trackingController) {
        
        [self.trackingController stop];
        self.trackingController = nil;
        
    }
    // Initialize other defaults
}
-(void)initData{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    
    // Register for battery level and state change notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryLevelChanged:)
                                                 name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryStateChanged:)
                                                 name:UIDeviceBatteryStateDidChangeNotification object:nil];
}
- (void)batteryLevelChanged:(NSNotification *)notification
{
    [self updateBatteryLevel];
}

- (void)batteryStateChanged:(NSNotification *)notification
{
    [self updateBatteryLevel];
    [self updateBatteryState];
}
- (void)updateBatteryLevel
{
    float batteryLevel = [UIDevice currentDevice].batteryLevel;
    if (batteryLevel < 0.0) {
        // -1.0 means battery state is UIDeviceBatteryStateUnknown
        g_batteryLevel = @"Unknown";
    }
    else {
        static NSNumberFormatter *numberFormatter = nil;
        if (numberFormatter == nil) {
            numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
            [numberFormatter setMaximumFractionDigits:1];
        }
        
        NSNumber *levelObj = [NSNumber numberWithFloat:batteryLevel];
        g_batteryLevel = [numberFormatter stringFromNumber:levelObj];
    }
}

- (void)updateBatteryState
{
//    NSArray *batteryStateCells = @[self.unknownCell, self.unpluggedCell, self.chargingCell, self.fullCell];
//    
//    UIDeviceBatteryState currentState = [UIDevice currentDevice].batteryState;
//    
//    for (int i = 0; i < [batteryStateCells count]; i++) {
//        UITableViewCell *cell = (UITableViewCell *) batteryStateCells[i];
//        
//        if (i + UIDeviceBatteryStateUnknown == currentState) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//    }
}
- (void)keyboardOnScreen:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    // UIKeyboardFrameEndUserInfoKey UIKeyboardFrameBeginUserInfoKey
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    g_keyboardRect = keyboardFrameBeginRect;
    
    NSNotificationCenter *center;
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
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
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
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
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Change service status
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:false forKey:@"service_status_preference"];
    
    EnvVar* env = [CGlobal sharedId].env;
    env.lastLogin = -1;
    
    [self stopTrackTimer];
    [self saveContext];
}

#pragma mark - Core Data

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TraccarClient" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TraccarClient.sqlite"];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil]) {
        NSLog(@"Error in persistentStoreCoordinator");
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:nil]) {
            NSLog(@"Error in saveContext");
        }
    }
}

-(void)startLocationService{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        [CGlobal AlertMessage:@"Location services were previously denied by the you. Please enable location services for this app in settings." Title:@"Location services"];
        
        return;
    }
    
    
    // Request "when in use" location service authorization.
    // If authorization has been denied previously, we can display an alert if the user has denied location services previously.
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        
        [CGlobal AlertMessage:@"Location services were previously denied by the you. Please enable location services for this app in settings." Title:@"Location services"];
        
        return;
    }
    
    // Start updating locations.
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}
-(void)runnable1:(id)sender{
    //NSLog(@"Speed Limit View Runnable %ld",self.tick);
    //self.tick = self.tick+1;
    
    //    [CGlobal AlertMessage:@"Break Time Please stop at the nearest Truck Stop/Rest Area" Title:@"Break Time"];
    g_breakShowing = true;
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [delegate.warningSound stop];
    delegate.warningSound = nil;
    
    
    
    MyPopupDialog* dialog = [[MyPopupDialog alloc] init];
    BreakView* view = [[NSBundle mainBundle] loadNibNamed:@"PromptDialog" owner:self options:nil][1];
    
    [dialog setup:view backgroundDismiss:false backgroundColor:[UIColor darkGrayColor]];
    
    [dialog showPopup:self.window];
    self.dialog_BreakTime = dialog;
    
    view.breakSound = [delegate loadBeepSound:@"breaktime"];
    [view.breakSound play];
    [view setData:@{@"vc":self}];
    
    [self.timer invalidate];
    self.timer = nil;
    
    if (g_isii) {
        NSTimeInterval intval2hr = 15;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:intval2hr target:self selector:@selector(runnable2:) userInfo:nil repeats:false];
    }
}
-(void)runnable2:(id)sender{
    g_isii = false;
    [self.timer invalidate];
    self.timer = nil;
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    g_lastLocation = newLocation;
    //    NSLog(@"%.6f %.6f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    EnvVar* env = [CGlobal sharedId].env;
    
    double gpsSpeed = newLocation.speed;
    if (g_isii) {
        gpsSpeed = arc4random_uniform(100);
        gpsSpeed = 80 + gpsSpeed;
    }
    
    double kph = gpsSpeed*3.6;
    if (kph>0) {
        g_vehiclespeed = [NSString stringWithFormat:@"%.1f",kph];
    }else{
        g_vehiclespeed = @"0.0";
    }
    
    // check if break time message shows
    if (env.lastLogin>0 && !g_breakShowing) {
        // signed
        
        NSMutableDictionary*speedParam = [[NSMutableDictionary alloc] init];
        speedParam[@"speed"] = [NSString stringWithFormat:@"%.1f",kph];
        speedParam[@"speed_limit"] = [NSString stringWithFormat:@"%.1f",g_limitSpeed_kph];
        
        if (kph>9) {
            // kph>g_limitSpeed_kph
            // kph>1
            
            // notify about this
            UIViewController *vc = [self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
            if ([vc isKindOfClass:[OrderMapViewController class]]) {
                OrderMapViewController*ovc = (OrderMapViewController*)vc;
                [ovc setSpeedData:speedParam];
            }else if ([vc isKindOfClass:[BasicViewController class]]) {
                BasicViewController*bvc = (BasicViewController*)vc;
                [bvc showSpeedView:speedParam];
            }
            if (kph>g_limitSpeed_kph) {
                // play sound
                if(_warningSound == nil){
                    _warningSound = [self loadBeepSound:@"speedlimit"];
                }
                [_warningSound play];
            }else{
                // stop sound
                [_warningSound stop];
            }
            
            if (self.timer == nil) {                
                NSTimeInterval intval2hr = 3600*2;
                intval2hr = 300;
                if (g_isii) {
                    intval2hr = 300;
                }
                self.timer = [NSTimer scheduledTimerWithTimeInterval:intval2hr target:self selector:@selector(runnable1:) userInfo:nil repeats:false];
            }
            
            
        }else{
            // notify about this
            UIViewController *vc = [self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
            if ([vc isKindOfClass:[OrderMapViewController class]]) {
                OrderMapViewController*ovc = (OrderMapViewController*)vc;
                [ovc setSpeedData:speedParam];
            }else if ([vc isKindOfClass:[BasicViewController class]]) {
                BasicViewController*bvc = (BasicViewController*)vc;
                [bvc showSpeedView:nil];
            }
            
            if(_warningSound != nil){
                [_warningSound stop];
            }
            
            if (self.timer!=nil) {
                [self.timer invalidate];
                self.timer = nil;
            }
            
        }
        
    }else{
        
        if (kph>1) {
            // moving
        }else{
            // almost stopped
            if (g_breakShowing) {
                
                BreakView* view = (BreakView*)self.dialog_BreakTime.contentview;
                [view.breakSound stop];
                
                [self.dialog_BreakTime dismissPopup];
                g_breakShowing = false;
            }
        }
        
    }
    
    
}
-(AVAudioPlayer*)loadBeepSound:(NSString*)filename{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    AVAudioPlayer* avplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    
    avplayer.numberOfLoops = -1;
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [avplayer prepareToPlay];
    }
    
    return avplayer;
}
- (UIViewController *)visibleViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil)
    {
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController*nav = (UINavigationController*)rootViewController;
            if (nav.viewControllers.count>0) {
                NSInteger index = nav.viewControllers.count - 1;
                UIViewController*vc = nav.viewControllers[index];
                return vc;
            }
        }
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [self visibleViewController:lastViewController];
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController.presentedViewController;
        UIViewController *selectedViewController = tabBarController.selectedViewController;
        
        return [self visibleViewController:selectedViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    
    return [self visibleViewController:presentedViewController];
}
-(void)stopTrackTimer{
    if (self.trackTimer!=nil) {
        [self.trackTimer invalidate];
        self.trackTimer = nil;
    }
}
-(void)startTrackTimer{
    [self stopTrackTimer];
    [self runnableTrack];
    self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(runnableTrack) userInfo:nil repeats:true];
}
-(void)runnableTrack{
    if (g_lastLocation==nil) {
        return;
    }
    
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    if (env.lastLogin <=0) {
        return;
    }
    if (env.mode == c_PERSONAL) {
        if ([env.user_id length]>0) {
            params[@"employer_id"] = env.user_id;
            NSLog(@"tracking personal %@",env.user_id);
        }else{
            NSLog(@"tracking personal return");
            return;
        }
        
        
    }else if(env.mode == c_CORPERATION){
        if ([env.corporate_user_id length]>0) {
            params[@"employer_id"] = env.corporate_user_id;
            NSLog(@"tracking corporation %@",env.corporate_user_id);
        }else{
            NSLog(@"tracking corporation return");
            return;
        }
    }else{
        NSLog(@"tracking non personal corporation");
        return;
    }
    
    
    if (self.lastTrackDate != nil) {
        NSDate* date = [NSDate date];
        NSTimeInterval intervals =  [date timeIntervalSinceDate:self.lastTrackDate];
        if (intervals < 10) {
            NSLog(@"too shorts AppDelegate %f",intervals);
            return;
        }
    }
    params[@"orders"] = [CGlobal getOrderIds];
    
    params[@"timestamp"] = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    params[@"lat"] = [NSString stringWithFormat:@"%f",g_lastLocation.coordinate.latitude];
    params[@"lon"] = [NSString stringWithFormat:@"%f",g_lastLocation.coordinate.longitude];
    params[@"speed"] = [NSString stringWithFormat:@"%f",g_lastLocation.speed];
    params[@"battery"] = g_batteryLevel;
    
    self.lastTrackDate = [NSDate date];
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [manager ontemplateGeneralRequest2:params BasePath:@"" Path:@"/Track/send" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            NSLog(@"Send Track %f %f",g_lastLocation.coordinate.latitude,g_lastLocation.coordinate.longitude);
        }else{
            NSLog(@"Error");
        }
    } method:@"get"];
}
/**
 Configure Crash Report Handler
 **/
- (void) installCrashHandler
{
    KSCrashInstallation* installation = [self makeEmailInstallation];
    [installation install];
    [KSCrash sharedInstance].deleteBehaviorAfterSendAll = KSCDeleteNever; // TODO: Remove this
    
    
    // Send all outstanding reports. You can do this any time; it doesn't need
    // to happen right as the app launches. Advanced-Example shows how to defer
    // displaying the main view controller until crash reporting completes.
    [installation sendAllReportsWithCompletion:^(NSArray* reports, BOOL completed, NSError* error)
     {
         if(completed)
         {
             NSLog(@"Sent %d reports", (int)[reports count]);
         }
         else
         {
             NSLog(@"Failed to send reports: %@", error);
         }
     }];
}
- (KSCrashInstallation*) makeEmailInstallation
{
    NSString* emailAddress = @"huangbo1117@gmail.com";
    
    KSCrashInstallationEmail* email = [KSCrashInstallationEmail sharedInstance];
    email.recipients = @[emailAddress];
    email.subject = @"Crash Report";
    email.message = @"This is a crash report";
    email.filenameFmt = @"crash-report-%d.txt.gz";
    
    [email addConditionalAlertWithTitle:@"Crash Detected"
                                message:@"The app crashed last time it was launched. Send a crash report?"
                              yesAnswer:@"Sure!"
                               noAnswer:@"No thanks"];
    
    // Uncomment to send Apple style reports instead of JSON.
    [email setReportStyle:KSCrashEmailReportStyleApple useDefaultFilenameFormat:YES];
    
    return email;
}
@end
