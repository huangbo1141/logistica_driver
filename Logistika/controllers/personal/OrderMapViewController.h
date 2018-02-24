//
//  OrderMapViewController.h
//  Logistika
//
//  Created by BoHuang on 8/2/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderView.h"
#import <GoogleMaps/GoogleMaps.h>
#import "OrderResponse.h"

@interface OrderMapViewController : UIViewController<GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet BorderView *borderViewSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeedLimit;


@property (weak, nonatomic) IBOutlet UIView *viewCircle;

@property (nonatomic) IBInspectable NSInteger backMode;

-(void)setSpeedData:(NSDictionary*)data;
@property (weak, nonatomic) IBOutlet UIStackView *stackTool1;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons_bottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons_bottomHandleHeight;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UILabel *lblPickup1;
@property (weak, nonatomic) IBOutlet UILabel *lblPickup2;
@property (weak, nonatomic) IBOutlet UILabel *lblPickup3;
@property (weak, nonatomic) IBOutlet UILabel *lblPickup4;

@property (weak, nonatomic) IBOutlet UILabel *lblDes1;
@property (weak, nonatomic) IBOutlet UILabel *lblDes2;
@property (weak, nonatomic) IBOutlet UILabel *lblDes3;
@property (weak, nonatomic) IBOutlet UILabel *lblDes4;
@property (weak, nonatomic) IBOutlet UIButton *btnBottom;

@end
