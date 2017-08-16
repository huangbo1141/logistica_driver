//
//  OrderMapViewController.m
//  Logistika
//
//  Created by BoHuang on 6/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "OrderMapViewController.h"
#import "CGlobal.h"
#import "InfoView1.h"
#import "InfoView2.h"
#import "OrderModel.h"
#import "NetworkParser.h"
#import "GooglePlaceResult.h"
#import "CGlobal.h"
#import "Step.h"

@interface OrderMapViewController ()
//@property (nonatomic,strong) NSMutableArray* pointLists;
@property (nonatomic,assign) CLLocationCoordinate2D sourcePosition;
@property (nonatomic,assign) CLLocationCoordinate2D destinationPosition;
@property (nonatomic,assign) CLLocationCoordinate2D packageLocaion;
@property (nonatomic,strong) NSString* sourcePosition_exists;
@property (nonatomic,strong) NSString* packageLocaion_exists;

@property (nonatomic,assign) CLLocationCoordinate2D userPosition;
@property (nonatomic,assign) CLLocationCoordinate2D pinSourcePosition;
@property (nonatomic,assign) CLLocationCoordinate2D pinDestiniationPosition;

@property (nonatomic,strong) GMSMarker* userMarker;
@property (nonatomic,strong) GMSMarker* sourceMarker;
@property (nonatomic,strong) GMSMarker* destinationMarker;

@property (nonatomic,strong) OrderModel* orderModel;
@property (nonatomic,strong) GMSPolyline* m_GMSPolyline;

@property (nonatomic,strong) GMSMarker* curMarker;
@end

@implementation OrderMapViewController

