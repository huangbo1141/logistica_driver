//
//  DoneViewController.h
//  Logistika
//
//  Created by BoHuang on 4/24/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColoredView.h"

@interface DoneViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_TH;

@property (weak, nonatomic) IBOutlet UIView *viewHeader;

@property (weak, nonatomic) IBOutlet UIView *viewHeader_CAMERA;
@property (weak, nonatomic) IBOutlet UIView *viewHeader_ITEM;
@property (weak, nonatomic) IBOutlet UIView *viewHeader_PACKAGE;


@property (weak, nonatomic) IBOutlet UIButton *btnReschedule;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelPick;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lblPickAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPickCity;
@property (weak, nonatomic) IBOutlet UILabel *lblPickState;
@property (weak, nonatomic) IBOutlet UILabel *lblPickPincode;
@property (weak, nonatomic) IBOutlet UILabel *lblPickPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblPickLandMark;
@property (weak, nonatomic) IBOutlet UILabel *lblPickInst;

@property (weak, nonatomic) IBOutlet UILabel *lblDestAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDestCity;
@property (weak, nonatomic) IBOutlet UILabel *lblDestState;
@property (weak, nonatomic) IBOutlet UILabel *lblDestPincode;
@property (weak, nonatomic) IBOutlet UILabel *lblDestPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblDestLandMark;
@property (weak, nonatomic) IBOutlet UILabel *lblDestInst;

@property (weak, nonatomic) IBOutlet UILabel *lblPickDate;
@property (weak, nonatomic) IBOutlet UILabel *lblServiceLevel;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentMethod;
@end
