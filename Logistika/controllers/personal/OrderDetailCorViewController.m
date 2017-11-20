	//
//  OrderDetailCorViewController.m
//  Logistika
//
//  Created by BoHuang on 4/24/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "OrderDetailCorViewController.h"
#import "CGlobal.h"
#import "ReviewCameraTableViewCell.h"
#import "ReviewItemTableViewCell.h"
#import "ReviewPackageTableViewCell.h"

#import "NetworkParser.h"
#import "KMZViewController.h"
#import "BarcodeScanViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ShipperDocTableViewCell.h"
#import "PhotoUploadViewController.h"

@interface OrderDetailCorViewController ()
@property (nonatomic,strong) OrderModel* orderModel;
@property (nonatomic,copy) NSString* mTime;
@property (nonatomic,copy) NSString* mDate;

@property (nonatomic,copy) NSString* mFreight;
@property (nonatomic,copy) NSString* mLoadType;
@property (nonatomic,copy) NSString* mConsignment;
@property (nonatomic,copy) NSString* mConsignment_receiver;
@property (nonatomic,copy) NSString* mVehicle;
@property (nonatomic,copy) NSString* mDriverId;
@property (nonatomic,copy) NSString* mDriverName;
//@property (nonatomic,strong) UIImage* mSignature;
//@property (nonatomic,strong) UIImage* mReceiverSignature;

@property (nonatomic,copy) NSString* mETA;
@property (nonatomic,copy) NSString* mWeight;

@property (nonatomic,strong) NSMutableArray* consigments;
@property (nonatomic,strong) NSMutableArray* consigments_receiver;
@end

