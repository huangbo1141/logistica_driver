//
//  BreakView.h
//  Logistika
//
//  Created by BoHuang on 7/14/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBaseView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BreakView : MyBaseView<CLLocationManagerDelegate>

@property (nonatomic, strong) AVAudioPlayer *breakSound;
@property (strong,nonatomic) CLLocationManager *locationManager;
@end
