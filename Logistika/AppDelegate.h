//
//  AppDelegate.h
//  Logistika
//
//  Created by BoHuang on 4/18/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
-(void)defaultLogin;
-(void)goHome:(UIViewController*)origin;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
-(void)startOrStopTraccar;

@property (strong,nonatomic) CLLocationManager *locationManager;
-(void)startLocationService;

@property (nonatomic, strong) AVAudioPlayer *warningSound;
-(AVAudioPlayer*)loadBeepSound:(NSString*)filename;

@property (nonatomic,strong) NSTimer* timer;
@end

