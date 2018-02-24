//
//  MapViewController.h
//  Logistika
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapsViewController : UIViewController<GMSMapViewDelegate>


@property (nonatomic,strong) NSMutableArray* list_data;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (nonatomic,assign) int type;
@end
