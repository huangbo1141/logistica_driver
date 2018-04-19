//
//  OrderDetailViewController.m
//  Logistika
//
//  Created by BoHuang on 4/24/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "CGlobal.h"
#import "PhotoUploadViewController.h"

#import "ReviewCameraTableViewCell.h"
#import "ReviewItemTableViewCell.h"
#import "ReviewPackageTableViewCell.h"
#import "KMZViewController.h"

#import "NetworkParser.h"
#import "ShipperDocTableViewCell.h"

@interface OrderDetailViewController ()
@property (nonatomic,strong) OrderModel* orderModel;
@property (nonatomic,strong) NSMutableDictionary* height_dict;
@property (nonatomic,assign) CGFloat totalHeight;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    EnvVar* env = [CGlobal sharedId].env;
    [self showItemLists];
    [self showAddressDetails];
    self.lblPickDate.text = [NSString stringWithFormat:@"Pick up on: %@%@",g_dateModel.date,g_dateModel.time];
    self.lblServiceLevel.text = [NSString stringWithFormat:@"%@, %@%@, %@",g_serviceModel.name,symbol_dollar,g_serviceModel.price,g_serviceModel.time_in];
    _lblPaymentMethod.text = [NSString stringWithFormat:@"Pyament Method: %@", curPaymentWay];