@implementation OrderDetailCorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.consigments = [[NSMutableArray alloc] init];
    self.consigments_receiver = [[NSMutableArray alloc] init];
    
    if (g_isii) {
        for (int i=0; i<10; i++) {
            [self.consigments_receiver addObject:@"1122334455"];
        }
        
    }
    _mConsignment_receiver = @"";
    _mConsignment = @"";
    [self initView];
    [self initTitle];
    EnvVar* env = [CGlobal sharedId].env;
    [self showAddressDetails];
    self.lblPickDate.text = [NSString stringWithFormat:@"Pick up on: %@%@",g_dateModel.date,g_dateModel.time];
    
    
    _lblOrderNumber.text = env.order_id;
    _lblTrackingNumber.text = g_track_id;
    
    NSArray* fields = @[self.txtFrieght,self.txtLoadType,self.txtDateTime,self.txtVehicleNumber,self.txtDriverID,self.txtDriverName];
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectMake(0, 0, (screenRect.size.width-16)*0.5, 24);
    for (int i=0; i<fields.count; i++) {
        BorderTextField*field = fields[i];
        [field addBotomLayer:frame];
    }
    
    fields = @[self.txtWeight,self.txtEta];
    frame = CGRectMake(0, 0, (screenRect.size.width-16)*0.33, 24);
    for (int i=0; i<fields.count; i++) {
        BorderTextField*field = fields[i];
        [field addBotomLayer:frame];
    }
    
    //self.txtWeight,self.txtEta
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = false;
    if (self.imgSignature.image!=nil) {
        _lbl_signature.hidden = true;
    }
    if (self.imgSignature_recv.image!=nil) {
        _lbl_signature_recv.hidden = true;
    }
    [self.tableView_Receiver reloadData];
    [self.tableView_Shipper reloadData];
    [self.tableView_Consigment reloadData];
    [self.tableView_Consigment_Receiver reloadData];
}
-(void)initTitle{
    if (self.type == g_ORDER) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"orders_for_pickup" value:@"" table:nil];
        self.title = title;
    }else if (self.type == g_PICKUP) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"picked_up" value:@"" table:nil];
        self.title = title;
        
        self.viewAction1.hidden = false;
        self.viewAction2.hidden = false;
        self.viewAction3.hidden = true;
        
        self.lblAction1.text = @"Completed";
        self.lblAction2.text = @"On Hold";
        
        self.btnAction1.tag = 202;
        self.btnAction2.tag = 204;
        
        [self showCarriers];
    }else if (self.type == g_COMPLETE) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"completed" value:@"" table:nil];
        self.title = title;
        
        self.viewBottomAction.hidden = true;
        _constraint_BOTTOMSPACE.constant = 0;
        
        [self showCarriers];
    }else if (self.type == g_ONHOLD) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"on_hold" value:@"" table:nil];
        self.title = title;
        
        self.lblAction1.text = @"Delivery";
        
        [self showCarriers];
    }else if (self.type == g_RETURN) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"returned" value:@"" table:nil];
        self.title = title;
        
        [self showCarriers];
    }
    
}
-(void)handleGesture:(UITapGestureRecognizer*)gesture{
    UIView*view = gesture.view;
    if (view!=nil) {
        int tag = (int)view.tag;
        switch (tag) {
            case 200:
            {
                
                break;
            }
            case 201:
            {
                // signature
                UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
                KMZViewController *vc = [ms instantiateViewControllerWithIdentifier:@"KMZViewController"];
                vc.imageView = self.imgSignature;
                [self.navigationController pushViewController:vc animated:true];
                
                break;
            }
            case 202:
            {
                // signature rec
                UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
                KMZViewController *vc = [ms instantiateViewControllerWithIdentifier:@"KMZViewController"];
                vc.imageView = self.imgSignature_recv;
                [self.navigationController pushViewController:vc animated:true];
                
                break;
            }
            default:
            {
                break;
            }
        }
    }
}
- (IBAction)clickAddScan:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    BarcodeScanViewController*vc = [ms instantiateViewControllerWithIdentifier:@"BarcodeScanViewController"];
    vc.consigment = self.consigments;
    [self.navigationController pushViewController:vc animated:true];
}
- (IBAction)clickAddScanReceiver:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    BarcodeScanViewController*vc = [ms instantiateViewControllerWithIdentifier:@"BarcodeScanViewController"];
    vc.consigment = self.consigments_receiver;
    [self.navigationController pushViewController:vc animated:true];
}
-(void)initView{
    
    self.btnAction1.tag = 200;
    self.cellHeight = 60;
    UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [_imgSignature addGestureRecognizer:gesture];
    _imgSignature.tag = 201;
    
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [_imgSignature_recv addGestureRecognizer:gesture];
    _imgSignature_recv.tag = 202;
    
    _imgSignature.userInteractionEnabled = true;
    _imgSignature_recv.userInteractionEnabled = true;
    
    _btnScan.hidden = true;
    _btnScan_Receiver.hidden = true;
    if (self.type == g_ORDER) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"orders_for_pickup" value:@"" table:nil];
        self.title = title;
        
        
        _stackSignature.hidden = false;
        _stackPickup.hidden = true;
        _btnScan.hidden =false;
    }else if (self.type == g_PICKUP) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"picked_up" value:@"" table:nil];
        self.title = title;
        
        _stackSignature.hidden = true;
        _stackPickup.hidden = false;
        
        _txtLoadType.enabled = false;
        _txtDriverID.enabled = false;
        _txtDriverName.enabled = false;
        _imgSignature.userInteractionEnabled = false;
        _txtVehicleNumber.enabled = false;
        _txtDateTime.enabled = false;
        
        _btnScan_Receiver.hidden = false;
    }else {
        _txtLoadType.enabled = false;
        _btnScan.enabled = false;
        _txtDriverID.enabled = false;
        _txtDriverName.enabled = false;
        _imgSignature.userInteractionEnabled = false;
        _txtVehicleNumber.enabled = false;
        
        _stackSignature.hidden = true;
        _stackPickup.hidden = true;
        if (self.type == g_ONHOLD) {
            _stackPickup.hidden = false;
            _stackEta.hidden = true;
            _btnScan_Receiver.hidden = false;
        }
    }
    self.stackShipperDocument.hidden = self.stackSignature.hidden;
    
    [self.btnAction1 addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAction2 addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAction3 addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    _mDate = [self getDate];
    _mTime = [self getTime];
    
    _txtDateTime.text = [NSString stringWithFormat:@"%@ %@",_mDate,_mTime];
    
    [self.btnUpdate addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    self.btnUpdate.tag = 300;
    
    [self.btnUpdateWeight addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    self.btnUpdateWeight.tag = 301;
    
    NSUInteger found = [c_freights indexOfObject:self.mode];
    if (found!=NSNotFound) {
//        _txtFrieght.text = [c_freights[found] uppercaseString];
    }
    _txtFrieght.text = @"Consignment";
    _txtFrieght.enabled = false;
    
    UINib* nib = [UINib nibWithNibName:@"ShipperDocTableViewCell" bundle:nil];
    [self.tableView_Shipper registerNib:nib forCellReuseIdentifier:@"cell"];
    
    nib = [UINib nibWithNibName:@"ShipperDocTableViewCell" bundle:nil];
    [self.tableView_Receiver registerNib:nib forCellReuseIdentifier:@"cell"];
    
    nib = [UINib nibWithNibName:@"ShipperDocTableViewCell" bundle:nil];
    [self.tableView_Consigment registerNib:nib forCellReuseIdentifier:@"cell"];
    
    nib = [UINib nibWithNibName:@"ShipperDocTableViewCell" bundle:nil];
    [self.tableView_Consigment_Receiver registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.tableView_Receiver.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView_Shipper.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView_Consigment.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView_Consigment_Receiver.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView_Receiver.delegate = self;
    self.tableView_Receiver.dataSource = self;
    self.tableView_Shipper.delegate = self;
    self.tableView_Shipper.dataSource = self;
    self.tableView_Consigment.delegate = self;
    self.tableView_Consigment.dataSource = self;
    self.tableView_Consigment_Receiver.delegate = self;
    self.tableView_Consigment_Receiver.dataSource = self;
    
    self.stackReceiverDocument.hidden = false;
    if (g_visibleModel!=nil && [g_visibleModel.signatureVisible isEqualToString:@"0"]) {
        self.stackSignature.hidden = true;
        self.stackShipperDocument.hidden = true;
        self.stackReceiver.hidden = true;
        
    }else{
        
    }
    
}
-(void)setMode:(NSString *)mode{
    _mode = [mode lowercaseString];
}
-(NSString*)getTime{
    NSDate* date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a"];
    NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone];
    [dateFormat setTimeZone:sourceTimeZone];
    
    NSString *datestr = [dateFormat stringFromDate:date];
    return datestr;
}
-(NSString*)getDate{
    NSDate* date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone];
    [dateFormat setTimeZone:sourceTimeZone];
    
    NSString *datestr = [dateFormat stringFromDate:date];
//    NSString * ret = [NSString stringWithFormat:@"%@ ",datestr];
    return datestr;
}
-(void)showAddressDetails{
    if (g_addressModel.desAddress!=nil) {
        _lblPickAddress.text = g_addressModel.sourceAddress;
        _lblPickCity.text = g_addressModel.sourceCity;
        _lblPickState.text = g_addressModel.sourceState;
        _lblPickPincode.text = g_addressModel.sourcePinCode;
        _lblPickPhone.text = g_addressModel.sourcePhonoe;
        _lblPickLandMark.text = g_addressModel.sourceLandMark;
        _lblPickInst.text = g_addressModel.sourceInstruction;
        
        _lblDestAddress.text = g_addressModel.desAddress;
        _lblDestCity.text = g_addressModel.desCity;
        _lblDestState.text = g_addressModel.desState;
        _lblDestPincode.text = g_addressModel.desPinCode;
        _lblDestPhone.text = g_addressModel.desPhone;
        _lblDestLandMark.text = g_addressModel.desLandMark;
        _lblDestInst.text = g_addressModel.desInstruction;
    }
//    _lblDestPhone.hidden = true;
}
-(void)clickView:(UIView*)sender{
    int tag = (int)sender.tag;
    switch (tag) {
        case 200:
        {
            // btn_pickup
            if (self.type == g_ORDER) {
                if ([self checkInput]) {
                    if (_stackSignature.hidden == false) {
                        if (_imgSignature.image == nil) {
                            [CGlobal AlertMessage:@"No Signature File" Title:nil];
                            return;
                        }else{
                            [self insert_carrier:_imgSignature.image];
                        }
                    }else{
                        [self insert_carrier:nil];
                    }
                    
                }else{
                    [CGlobal AlertMessage:@"Please Input All Info" Title:nil];
                    return;
                }
            }else if(self.type == g_ONHOLD){
                if (_stackReceiver.hidden == false){
                    if (self.imgSignature_recv.image == nil) {
                        [CGlobal AlertMessage:@"Signature" Title:nil];
                        return;
                    }
                }
                [self completeCorporateOrder:@"4"];
            }
            break;
        }
        case 202:{
            // btn_delivered
            self.mETA = _txtEta.text;
            if (_stackReceiver.hidden == false) {
                if (self.imgSignature_recv.image == nil) {
                    [CGlobal AlertMessage:@"Please Signature" Title:nil];
                    return;
                }
            }
            [self completeCorporateOrder:@"4"];
            
            
            break;
        }
        case 204:{
            // btn_returned
            [self changeCorporateOrder:@"5"];
            break;
        }
        case 300:{
            self.mETA = self.txtEta.text;
            if (self.mETA != nil || [self.mETA length] > 0) {
                [self update_eta];
            }else{
                [CGlobal AlertMessage:@"Please Input ETA" Title:nil];
            }
            break;
        }
        case 301:{
            self.mWeight = self.txtWeight.text;
            if (self.mWeight != nil || [self.mWeight length] > 0) {
                [self update_weight];
            }else{
                [CGlobal AlertMessage:@"Please Input WEIGHT" Title:nil];
            }
            break;
        }
        default:
            break;
    }
}
-(void)showCarriers{
    if (g_carrierModel!=nil &&g_carrierModel.order_id!=nil) {
        CarrierModel* cm = g_carrierModel;
//        _txtFrieght.text = cm.freight;
        _txtLoadType.text = cm.load_type;
        NSString *lastTrimString = [cm.consignment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([lastTrimString length]>0) {
            NSArray* strings = [cm.consignment componentsSeparatedByString:@":"];
            self.consigments = [[NSMutableArray alloc] initWithArray:strings];
            [self.tableView_Consigment reloadData];
        }

        _txtDateTime.text = [NSString stringWithFormat:@"%@ %@",cm.date,cm.time];
        _txtVehicleNumber.text = cm.vehicle;
        _txtDriverID.text = cm.driver_id;
        _txtDriverName.text = cm.driver_name;
//        self.imgSignature.image = cm.signature;
        NSString* path = [NSString stringWithFormat:@"%@%@%@",g_baseUrl,PHOTO_URL,cm.signature];
        [self.imgSignature sd_setImageWithURL:[NSURL URLWithString:path]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  
                              }];
    }
}
-(void)insert_carrier:(UIImage*)image{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"id"] = env.carrier_id;
    params[@"id"] = env.carrier_id;
    params[@"order_id"] = env.order_id;
    params[@"employer_id"] = env.corporate_user_id;
    params[@"load_type"] =  _mLoadType;
    params[@"freight"] = _mFreight;
    params[@"consignment"] = _mConsignment;
    params[@"date"] = _mDate;
    params[@"time"] = _mTime;
    params[@"vehicle"] = _mVehicle;
    params[@"driver_id"] = _mDriverId;
    params[@"driver_name"] = _mDriverName;
    params[@"signature"] = @"signature";
    
    NSMutableDictionary* imageParam = [[NSMutableDictionary alloc] init];
    if (image!=nil) {
        NSMutableArray* images = [[NSMutableArray alloc] init];
        NSData*imageData = UIImageJPEGRepresentation(image, 0.7);
        if (imageData!=nil) {
            [images addObject:imageData];
        }
        imageData = UIImagePNGRepresentation(image);
        if (imageData!=nil) {
            [images addObject:imageData];
        }
        if (images.count == 0) {
            [CGlobal AlertMessage:@"Please Signature" Title:nil];
            return;
        }
        
        
        imageParam[@"file"] = images[0];
        for (int i=0; i<_items_shipper.count; i++) {
            images = [[NSMutableArray alloc] init];
            ItemModel* cell = _items_shipper[i];
            imageData = UIImageJPEGRepresentation(cell.image_data, 0.7);
            if (imageData!=nil) {
                [images addObject:imageData];
            }
            imageData = UIImagePNGRepresentation(cell.image_data);
            if (imageData!=nil) {
                [images addObject:imageData];
            }
            NSString* key = [NSString stringWithFormat:@"file%d",i];
            imageParam[key] = images[0];
        }
    }
    
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    NSString* url = [NSString stringWithFormat:@"%@%@%@",g_baseUrl,ORDER_URL,@"carrier"];
    [manager uploadImage4:params Data:imageParam Path:url withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                int ret = [dict[@"result"] intValue];
                if(ret == 200){
                    
                    NSString*trackstr = [NSString stringWithFormat:@"%@,%d",env.order_id,g_mode];
                    [CGlobal addOrderToTrackOrder:trackstr];
                    
                    
                    [self.navigationController popViewControllerAnimated:true];
                }else if(ret == 300){
                    
                }else {
                    
                }
            }else{
                
                NSString*trackstr = [NSString stringWithFormat:@"%@,%d",env.order_id,g_mode];
                [CGlobal addOrderToTrackOrder:trackstr];
                [self.navigationController popViewControllerAnimated:true];
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    }];
}
-(BOOL)checkInput{
    self.mFreight = _txtFrieght.text;
    self.mLoadType = _txtLoadType.text;
    for (int i=0; i<self.consigments.count; i++) {
        if(i==0){
            self.mConsignment = self.consigments[i];
        }else{
            self.mConsignment = [NSString stringWithFormat:@"%@:%@",self.mConsignment,self.consigments[i]];
        }
    }
    
    for (int i=0; i<self.consigments_receiver.count; i++) {
        if(i==0){
            self.mConsignment_receiver = self.consigments_receiver[i];
        }else{
            self.mConsignment_receiver = [NSString stringWithFormat:@"%@:%@",self.mConsignment_receiver,self.consigments_receiver[i]];
        }
    }
    self.mVehicle = _txtVehicleNumber.text;
    self.mDriverId = _txtDriverID.text;
    self.mDriverName = _txtDriverName.text;
    
    if (_mFreight == nil || [_mFreight length] == 0) {
        return false;
    }
    if (_mLoadType == nil || [_mLoadType length] == 0) {
        return false;
    }
//    if (_mConsignment == nil || [_mConsignment length] == 0) {
//        return false;
//    }
    if (_mVehicle == nil || [_mVehicle length] == 0) {
        return false;
    }
    if (_mDriverId == nil || [_mDriverId length] == 0) {
        return false;
    }
    if (_mDriverName == nil || [_mDriverName length] == 0) {
        return false;
    }
    if (_mDate == nil || [_mDate length] == 0) {
        return false;
    }
    if (_mTime == nil || [_mTime length] == 0) {
        return false;
    }
    
    
    return true;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)update_weight{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"order_id"] = env.order_id;
    params[@"weight"] = self.mWeight;
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:g_URL Path:@"update_weight" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 200){
                    [CGlobal AlertMessage:@"Success" Title:nil];
                }else if([dict[@"result"] intValue] == 300){
                    
                }else {
                    
                }
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}

