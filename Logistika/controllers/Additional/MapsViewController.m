//
//  MapsViewController.m
//  Logistika
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "MapsViewController.h"
#import "WaveOrderModel.h"
#import "WaveOrderCorModel.h"
#import "CGlobal.h"
#import "NetworkParser.h"
#import "Step.h"
#import "InfoView3.h"

@interface MapsViewController ()
@property (nonatomic,strong) NSMutableArray* markerPoints;
@property (nonatomic,assign) CLLocationCoordinate2D userPosition;
@property (nonatomic,assign) int index;
@property (nonatomic,strong) NSMutableArray* array_polyline;
@property (nonatomic,strong) NSMutableArray* array_marker;
@end

@implementation MapsViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = false;
    self.title = @"Wave Mapper";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Wave Mapper";
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (int i=0; i<self.list_data.count; i++) {
        id model = self.list_data[i];
        if ([model isKindOfClass:[WaveOrderModel class]]) {
            
            NSValue* val;
            WaveOrderModel*imodel = (WaveOrderModel*)model;
            if ([imodel.state isEqualToString:@"2"]) {
                CGPoint pt = CGPointMake(imodel.addressModel.sourceLat, imodel.addressModel.sourceLng);
                val = [NSValue valueWithCGPoint:pt];
            }else{
                CGPoint pt = CGPointMake(imodel.addressModel.desLat, imodel.addressModel.desLng);
                val = [NSValue valueWithCGPoint:pt];
            }
            
            [array addObject:val];
        }else if ([model isKindOfClass:[WaveOrderCorModel class]]) {
            WaveOrderCorModel*imodel = (WaveOrderCorModel*)model;
            NSValue* val;
            if ([imodel.state isEqualToString:@"2"]) {
                CGPoint pt = CGPointMake(imodel.addressModel.sourceLat, imodel.addressModel.sourceLng);
                val = [NSValue valueWithCGPoint:pt];
            }else{
                CGPoint pt = CGPointMake(imodel.addressModel.desLat, imodel.addressModel.desLng);
                val = [NSValue valueWithCGPoint:pt];
            }
            
            [array addObject:val];
        }
    }
    self.markerPoints = array;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        double lat = -34;
        double lng = 151;
