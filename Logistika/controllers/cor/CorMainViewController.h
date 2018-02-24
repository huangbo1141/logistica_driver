//
//  CorMainViewController.h
//  Logistika
//
//  Created by BoHuang on 4/27/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "MenuViewController.h"
#import "ColoredButton.h"
#import "FontLabel.h"
#import "ColoredView.h"

@interface CorMainViewController : MenuViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet FontLabel *lblWaveCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblOrderCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblPickupCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblPickedCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblCompletedCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblHoldCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblReturnedCnt;

@property (weak, nonatomic) IBOutlet ColoredView *viewWave;
@property (weak, nonatomic) IBOutlet ColoredView *viewRoute;

@end
