//
//  BreakView.m
//  Logistika
//
//  Created by BoHuang on 7/14/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BreakView.h"
#import "UIView+Property.h"
#import "CGlobal.h"

@implementation BreakView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setData:(NSDictionary *)data{
    [super setData:data];
    
    [self startLocationService];
}
- (IBAction)clickAction:(UIView*)sender {
    
    if ([self.xo isKindOfClass:[MyPopupDialog class]]) {
        MyPopupDialog* dialog = (MyPopupDialog*)self.xo;
        [dialog dismissPopup];
    }
    [_breakSound stop];
    g_breakShowing = false;
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
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    double gpsSpeed = newLocation.speed;
    
    double limit = 1;
    if (g_isii) {
        gpsSpeed = arc4random_uniform(100);
        limit = 20;
    }
    double kph = gpsSpeed*3.6;
    if (kph<limit) {
        // vehicle stopped
        [self clickAction:nil];
    }
}
@end