//        if (g_lastLocation !=nil) {
//            lat = g_lastLocation.coordinate.latitude;
//            lng = g_lastLocation.coordinate.longitude;
//        }
        self.userPosition = CLLocationCoordinate2DMake(lat, lng);
        
        self.mapView.camera = [[GMSCameraPosition alloc] initWithTarget:_userPosition zoom:gms_camera_zoom bearing:0 viewingAngle:0];
        
        
        self.mapView.delegate = self;
        
        if (self.markerPoints.count>0) {
            [self draw];    
        }
        
        
    });
}
-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    
    if([marker.userData isKindOfClass:[NSMutableDictionary class]]){
        NSMutableDictionary* userData = marker.userData;
        int index = [userData[@"index"] intValue];
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"UserInfoWindow" owner:self options:nil];

        InfoView3* view = array[2];
        NSString* snipt = marker.snippet;
        
        [view setData:@{@"vc":self,@"index":userData[@"index"],@"wave_model":self.list_data[index]}];
        CGRect frame = view.frame;
        
        CGRect scRect = [[UIScreen mainScreen] bounds];
        scRect.size.width = MIN(scRect.size.width -32,388);
        
        CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, scRect.size.width, [view getHeight]);
        view.frame = newFrame;
        
        return view;
        
    }
    return nil;
}
-(void)draw{
    self.array_marker = [[NSMutableArray alloc] init];
    for (int i=0; i< self.markerPoints.count; i++) {
        NSValue* value = self.markerPoints[i];
        CGPoint pt = [value CGPointValue];
        GMSMarker* marker = [[GMSMarker alloc] init];
        if (self.type == 0) {
            WaveOrderModel*imodel = self.list_data[i];
            if ([imodel.state isEqualToString:@"2"]) {
                marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
            }else if ([imodel.state isEqualToString:@"5"]) {
                marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
            }else{
                marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
            }
        }else{
            WaveOrderCorModel*imodel = self.list_data[i];
            if ([imodel.state isEqualToString:@"2"]) {
                marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
            }else if ([imodel.state isEqualToString:@"5"]) {
                marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
            }else{
                marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
            }
        }
        NSString* number =[NSString stringWithFormat:@"Disp %d",i+1];
        marker.icon = [CGlobal getImageForDisp:number Image:marker.icon];
        NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
        data[@"index"] = [NSString stringWithFormat:@"%d",i];
        marker.userData = data;
        marker.position = CLLocationCoordinate2DMake(pt.x, pt.y);
        marker.map = self.mapView;
        
        [self.array_marker addObject:marker];
    }
    self.array_polyline = [[NSMutableArray alloc] init];
    [self recusive];
}
-(void)recusive{
    if (self.index < self.markerPoints.count - 1) {
        CGPoint origin = [self.markerPoints[self.index] CGPointValue];
        CGPoint dest = [self.markerPoints[self.index+1] CGPointValue];
        NSString* path = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&mode=driving&sensor=false",origin.x,origin.y,dest.x,dest.y];
        NetworkParser* manager = [NetworkParser sharedManager];
        [manager ontemplateGeneralRequestWithRawUrl:nil Path:path withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            if (dict!=nil) {
                //
                LoginResponse* resp = [[LoginResponse alloc] initWithDictionaryForRoute:dict];
                //                resp.route.listStep
                GMSMutablePath* path = [GMSMutablePath path];
                NSArray* step = resp.route.listStep;
                if (step.count>0) {
                    for (int i=0; i<step.count; i++) {
                        Step* istep = step[i];
                        NSMutableArray*listPoints = istep.listPoints;
                        for (int j=0; j<listPoints.count; j++) {
                            NSValue* value = listPoints[j];
                            CGPoint pt = [value CGPointValue];
                            [path addCoordinate:CLLocationCoordinate2DMake(pt.x, pt.y)];
                        }
                    }
                    
                    
                    GMSPolyline* myLine = [GMSPolyline polylineWithPath:path];
                    myLine.strokeColor = COLOR_PRIMARY;
                    myLine.strokeWidth = 2.0f;
                    myLine.map = self.mapView;
                    [self.array_polyline addObject:myLine];
                    
                    
                }
                
            }
            self.index++;
            [self recusive];
        }];
    }else{
        GMSCoordinateBounds*bound = nil;
        if (self.array_polyline.count>0) {
            for (int i=0; i<self.array_polyline.count; i++) {
                GMSPolyline* myLine = self.array_polyline[i];
                GMSPath* path = myLine.path;
                if (i==0) {
                    bound = [[GMSCoordinateBounds alloc] initWithPath:path];
                }else{
                    [bound includingPath:path];
                }
                
            }
            
            [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bound withPadding:30]];
        }else{
            if (self.markerPoints.count > 0) {
                CGPoint pt = [self.markerPoints[0] CGPointValue];
                GMSMutablePath* path = [GMSMutablePath path];
                [path addCoordinate:CLLocationCoordinate2DMake(pt.x, pt.y)];
                GMSCoordinateBounds*bound = [[GMSCoordinateBounds alloc] initWithPath:path];
                [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bound withPadding:30]];
            }
            
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickHub:(id)sender {
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    EnvVar* env = [CGlobal sharedId].env;
    if (g_mode == c_CORPERATION) {
        data[@"employer_id"] = env.corporate_user_id;
    }else{
        data[@"employer_id"] = env.user_id;
    }
    
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [manager ontemplateGeneralRequest2:data BasePath:BASE_DATA_URL Path:@"get_Contact_Details" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        @try {
            NSArray* array = dict;
            NSString*num = [NSString stringWithFormat:@"tel:%@",array[0][@"PhoneNumber"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        } @catch (NSException *exception) {
            NSLog(@"catch");
        }
        
    } method:@"POST"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:support_phone]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
