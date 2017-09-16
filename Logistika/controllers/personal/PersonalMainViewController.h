//
//  PersonalMainViewController.h
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "ColoredView.h"
#import "FontLabel.h"

@interface PersonalMainViewController : MenuViewController
@property (weak, nonatomic) IBOutlet ColoredView *viewWave;
@property (weak, nonatomic) IBOutlet FontLabel *lblWaveCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblOrderCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblPickupCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblPickedCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblCompletedCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblHoldCnt;
@property (weak, nonatomic) IBOutlet FontLabel *lblReturnedCnt;


@end
