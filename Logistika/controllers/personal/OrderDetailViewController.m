//
//  OrderDetailViewController.m
//  Logistika
//
//  Created by BoHuang on 4/24/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "CGlobal.h"

#import "ReviewCameraTableViewCell.h"
#import "ReviewItemTableViewCell.h"
#import "ReviewPackageTableViewCell.h"

#import "NetworkParser.h"

@interface OrderDetailViewController ()
@property (nonatomic,strong) OrderModel* orderModel;
@property (nonatomic,assign) CGFloat cellHeight;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    EnvVar* env = [CGlobal sharedId].env;
    [self showItemLists];
    [self showAddressDetails];
    self.lblPickDate.text = [NSString stringWithFormat:@"Pick up on: %@%@",g_dateModel.date,g_dateModel.time];
    self.lblServiceLevel.text = [NSString stringWithFormat:@"%@, $%@, %@",g_serviceModel.name,g_serviceModel.price,g_serviceModel.time_in];
//    _lblPaymentMethod.text = [NSString stringWithFormat:@"Pyament Method: %@", curPaymentWay];
    _lblPaymentMethod.text = [NSString stringWithFormat:@"Cash on Pick Up"];
    
    _lblOrderNumber.text = env.order_id;
    _lblTrackingNumber.text = g_track_id;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = false;
}
-(void)initView{
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
        
    }else if (self.type == g_RETURN) {
        NSString* title = [[NSBundle mainBundle] localizedStringForKey:@"returned" value:@"" table:nil];
        self.title = title;
        
        self.viewBottomAction.hidden = true;
        self.constraint_BOTTOMSPACE.constant = 0;
    }
    
    [self.btnAction1 addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAction2 addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAction3 addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
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
        //        _lblDestPhone.text = g_addressModel.des;
        _lblDestLandMark.text = g_addressModel.desLandMark;
        _lblDestInst.text = g_addressModel.desInstruction;
    }
    _lblDestPhone.hidden = true;
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
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
        self.cellHeight = 40;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }else if(g_ORDER_TYPE == g_ITEM_OPTION){
        self.orderModel = g_itemOrderModel;
        self.viewHeader_CAMERA.hidden = true;
        self.viewHeader_ITEM.hidden = false;
        self.viewHeader_PACKAGE.hidden = true;
        
        UINib* nib = [UINib nibWithNibName:@"ReviewItemTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
        self.cellHeight = 40;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }else if(g_ORDER_TYPE == g_PACKAGE_OPTION){
        self.orderModel = g_packageOrderModel;
        self.viewHeader_CAMERA.hidden = true;
        self.viewHeader_ITEM.hidden = true;
        self.viewHeader_PACKAGE.hidden = false;
        
        UINib* nib = [UINib nibWithNibName:@"ReviewPackageTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
        self.cellHeight = 40;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
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
    CGFloat height = self.cellHeight * self.orderModel.itemModels.count;
    self.constraint_TH.constant = height;
    [self.tableView setNeedsUpdateConstraints];
    [self.tableView layoutIfNeeded];
    return self.orderModel.itemModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (g_ORDER_TYPE == g_CAMERA_OPTION) {
        ReviewCameraTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        [cell initMe:self.orderModel.itemModels[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aDelegate = self;
        return cell;
    }else if(g_ORDER_TYPE == g_ITEM_OPTION){
        ReviewItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        [cell initMe:self.orderModel.itemModels[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aDelegate = self;
        return cell;
    }else{
        ReviewPackageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        [cell initMe:self.orderModel.itemModels[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aDelegate = self;
        return cell;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
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
                    NSString*trackstr = [NSString stringWithFormat:@"%@,%d",env.order_id,g_mode];
                    [CGlobal addOrderToTrackOrder:trackstr];
                    
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
