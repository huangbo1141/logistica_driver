//
//  OrderDetailViewController.h
//  Logistika
//
//  Created by BoHuang on 4/24/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BasicViewController.h"
#import "ColoredView.h"
#import "ConfirmBarViewController.h"

@interface OrderDetailViewController : BasicViewController<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UILabel *lblTrackingNumber;

@property (weak, nonatomic) IBOutlet UILabel *lblOrderNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_BOTTOMSPACE;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_TH;

@property (weak, nonatomic) IBOutlet UIView *viewHeader;

@property (weak, nonatomic) IBOutlet UIView *viewHeader_CAMERA;
@property (weak, nonatomic) IBOutlet UIView *viewHeader_ITEM;
@property (weak, nonatomic) IBOutlet UIView *viewHeader_PACKAGE;


@property (weak, nonatomic) IBOutlet UIButton *btnAction1;
@property (weak, nonatomic) IBOutlet UIButton *btnAction2;
@property (weak, nonatomic) IBOutlet UIButton *btnAction3;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lblPickAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPickCity;
@property (weak, nonatomic) IBOutlet UILabel *lblPickState;
@property (weak, nonatomic) IBOutlet UILabel *lblPickPincode;
@property (weak, nonatomic) IBOutlet UILabel *lblPickPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblPickLandMark;
@property (weak, nonatomic) IBOutlet UILabel *lblPickInst;

@property (weak, nonatomic) IBOutlet UILabel *lblPickName;

@property (weak, nonatomic) IBOutlet UILabel *lblDestName;

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

@property (weak, nonatomic) IBOutlet UILabel *lblAction1;
@property (weak, nonatomic) IBOutlet UILabel *lblAction2;
@property (weak, nonatomic) IBOutlet UILabel *lblAction3;

@property (weak, nonatomic) IBOutlet ColoredView *viewAction1;
@property (weak, nonatomic) IBOutlet ColoredView *viewAction2;
@property (weak, nonatomic) IBOutlet ColoredView *viewAction3;


@property (weak, nonatomic) IBOutlet UIView *viewBottomAction;

@property (assign, nonatomic) int type;

@property (weak, nonatomic) IBOutlet UIImageView *imgSignature;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignature_recv;

@property (weak, nonatomic) IBOutlet UITableView *tableView_Receiver;
@property (weak, nonatomic) IBOutlet UITableView *tableView_Shipper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_H_Shipper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_H_Receiver;

@property (strong, nonatomic) NSMutableArray* items_shipper;
@property (strong, nonatomic) NSMutableArray* items_receiver;

@property (weak, nonatomic) IBOutlet UIStackView* stackShipper;
@property (weak, nonatomic) IBOutlet UIStackView* stackReceiver;

@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) CGFloat cellHeight_doc;

@property (weak, nonatomic) IBOutlet UILabel *lbl_signature;
@property (weak, nonatomic) IBOutlet UILabel *lbl_signature_recv;
@property (weak, nonatomic) IBOutlet UIStackView *stackShipperDocument;
@property (weak, nonatomic) IBOutlet UIStackView *stackReceiverDocument;


@end