//    _lblPaymentMethod.text = [NSString stringWithFormat:@"Cash on Pick Up"];	
    
    _lblOrderNumber.text = env.order_id;
    _lblTrackingNumber.text = g_track_id;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    [self hideAddressFields];
}
-(void)calculateRowHeight{
    self.height_dict = [[NSMutableDictionary alloc] init];
    self.totalHeight = 0;
    for (int i=0; i<self.orderModel.itemModels.count; i++) {
        NSIndexPath*path = [NSIndexPath indexPathForRow:i inSection:0];
        CGFloat height = [CGlobal tableView1:self.tableView heightForRowAtIndexPath:path DefaultHeight:self.cellHeight Data:self.orderModel OrderType:g_ORDER_TYPE Padding:16 Width:0];
        NSString*key = [NSString stringWithFormat:@"%d",i];
        NSString*value = [NSString stringWithFormat:@"%f",height];
        self.height_dict[key] = value;
        self.totalHeight = self.totalHeight + height;
    }
}
-(void)hideAddressFields{
    //    _lblPickAddress.hidden = true;
    _lblPickCity.hidden = true;
    _lblPickState.hidden = true;
    _lblPickPincode.hidden = true;
    
    //    _lblDestAddress.hidden = true;
    _lblDestCity.hidden = true;
    _lblDestState.hidden = true;
    _lblDestPincode.hidden = true;
    
    _lblPickAddress.numberOfLines = 0;
    _lblDestAddress.numberOfLines = 0;
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
    
    
}
-(void)handleGesture:(UITapGestureRecognizer*)gesture{
    UIView*view = gesture.view;
    if (view!=nil) {
        int tag = (int)view.tag;
        switch (tag) {
            case 200:
            {
                // barcode
                
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
-(void)initView{
    self.stackShipper.hidden = true;
    self.stackReceiver.hidden = true;
    self.cellHeight_doc = 60;
    
    UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [_imgSignature addGestureRecognizer:gesture];
    _imgSignature.tag = 201;
    
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [_imgSignature_recv addGestureRecognizer:gesture];
    _imgSignature_recv.tag = 202;
    
    _imgSignature.userInteractionEnabled = true;
    _imgSignature_recv.userInteractionEnabled = true;
    
    _imgSignature.userInteractionEnabled = false;
    if (self.type == g_ORDER) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"orders_for_pickup" value:@"" table:nil];
        self.title = title;
        
        self.viewAction1.hidden = false;
        self.viewAction2.hidden = false;
        self.viewAction3.hidden = true;
        
        self.lblAction1.text = @"Pick Up";
        self.lblAction2.text = @"Pick Up Cancelled";
        
        self.btnAction1.tag = 200;
        self.btnAction2.tag = 201;
        
        self.stackShipper.hidden = false;
        self.stackReceiver.hidden = true;
        _imgSignature.userInteractionEnabled = true;
    }else if (self.type == g_PICKUP) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"picked_up" value:@"" table:nil];
        self.title = title;
        
        self.viewAction1.hidden = false;
        self.viewAction2.hidden = false;
        self.viewAction3.hidden = false;
        
        self.lblAction1.text = @"Delivered";
        self.lblAction2.text = @"On Hold";
        self.lblAction3.text = @"Returned";
        
        self.btnAction1.tag = 202;
        self.btnAction2.tag = 203;
        self.btnAction3.tag = 204;
        
        self.stackShipper.hidden = true;
        self.stackReceiver.hidden = false;
        
    }else if (self.type == g_COMPLETE) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"completed" value:@"" table:nil];
        self.title = title;
        
        self.viewBottomAction.hidden = true;
        self.constraint_BOTTOMSPACE.constant = 0;
    }else if (self.type == g_ONHOLD) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"on_hold" value:@"" table:nil];
        self.title = title;
        
        self.viewAction1.hidden = false;
        self.viewAction2.hidden = false;
        self.viewAction3.hidden = true;
        
        self.lblAction1.text = @"Delivered";
        self.lblAction2.text = @"Returned";
        
        self.btnAction1.tag = 205;
        self.btnAction2.tag = 206;
        
        self.stackShipper.hidden = true;
        self.stackReceiver.hidden = false;
    }else if (self.type == g_RETURN) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"returned" value:@"" table:nil];
        self.title = title;
        
        self.viewBottomAction.hidden = true;
        self.constraint_BOTTOMSPACE.constant = 0;
    }
    
    
    
    [self.btnAction1 addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAction2 addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAction3 addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    UINib* nib = [UINib nibWithNibName:@"ShipperDocTableViewCell" bundle:nil];
    [self.tableView_Shipper registerNib:nib forCellReuseIdentifier:@"cell"];
    
    nib = [UINib nibWithNibName:@"ShipperDocTableViewCell" bundle:nil];
    [self.tableView_Receiver registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.tableView_Receiver.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView_Shipper.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView_Receiver.delegate = self;
    self.tableView_Receiver.dataSource = self;
    self.tableView_Shipper.delegate = self;
    self.tableView_Shipper.dataSource = self;
    
    if (g_visibleModel!=nil && [g_visibleModel.signatureVisible isEqualToString:@"0"]) {
        self.stackReceiver.hidden = true;
        self.stackShipper.hidden = true;
    }else{
        
    }
}
-(void)showAddressDetails{
    if (g_addressModel.desAddress!=nil) {
        _lblPickAddress.text = g_addressModel.sourceAddress;
        _lblPickCity.text = g_addressModel.sourceCity;
        _lblPickState.text = g_addressModel.sourceState;
        _lblPickPincode.text = g_addressModel.sourcePinCode;
        _lblPickPhone.text = g_addressModel.sourcePhonoe;
        _lblPickLandMark.text = g_addressModel.sourceLandMark;
        
        
        
        
        _lblDestAddress.text = g_addressModel.desAddress;
        _lblDestCity.text = g_addressModel.desCity;
        _lblDestState.text = g_addressModel.desState;
        _lblDestPincode.text = g_addressModel.desPinCode;
        _lblDestPhone.text = g_addressModel.desPhone;
        _lblDestLandMark.text = g_addressModel.desLandMark;
        
        NSString* sin = [g_addressModel.sourceInstruction stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([sin length]>0) {
            _lblPickInst.text = g_addressModel.sourceInstruction;
        }else{
            _lblPickInst.hidden = true;
        }
        sin = [g_addressModel.desInstruction stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([sin length]>0) {
            _lblDestInst.text = g_addressModel.desInstruction;
        }else{
            _lblDestInst.hidden = true;
        }
        
        _lblPickName.text = g_addressModel.sourceName;
        _lblDestName.text = g_addressModel.desName;
    }
    //_lblDestPhone.hidden = true;
}
-(void)clickView:(UIView*)sender{
    int tag = (int)sender.tag;
    switch (tag) {
        case 200:
        {
            // btn_pickup
            [self pickupOrder:@"3"];
            break;
        }
        case 201:{
            // btn_pickup_cancel
            [self cancelOrder];
            break;
        }
        case 202:{
            // btn_delivered
            [self pickupOrder:@"4"];
            
            EnvVar* env = [CGlobal sharedId].env;
            [CGlobal removeOrderFromTrackOrder:env.order_id];
            
            break;
        }
        case 203:{
            // btn_on_hold
            [self pickupOrder:@"5"];
            break;
        }
        case 204:{
            // btn_returned
            [self pickupOrder:@"6"];
            break;
        }
        case 205:{
            // btn_delivered_hold
            [self pickupOrder:@"4"];
            break;
        }
        case 206:{
            // btn_returned_hold
            [self pickupOrder:@"6"];
            break;
        }
        default:
            break;
    }
}
-(void)showItemLists{
    EnvVar* env = [CGlobal sharedId].env;
    if (g_ORDER_TYPE == g_CAMERA_OPTION) {
        self.orderModel = g_cameraOrderModel;
        self.viewHeader_CAMERA.hidden = false;
        self.viewHeader_ITEM.hidden = true;
        self.viewHeader_PACKAGE.hidden = true;
        
        UINib* nib = [UINib nibWithNibName:@"ReviewCameraTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell1"];
        self.cellHeight = 40;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }else if(g_ORDER_TYPE == g_ITEM_OPTION){
        self.orderModel = g_itemOrderModel;
        self.viewHeader_CAMERA.hidden = true;
        self.viewHeader_ITEM.hidden = false;
        self.viewHeader_PACKAGE.hidden = true;
        
        UINib* nib = [UINib nibWithNibName:@"ReviewItemTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell2"];
        self.cellHeight = 40;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }else if(g_ORDER_TYPE == g_PACKAGE_OPTION){
        self.orderModel = g_packageOrderModel;
        self.viewHeader_CAMERA.hidden = true;
        self.viewHeader_ITEM.hidden = true;
        self.viewHeader_PACKAGE.hidden = false;
        
        UINib* nib = [UINib nibWithNibName:@"ReviewPackageTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell3"];
        self.cellHeight = 40;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
    [self calculateRowHeight];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_tableView_Shipper == tableView) {
        self.const_H_Shipper.constant = self.items_shipper.count* self.cellHeight_doc + 30;
        [self.stackShipperDocument setNeedsUpdateConstraints];
        [self.stackShipperDocument layoutIfNeeded];
        return self.items_shipper.count;
    }else if(_tableView_Receiver == tableView){
        self.const_H_Receiver.constant = self.items_receiver.count* self.cellHeight_doc + 30;
        [self.stackReceiverDocument setNeedsUpdateConstraints];
        [self.stackReceiverDocument layoutIfNeeded];
        return self.items_receiver.count;
    }
    
    self.constraint_TH.constant = self.totalHeight;
    [self.tableView setNeedsUpdateConstraints];
    [self.tableView layoutIfNeeded];
    return self.orderModel.itemModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_tableView_Shipper == tableView) {
        ShipperDocTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setData:@{@"aDelegate":self,@"model":self.items_shipper[indexPath.row],@"indexPath":indexPath,@"type":@"1"}];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else if(_tableView_Receiver == tableView){
        ShipperDocTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setData:@{@"aDelegate":self,@"model":self.items_receiver[indexPath.row],@"indexPath":indexPath,@"type":@"2"}];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    
    if (g_ORDER_TYPE == g_CAMERA_OPTION) {
        ReviewCameraTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        [cell initMe:self.orderModel.itemModels[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aDelegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else if(g_ORDER_TYPE == g_ITEM_OPTION){
        ReviewItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        
        [cell initMe:self.orderModel.itemModels[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aDelegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        ReviewPackageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        
        [cell initMe:self.orderModel.itemModels[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aDelegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableView_Shipper == tableView) {
        return self.cellHeight_doc;
    }else if(_tableView_Receiver == tableView){
        return self.cellHeight_doc;
    }
    NSString* key = [NSString stringWithFormat:@"%d",indexPath.row];
    if(self.height_dict[key]!=nil){
        NSString* value = self.height_dict[key];
        return [value floatValue];
    }
    return self.cellHeight;
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
                }else{
                    // receiver
                    NSIndexPath* path = inputData[@"indexPath"];
                    [self.items_receiver removeObjectAtIndex:path.row];
                    [self.tableView_Receiver reloadData];
                }
            }
        }
    }
}

-(void)pickupOrder:(NSString*)state{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"state"] = state;
    params[@"id"] = env.order_id;
    if (env.mode == c_PERSONAL) {
        params[@"user_id"] = env.user_id;
    }
    else
    {
        params[@"user_id"] = env.corporate_user_id;
    }
    UIImage*image=nil;
    NSMutableArray* array = nil;
    if ([state isEqualToString:@"3"] || [state isEqualToString:@"4"]) {
        // completed or delivered
        if (self.type == g_ORDER) {
            if (_stackShipper.hidden == false) {
                if (_imgSignature.image == nil) {
                    [CGlobal AlertMessage:@"Choose Shipper Signature" Title:nil];
                    return;
                }else{
                    image = _imgSignature.image;
                    array = _items_shipper;
                }
            }
            
        }else {
            if (_stackReceiver.hidden == false) {
                if (_imgSignature_recv.image == nil) {
                    [CGlobal AlertMessage:@"Choose Receiver Signature" Title:nil];
                    return;
                }else{
                    image = _imgSignature_recv.image;
                    array = _items_receiver;
                }
            }
            
        }
    }
    NSMutableDictionary* imageParam = [[NSMutableDictionary alloc] init];
    NSData*imageData = [CGlobal getImageDataFromUIImage:image];
    if (imageData!=nil) {
        imageParam[@"signature0"] = imageData;
    }
    for (int i=0; i<array.count; i++) {
        ItemModel* cell = array[i];
        imageData = [CGlobal getImageDataFromUIImage:cell.image_data];
        if (imageData!=nil) {
            NSString* key = [NSString stringWithFormat:@"file%d",i+1];
            imageParam[key] = imageData;
        }
        
    }
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    NSString* url = [NSString stringWithFormat:@"%@%@%@",g_baseUrl,ORDER_URL,@"change_order"];
    [manager uploadImage4:params Data:imageParam Path:url withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        [CGlobal stopIndicator:self];
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 400){
                    [CGlobal AlertMessage:@"Fail" Title:nil];
                }else if([dict[@"result"] intValue] == 200){
                    // succ
                    NSString*trackstr = [NSString stringWithFormat:@"%@,%d",env.order_id,g_mode];
                    [CGlobal addOrderToTrackOrder:trackstr];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:true];
                    });
                    
                }
            }
        }else{
            NSLog(@"Error");
        }
        
    }];
    
    
//    if (image == nil) {
//        NetworkParser* manager = [NetworkParser sharedManager];
//        [CGlobal showIndicator:self];
//        [manager ontemplateGeneralRequest2:params BasePath:ORDER_URL Path:@"change_order" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
//            if (error == nil) {
//                if (dict!=nil && dict[@"result"] != nil) {
//                    //
//                    if([dict[@"result"] intValue] == 400){
//                        [CGlobal AlertMessage:@"Fail" Title:nil];
//                    }else if([dict[@"result"] intValue] == 200){
//                        // succ
//                        NSString*trackstr = [NSString stringWithFormat:@"%@,%d",env.order_id,g_mode];
//                        [CGlobal addOrderToTrackOrder:trackstr];
//                        
//                        [self.navigationController popViewControllerAnimated:true];
//                    }
//                }
//            }else{
//                NSLog(@"Error");
//            }
//            [CGlobal stopIndicator:self];
//        } method:@"POST"];
//    }
    
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
