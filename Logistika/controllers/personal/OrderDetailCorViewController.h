//
//  OrderDetailCorViewController.h
//  Logistika
//
//  Created by BoHuang on 4/24/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BasicViewController.h"
#import "ColoredView.h"
#import "ConfirmBarViewController.h"

@interface OrderDetailCorViewController : BasicViewController
@property (weak, nonatomic) IBOutlet UILabel *lbl_signature;
@property (weak, nonatomic) IBOutlet UILabel *lbl_signature_recv;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;


@property (weak, nonatomic) IBOutlet UILabel *lblTrackingNumber;

@property (weak, nonatomic) IBOutlet UILabel *lblOrderNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_BOTTOMSPACE;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_TH;
//
//@property (weak, nonatomic) IBOutlet UIView *viewHeader;
//
//@property (weak, nonatomic) IBOutlet UIView *viewHeader_CAMERA;
//@property (weak, nonatomic) IBOutlet UIView *viewHeader_ITEM;
//@property (weak, nonatomic) IBOutlet UIView *viewHeader_PACKAGE;


@property (weak, nonatomic) IBOutlet UIButton *btnAction1;
@property (weak, nonatomic) IBOutlet UIButton *btnAction2;
@property (weak, nonatomic) IBOutlet UIButton *btnAction3;


//@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

@property (weak, nonatomic) IBOutlet UILabel *lblAction1;
@property (weak, nonatomic) IBOutlet UILabel *lblAction2;
@property (weak, nonatomic) IBOutlet UILabel *lblAction3;

@property (weak, nonatomic) IBOutlet ColoredView *viewAction1;
@property (weak, nonatomic) IBOutlet ColoredView *viewAction2;
@property (weak, nonatomic) IBOutlet ColoredView *viewAction3;

@property (weak, nonatomic) IBOutlet UIView *viewBottomAction;

@property (assign, nonatomic) int type;
@property (strong, nonatomic) NSString* mode;

@property (weak, nonatomic) IBOutlet UIView *viewAdditional;
@property (weak, nonatomic) IBOutlet UIStackView *stackSignature;
@property (weak, nonatomic) IBOutlet UIStackView *stackPickup;
@property (weak, nonatomic) IBOutlet UIStackView *stackEta;


@property (weak, nonatomic) IBOutlet UITextField *txtWeight;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateWeight;

@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet UITextField *txtEta;
@property (weak, nonatomic) IBOutlet UITextField *txtFrieght;
@property (weak, nonatomic) IBOutlet UITextField *txtLoadType;
@property (weak, nonatomic) IBOutlet UILabel *lblScanCon;
@property (weak, nonatomic) IBOutlet UITextField *txtDateTime;
@property (weak, nonatomic) IBOutlet UITextField *txtVehicleNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtDriverID;
@property (weak, nonatomic) IBOutlet UITextField *txtDriverName;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignature;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignature_recv;
@end