-(void)update_eta{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"order_id"] = env.order_id;
    params[@"eta"] = self.mETA;
    if (env.mode == c_PERSONAL) {
        params[@"user_id"] = env.user_id;
    }else{
        params[@"user_id"] = env.corporate_user_id;
    }
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:g_URL Path:@"update_eta" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 200){
                    [CGlobal AlertMessage:@"Success" Title:nil];
                }else if([dict[@"result"] intValue] == 300){
                    
                }else {
                    
                }
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}
-(void)changeCorporateOrder:(NSString*)state{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"state"] = state;
    params[@"id"] = env.order_id;
    if (env.mode == c_PERSONAL) {
        params[@"user_id"] = env.user_id;
    }else{
        params[@"user_id"] = env.corporate_user_id;
    }
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:ORDER_URL Path:@"change_corporate_order" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 200){
                    [self.navigationController popViewControllerAnimated:true];
                }else if([dict[@"result"] intValue] == 300){
                    
                }else {
                    
                }
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}

-(void)completeCorporateOrder:(NSString*)state{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"state"] = state;
    params[@"id"] = env.order_id;
    if (env.mode == c_PERSONAL) {
        params[@"user_id"] = env.user_id;
    }else{
        params[@"user_id"] = env.corporate_user_id;
    }
    
    for (int i=0; i<self.consigments_receiver.count; i++) {
        if(i==0){
            self.mConsignment_receiver = self.consigments_receiver[i];
        }else{
            self.mConsignment_receiver = [NSString stringWithFormat:@"%@:%@",self.mConsignment_receiver,self.consigments_receiver[i]];
        }
    }
    
    NSMutableDictionary* imageParam = [[NSMutableDictionary alloc] init];
    if (_stackReceiver.hidden == false){
        NSMutableArray* images = [[NSMutableArray alloc] init];
        NSData*imageData = UIImageJPEGRepresentation(self.imgSignature_recv.image, 0.7);
        if (imageData!=nil) {
            [images addObject:imageData];
        }
        imageData = UIImagePNGRepresentation(self.imgSignature_recv.image);
        if (imageData!=nil) {
            [images addObject:imageData];
        }
        params[@"receiver_signature"] = @"receiver_signature";
        if (images.count == 0) {
            [CGlobal AlertMessage:@"Please Signature" Title:nil];
            return;
        }
        imageParam[@"file"] = images[0];
        for (int i=0; i<_items_receiver.count; i++) {
            images = [[NSMutableArray alloc] init];
            ItemModel* cell = _items_receiver[i];
            imageData = UIImageJPEGRepresentation(cell.image_data, 0.7);
            if (imageData!=nil) {
                [images addObject:imageData];
            }
            imageData = UIImagePNGRepresentation(cell.image_data);
            if (imageData!=nil) {
                [images addObject:imageData];
            }
            NSString* key = [NSString stringWithFormat:@"file%d",i];
            imageParam[key] = images[0];
        }
    }
    params[@"eta"] = self.mETA;
    params[@"receiver_consignment"] = _mConsignment_receiver;
    
    
    NetworkParser* manager = [NetworkParser sharedManager];
    NSString* url = [NSString stringWithFormat:@"%@%@%@",g_baseUrl,ORDER_URL,@"complete_corporate_order"];
    [CGlobal showIndicator:self];
    [manager uploadImage4:params Data:imageParam Path:url withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 200){
                    EnvVar* env = [CGlobal sharedId].env;
                    [CGlobal removeOrderFromTrackOrder:env.order_id];
                    [self.navigationController popViewControllerAnimated:true];
                    
                }else if([dict[@"result"] intValue] == 300){
                    
                }else {
                    
                }
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    }];
}
-(void)pickupOrder:(NSString*)state{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"state"] = state;
    params[@"id"] = env.order_id;
    if (env.mode == c_PERSONAL) {
        params[@"user_id"] = env.user_id;
    }else{
        params[@"user_id"] = env.corporate_user_id;
    }
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:ORDER_URL Path:@"change_order" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 400){
                    [CGlobal AlertMessage:@"Fail" Title:nil];
                }else if([dict[@"result"] intValue] == 200){
                    // succ
                    [self.navigationController popViewControllerAnimated:true];
                }
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}
-(void)cancelOrder{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"order_id"] = env.order_id;
    if (env.mode == c_PERSONAL) {
        params[@"employer_id"] = env.user_id;
    }else{
        params[@"employer_id"] = env.corporate_user_id;
    }
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:g_URL Path:@"reject_order" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 400){
                    [CGlobal AlertMessage:@"Fail" Title:nil];
                }else if([dict[@"result"] intValue] == 200){
                    // succ
                    [self.navigationController popViewControllerAnimated:true];
                }
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_tableView_Shipper == tableView) {
        self.const_H_Shipper.constant = self.items_shipper.count* self.cellHeight + 30;
        [self.stackShipperDocument setNeedsUpdateConstraints];
        [self.stackShipperDocument layoutIfNeeded];
        return self.items_shipper.count;
    }else if(_tableView_Receiver == tableView){
        self.const_H_Receiver.constant = self.items_receiver.count* self.cellHeight + 30;
        [self.stackReceiverDocument setNeedsUpdateConstraints];
        [self.stackReceiverDocument layoutIfNeeded];
        return self.items_receiver.count;
    }else if(_tableView_Consigment == tableView){
        self.constraint_SCANTH.constant = self.consigments.count* self.cellHeight + 30;
        [self.stackConsigment setNeedsUpdateConstraints];
        [self.stackConsigment layoutIfNeeded];
        [self.tableView_Consigment setNeedsUpdateConstraints];
        [self.tableView_Consigment layoutIfNeeded];
        return self.consigments.count;
    }else{
        self.constraint_SCANTH_Receiver.constant = self.consigments_receiver.count* self.cellHeight + 30;
        [self.stackConsigment_Receiver setNeedsUpdateConstraints];
        [self.stackConsigment_Receiver layoutIfNeeded];
        [self.tableView_Consigment_Receiver setNeedsUpdateConstraints];
        [self.tableView_Consigment_Receiver layoutIfNeeded];
        return self.consigments_receiver.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShipperDocTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_tableView_Shipper == tableView) {
        [cell setData:@{@"aDelegate":self,@"model":self.items_shipper[indexPath.row],@"indexPath":indexPath,@"type":@"1"}];
    }else if(_tableView_Receiver == tableView){
        [cell setData:@{@"aDelegate":self,@"model":self.items_receiver[indexPath.row],@"indexPath":indexPath,@"type":@"2"}];
    }else if(_tableView_Consigment == tableView){
        NSString* remove = @"0";
        if (self.btnScan.hidden) {
            remove = @"1";
        }else{
            remove = @"0";
        }
        [cell setData:@{@"aDelegate":self,@"model":self.consigments[indexPath.row],@"indexPath":indexPath,@"type":@"3",@"remove":remove}];
    }else if(_tableView_Consigment_Receiver == tableView){
        NSString* remove = @"0";
        if (self.btnScan_Receiver.hidden) {
            remove = @"1";
        }else{
            remove = @"0";
        }
        [cell setData:@{@"aDelegate":self,@"model":self.consigments_receiver[indexPath.row],@"indexPath":indexPath,@"type":@"4",@"remove":remove}];
    }
    return cell;
}
-(void)didSubmit:(NSDictionary *)data View:(UIView *)view{
    if ([view isKindOfClass:[ShipperDocTableViewCell class]]) {
        if (data[@"action"]!=nil) {
            NSString* action = data[@"action"];
            NSDictionary* inputData = data[@"inputData"];
            if ([action isEqualToString:@"delete"]) {
                int type = [inputData[@"type"] intValue];
                if (type == 1) {
                    // shipper
                    NSIndexPath* path = inputData[@"indexPath"];
                    [self.items_shipper removeObjectAtIndex:path.row];
                    [self.tableView_Shipper reloadData];
                }else if(type == 2){
                    // receiver
                    NSIndexPath* path = inputData[@"indexPath"];
                    [self.items_receiver removeObjectAtIndex:path.row];
                    [self.tableView_Receiver reloadData];
                }else if(type == 3){
                    // receiver
                    NSIndexPath* path = inputData[@"indexPath"];
                    [self.consigments removeObjectAtIndex:path.row];
                    [self.tableView_Consigment reloadData];
                }else{
                    // receiver
                    NSIndexPath* path = inputData[@"indexPath"];
                    [self.consigments_receiver removeObjectAtIndex:path.row];
                    [self.tableView_Consigment_Receiver reloadData];
                }
            }
        }
    }
}
- (IBAction)clickAddShipper:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    PhotoUploadViewController* vc = [ms instantiateViewControllerWithIdentifier:@"PhotoUploadViewController"];
    vc.vc = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        vc.limit = 1000;
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)clickAddReceiver:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    PhotoUploadViewController* vc = [ms instantiateViewControllerWithIdentifier:@"PhotoUploadViewController"];
    vc.vc = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        vc.limit = 1000;
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:true];
    });
}


@end