-(void)toggleBottomView{
    if (self.cons_bottomSpace.constant == 0) {
        self.cons_bottomSpace.constant = -100;
        [self.btnBottom setImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    }else{
        self.cons_bottomSpace.constant = 0;
        [self.btnBottom setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    }
    [self.viewBottom setNeedsUpdateConstraints];
    [self.viewBottom layoutIfNeeded];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lblSpeedLimit.text =    [NSString stringWithFormat:@"%.1f km",g_limitSpeed_kph];
    _lblSpeed.text =   @"0 km";
    _stackTool1.hidden = true;
    
    self.lblPickup1.text = g_addressModel.sourceAddress;
    self.lblPickup2.text = g_addressModel.sourceState;
    self.lblPickup3.text = g_addressModel.sourceCity;
    self.lblPickup4.text = g_addressModel.sourcePinCode;
    
    self.lblDes1.text = g_addressModel.desAddress;
    self.lblDes2.text = g_addressModel.desState;
    self.lblDes3.text = g_addressModel.desCity;
    self.lblDes4.text = g_addressModel.desPinCode;
    [self.btnBottom setImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    self.btnBottom.tintColor = [UIColor blackColor];
    
    self.cons_bottomSpace.constant = -100;
    
    self.mapView.camera = [[GMSCameraPosition alloc] initWithTarget:self.userPosition zoom:gms_camera_zoom bearing:0 viewingAngle:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        double lat = 35.89093;
        double lng = -106.326907;
        if (g_lastLocation !=nil) {
            lat = g_lastLocation.coordinate.latitude;
            lng = g_lastLocation.coordinate.longitude;
        }
        self.userPosition = CLLocationCoordinate2DMake(lat, lng);
        
        self.mapView.camera = [[GMSCameraPosition alloc] initWithTarget:_userPosition zoom:gms_camera_zoom bearing:0 viewingAngle:0];
        
        
        self.sourcePosition = CLLocationCoordinate2DMake(g_addressModel.sourceLat, g_addressModel.sourceLng);
        self.destinationPosition = CLLocationCoordinate2DMake(g_addressModel.desLat, g_addressModel.desLng);
        
        GMSMarker* marker = [[GMSMarker alloc] init];
        marker.title = @"source";
        marker.snippet = @"1";
        marker.position = self.sourcePosition;
        marker.icon = [CGlobal getImageForMap:@"source.png"];
        marker.map = self.mapView;
        marker.userData = @{@"type":@"1"};
        self.sourceMarker = marker;
        
        marker = [[GMSMarker alloc] init];
        marker.title = @"des";
        marker.snippet = @"1";
        marker.position = self.destinationPosition;
        marker.icon = [CGlobal getImageForMap:@"source.png"];
        marker.map = self.mapView;
        marker.userData = @{@"type":@"1"};
        self.destinationMarker = marker;
        
        self.mapView.delegate = self;
        
        [self drawPath:self.sourcePosition Dest:self.destinationPosition];
        
    });
}
- (IBAction)clickBottom:(id)sender {
    [self toggleBottomView];
}

-(void)drawPath:(CLLocationCoordinate2D)source Dest:(CLLocationCoordinate2D) dest{
    if (source.latitude == 0 && source.longitude == 0) {
        return;
    }
    if (dest.latitude == 0 && dest.longitude == 0) {
        return;
    }
    
    if (dest.latitude!=0) {
        NSString* path = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&mode=driving&sensor=false",source.latitude,source.longitude,dest.latitude,dest.longitude];
        [CGlobal showIndicator:self];
        NetworkParser* manager = [NetworkParser sharedManager];
        [manager ontemplateGeneralRequestWithRawUrl:nil Path:path withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            if (self.sourceMarker!=nil && self.destinationMarker!=nil) {
                //
                LoginResponse* resp = [[LoginResponse alloc] initWithDictionaryForRoute:dict];
//                resp.route.listStep
                GMSMutablePath* path = [GMSMutablePath path];
                NSArray* step = resp.route.listStep;
                for (int i=0; i<step.count; i++) {
                    Step* istep = step[i];
                    NSMutableArray*listPoints = istep.listPoints;
                    for (int j=0; j<listPoints.count; j++) {
                        NSValue* value = listPoints[j];
                        CGPoint pt = [value CGPointValue];
                        [path addCoordinate:CLLocationCoordinate2DMake(pt.x, pt.y)];
                    }
                }
                if(self.m_GMSPolyline!=nil){
                    _m_GMSPolyline.map = nil;
                    _m_GMSPolyline = nil;
                }
                
                GMSPolyline* myLine = [GMSPolyline polylineWithPath:path];
                myLine.strokeColor = COLOR_PRIMARY;
                myLine.strokeWidth = 2.0f;
                myLine.map = self.mapView;
                
                self.m_GMSPolyline = myLine;
                
                GMSCoordinateBounds*bound = [[GMSCoordinateBounds alloc] initWithPath:path];
                [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bound withPadding:30]];
            }
            [CGlobal stopIndicator:self];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = false;
    self.title = @"Route";
    
//    g_isii = !g_isii;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)mapView:(GMSMapView *)mapView didCloseInfoWindowOfMarker:(GMSMarker *)marker{
    NSLog(@"closed");
    _stackTool1.hidden = true;
}
-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    
    if([marker.userData isKindOfClass:[NSDictionary class]]){
        NSDictionary* userData = marker.userData;
        int type = [userData[@"type"] intValue];
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"UserInfoWindow" owner:self options:nil];
        
        _stackTool1.hidden = false;
        _curMarker = marker;
        if (type == 1) {
            InfoView1* view = array[0];
            NSString* title = marker.title;
            if ([title isEqualToString:@"source"]) {
                view.lblSource.text = @"Source Location";
                view.lblAddress.text = g_addressModel.sourceAddress;
                view.lblArea.text = g_addressModel.sourceArea;
                view.lblCity.text = g_addressModel.sourceCity;
            }else{
                view.lblSource.text = @"Destination Location";
                view.lblAddress.text = g_addressModel.desAddress;
                view.lblArea.text = g_addressModel.desArea;
                view.lblCity.text = g_addressModel.desCity;
            }
            return view;
        }else{
            InfoView2* view = array[1];
            NSString* snipt = marker.snippet;
            if ([snipt length]>0) {
                if ([g_state isEqualToString:@"0"]) {
                    view.lblStatus.text = @"Status: Cancel";
                }else if ([g_state isEqualToString:@"1"]) {
                    view.lblStatus.text = @"Status: Progressing";
                }else if ([g_state isEqualToString:@"2"]) {
                    view.lblStatus.text = @"Status: On the way for pickup";
                }else if ([g_state isEqualToString:@"3"]) {
                    view.lblStatus.text = @"Status: On the way to destination";
                }else if ([g_state isEqualToString:@"4"]) {
                    view.lblStatus.text = @"Status: Order Delivered";
                }else if ([g_state isEqualToString:@"5"]) {
                    view.lblStatus.text = @"Status: Order on hold";
                }else if ([g_state isEqualToString:@"6"]) {
                    view.lblStatus.text = @"Status: Returned Order";
                }
                
                [view setData:@{@"vc":self}];
                CGRect frame = view.frame;
                CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, [view getHeight]);
                view.frame = newFrame;
                
                return view;
            }
            
        }
    }
    return nil;
}
-(void)setSpeedData:(NSDictionary*)data{
    if (data!=nil) {
        
//        self.lblSpeed.text = [data[@"speed"] stringByAppendingString:@" km"];
//        self.lblSpeedLimit.text = [data[@"speed_limit"] stringByAppendingString:@" km"];
        
        self.lblSpeed.text = data[@"speed"];
        self.lblSpeedLimit.text = data[@"speed_limit"];
        
        double speed = [data[@"speed"] intValue];
        double speed_limit = [data[@"speed_limit"] intValue];
        if (speed>speed_limit) {
            self.lblSpeed.textColor = [UIColor redColor];
        }else{
            self.lblSpeed.textColor = [UIColor blackColor];
        }
        
    }else{
        self.lblSpeed.text = @"0";
    }
}
- (IBAction)clickDirection:(id)sender {
    if (self.curMarker==nil) {
        return;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString* str = [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=\(%f),\(%f)&directionsmode=driving",_curMarker.position.latitude,_curMarker.position.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        NSString* title = @"";
        if ([_curMarker.title isEqualToString:@"source"]) {
            title = g_addressModel.sourceAddress;
        }else{
            title = g_addressModel.desAddress;
        }
        
        CLLocationDistance regionDistance = 10000;
        MKCoordinateRegion regionSpan = MKCoordinateRegionMakeWithDistance(_curMarker.position, regionDistance, regionDistance);
        
        MKPlacemark* placemark =  [[MKPlacemark alloc] initWithCoordinate:_curMarker.position addressDictionary:nil];
        MKMapItem* mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        mapItem.name = title;
        [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsMapCenterKey:[NSValue valueWithMKCoordinate:regionSpan.center],MKLaunchOptionsMapSpanKey:[NSValue valueWithMKCoordinateSpan:regionSpan.span],MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    }
}
- (IBAction)clickGoogleMap:(id)sender {
    if (self.curMarker==nil) {
        return;
    }
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString* str = [NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&zoom=14&views=traffic",_curMarker.position.latitude,_curMarker.position.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        
    }else{
        NSString* title = @"";
        if ([_curMarker.title isEqualToString:@"source"]) {
            title = g_addressModel.sourceAddress;
        }else{
            title = g_addressModel.desAddress;
        }
        
        CLLocationDistance regionDistance = 10000;
        MKCoordinateRegion regionSpan = MKCoordinateRegionMakeWithDistance(_curMarker.position, regionDistance, regionDistance);
        
        MKPlacemark* placemark =  [[MKPlacemark alloc] initWithCoordinate:_curMarker.position addressDictionary:nil];
        MKMapItem* mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        mapItem.name = title;
        [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsMapCenterKey:[NSValue valueWithMKCoordinate:regionSpan.center],MKLaunchOptionsMapSpanKey:[NSValue valueWithMKCoordinateSpan:regionSpan.span]}];
        
        
    }
}


@end
