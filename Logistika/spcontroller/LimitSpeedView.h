//
//  LimitSpeedView.h
//  Logistika
//
//  Created by BoHuang on 7/12/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderView.h"
#import "MyBaseView.h"

IB_DESIGNABLE
@interface LimitSpeedView : MyBaseView
@property (weak, nonatomic) IBOutlet BorderView *borderViewSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeedLimit;


@property (weak, nonatomic) IBOutlet UIView *viewCircle;

@property (nonatomic) IBInspectable NSInteger backMode;

@end
