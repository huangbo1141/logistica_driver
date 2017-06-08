//
//  OrderPickUpViewController.m
//  Logistika
//
//  Created by BoHuang on 4/27/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "OrderPickUpViewController.h"
#import "CGlobal.h"
#import "NetworkParser.h"
#import "OrderResponse.h"
#import "OrderHisModel.h"
#import "ViewScrollContainer.h"
#import "OrderCorporateHisModel.h"
#import "OrderItemTableViewCell1.h"
#import "OrderDetailViewController.h"
#import "OrderDetailCorViewController.h"

@interface OrderPickUpViewController ()
@property(nonatomic,strong) OrderResponse*response;

@property(nonatomic,strong) NSMutableArray*data_0;
@property(nonatomic,strong) NSMutableArray*data_1;
@property(nonatomic,strong) NSMutableArray*data_2;

@property(nonatomic,copy) NSString* mMode;
@end

@implementation OrderPickUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];
    
    
    self.segControl.tintColor = COLOR_PRIMARY;
}
-(void)initViews{
    self.segControl.tintColor = COLOR_PRIMARY;
    
    UINib*nib1 = [UINib nibWithNibName:@"OrderItemTableViewCell1" bundle:nil];
    [self.tableview1 registerNib:nib1 forCellReuseIdentifier:@"cell"];
    
    UINib*nib2 = [UINib nibWithNibName:@"OrderItemTableViewCell1" bundle:nil];
    [self.tableview2 registerNib:nib2 forCellReuseIdentifier:@"cell"];
    
    UINib*nib3 = [UINib nibWithNibName:@"OrderItemTableViewCell1" bundle:nil];
    [self.tableview3 registerNib:nib3 forCellReuseIdentifier:@"cell"];
    
    self.tableview1.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableview2.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableview3.separatorStyle = UITableViewCellSelectionStyleNone;
}
-(void)filterData{
    self.data_0 = [[NSMutableArray alloc] init];
    self.data_1 = [[NSMutableArray alloc] init];
    self.data_2 = [[NSMutableArray alloc] init];
    if (_type ==0 || _type == 1 || _type == 3) {
        // divide
        for (int i=0; i<_response.orders.count; i++) {
            OrderHisModel*model = self.response.orders[i];
            NSString* sname = [model.serviceModel.name lowercaseString];
            if ([sname isEqualToString:@"expedited"]) {
                [_data_0 addObject:model];
            }else if ([sname isEqualToString:@"express"]) {
                [_data_1 addObject:model];
            }else if ([sname isEqualToString:@"economy"]) {
                [_data_2 addObject:model];
            }
        }
    }else{
        // not divide
        self.data_0 = self.response.orders;
                
        self.viewRoot1.hidden = false;
        self.viewRoot2.hidden = true;
        self.viewRoot3.hidden = true;
    }
    [self.tableview1 reloadData];
    [self.tableview2 reloadData];
    [self.tableview3 reloadData];
}
-(void)filterDataCorporate{
    NSArray* titles = @[@"cl",@"ftl",@"stl",@"rl"];
    NSUInteger found = [titles indexOfObject:self.mode];
    if (found!=NSNotFound) {
        self.mMode = [titles[found] uppercaseString];
    }
    self.data_0 = [[NSMutableArray alloc] init];
    self.data_1 = [[NSMutableArray alloc] init];
    self.data_2 = [[NSMutableArray alloc] init];
    if (_type ==0 || _type == 1 || _type == 3) {
        // divide
        for (int i=0; i<_response.orders.count; i++) {
            OrderCorporateHisModel*model = self.response.orders[i];
            NSString* sname = [model.serviceModel.name lowercaseString];
            if ([sname isEqualToString:@"expedited"]) {
                if ([model.freight isEqualToString:self.mMode]) {
                    [_data_0 addObject:model];
                }
                
            }else if ([sname isEqualToString:@"express"]) {
                if ([model.freight isEqualToString:self.mMode]) {
                    [_data_1 addObject:model];
                }
            }else if ([sname isEqualToString:@"economy"]) {
                if ([model.freight isEqualToString:self.mMode]) {
                    [_data_2 addObject:model];
                }
                
            }
        }
        
    }else{
        // not divide
        for (int k=0; k<self.response.orders.count; k++) {
            OrderCorporateHisModel* item = self.response.orders[k];
            if ([item.freight isEqualToString:_mMode]) {
                [self.data_0 addObject:item];
            }
        }
        
        self.viewRoot1.hidden = false;
        self.viewRoot2.hidden = true;
        self.viewRoot3.hidden = true;
    }
    
    [self.tableview1 reloadData];
    [self.tableview2 reloadData];
    [self.tableview3 reloadData];
}

- (IBAction)segChanged:(id)sender {
    NSInteger index= self.segControl.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            self.viewRoot1.hidden = false;
            self.viewRoot2.hidden = true;
            self.viewRoot3.hidden = true;
            break;
        }
        case 1:
        {
            self.viewRoot1.hidden = true;
            self.viewRoot2.hidden = false;
            self.viewRoot3.hidden = true;
            break;
        }
        case 2:
        {
            self.viewRoot1.hidden = true;
            self.viewRoot2.hidden = true;
            self.viewRoot3.hidden = false;
            break;
        }
        default:
        {
            break;
        }
    }
}
-(void)initHeader{
    self.mode = [self.mode lowercaseString];
    NSArray* titles = @[@"cl",@"ftl",@"stl",@"rl"];
    NSString* selectedTitle = nil;
    NSUInteger found = [titles indexOfObject:self.mode];
    if (found!=NSNotFound) {
        selectedTitle = [titles[found] uppercaseString];
    }
    switch (self.type) {
        case 0:
        {
            // init order
            if (selectedTitle == nil) {
                self.title =@"Orders for Pick up";
            }else{
                self.title = [NSString stringWithFormat:@"Orders for Pick up - %@",selectedTitle];
            }
            self.segControl.hidden = false;

            break;
        }
        case 1:
        {
            // init pickup
            if (selectedTitle == nil) {
                self.title =@"Picked Up Orders";
            }else{
                self.title = [NSString stringWithFormat:@"Picked Up Orders - %@",selectedTitle];
            }
            self.segControl.hidden = false;

            break;
        }
        case 2:
        {
            // initcompleted view
            if (selectedTitle == nil) {
                self.title =@"Completed Orders";
            }else{
                self.title = [NSString stringWithFormat:@"Completed Orders - %@",selectedTitle];
            }
            self.segControl.hidden = true;

            break;
        }
        case 3:
        {
            if (selectedTitle == nil) {
                self.title =@"On Hold Orders";
            }else{
                self.title = [NSString stringWithFormat:@"On Hold Orders - %@",selectedTitle];
            }
            
            self.segControl.hidden = false;

            break;
        }
        case 4:
        {

            self.title = @"Returned Orders";
            self.segControl.hidden = true;

            break;
        }
            
        default:
            break;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    EnvVar* env = [CGlobal sharedId].env;
    if (env.mode == c_PERSONAL) {
        [self getOrders];
    }else{
        [self getCorporateOrders];
    }
    [self initHeader];
    self.navigationController.navigationBar.hidden = false;
//    [self doHideMode];
}
-(void)doHideMode{
    switch (_hideMode) {
        case 1:
        {
//            self.topBarView.constraint_Height.constant = 0;
//            self.topBarView.hidden = true;
            self.navigationController.navigationBar.hidden = false;
            break;
        }
            
        default:
        {
            self.navigationController.navigationBar.hidden = false;
            break;
        }
    }
}
-(void)getOrders{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    EnvVar* env = [CGlobal sharedId].env;
    if (env.mode == c_PERSONAL) {
        params[@"employer_id"] = env.user_id;
    }else if(env.mode == c_CORPERATION){
        params[@"employer_id"] = env.corporate_user_id;
    }
    NSNumber* number = [NSNumber numberWithInt:self.type+2];
    
    params[@"state"] = [number stringValue];
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:ORDER_URL Path:@"get_orders_by_state" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            // succ
            if (dict[@"result" ]!=nil) {
                if ([dict[@"result"] intValue] == 200) {
                    [self clearReschedule];
                    
                    // parse
                    OrderResponse* response = [[OrderResponse alloc] initWithDictionary_his:dict];
                    self.response = response;
                    [self filterData];
                    
                    [CGlobal stopIndicator:self];
                    return;
                }else if([dict[@"result"] intValue] == 400){
                    [CGlobal AlertMessage:@"No Orders" Title:nil];
                    
                    self.data_0 = [[NSMutableArray alloc] init];
                    self.data_1 = [[NSMutableArray alloc] init];
                    self.data_2 = [[NSMutableArray alloc] init];
                    
                    [self sortData:self.data_0];
                    [self sortData:self.data_1];
                    [self sortData:self.data_2];
                    
                    [self.tableview1 reloadData];
                    [self.tableview2 reloadData];
                    [self.tableview3 reloadData];
                }
            }
            
        }else{
            // error
            NSLog(@"Error");
        }
        
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}
-(void)sortData:(NSMutableArray*)data{
    [data sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSNumber* n1 ;
        NSNumber* n2 ;
        if ([obj1 isKindOfClass:[OrderHisModel class]]) {
            OrderHisModel*model1 = obj1;
            int int1 = [model1.orderId intValue];
            n1 =[NSNumber numberWithInt:int1];
        }else if ([obj1 isKindOfClass:[OrderCorporateHisModel class]]) {
            OrderCorporateHisModel*model1 = obj1;
            int int1 = [model1.orderId intValue];
            n1 =[NSNumber numberWithInt:int1];
        }
        
        if ([obj2 isKindOfClass:[OrderHisModel class]]) {
            OrderHisModel*model2 = obj2;
            int int1 = [model2.orderId intValue];
            n2 =[NSNumber numberWithInt:int1];
        }else if ([obj2 isKindOfClass:[OrderCorporateHisModel class]]) {
            OrderCorporateHisModel*model2 = obj2;
            int int1 = [model2.orderId intValue];
            n2 =[NSNumber numberWithInt:int1];
        }
        return [n2 compare:n1];
    }];
}
-(void)getCorporateOrders{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    EnvVar* env = [CGlobal sharedId].env;
    if (env.mode == c_PERSONAL) {
        params[@"employer_id"] = env.user_id;
    }else if(env.mode == c_CORPERATION){
        params[@"employer_id"] = env.corporate_user_id;
    }
    NSNumber* number = [NSNumber numberWithInt:self.type+2];
    
    params[@"state"] = [number stringValue];
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:ORDER_URL Path:@"get_corporate_orders_by_state" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            // succ
            if (dict[@"result" ]!=nil) {
                if ([dict[@"result"] intValue] == 200) {
                    [self clearReschedule];
                    
                    // parse
                    OrderResponse* response = [[OrderResponse alloc] initWithDictionary_his_cor:dict];
                    self.response = response;
                    [self filterDataCorporate];
                    
                    [CGlobal stopIndicator:self];
                    return;
                }else if([dict[@"result"] intValue] == 400){
                    [CGlobal AlertMessage:@"No Orders" Title:nil];
                    
                    self.data_0 = [[NSMutableArray alloc] init];
                    self.data_1 = [[NSMutableArray alloc] init];
                    self.data_2 = [[NSMutableArray alloc] init];
                    
                    [self sortData:self.data_0];
                    [self sortData:self.data_1];
                    [self sortData:self.data_2];
                    
                    [self.tableview1 reloadData];
                    [self.tableview2 reloadData];
                    [self.tableview3 reloadData];
                }
            }
            
        }else{
            // error
            NSLog(@"Error");
        }
        
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clearReschedule{
    g_orderHisModels = [[NSMutableArray alloc] init];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableview1) {
        return self.data_0.count;
    }else if (tableView == self.tableview2) {
        return self.data_1.count;
    }else{
        return self.data_2.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview1) {
        OrderItemTableViewCell1* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        id data = self.data_0[indexPath.row];
        [cell setOrderData:data];
        
        return cell;
    }else if (tableView == self.tableview2) {
        OrderItemTableViewCell1* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        id data = self.data_1[indexPath.row];
        [cell setOrderData:data];
        
        return cell;
    }else{
        OrderItemTableViewCell1* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        id data = self.data_2[indexPath.row];
        [cell setOrderData:data];
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview1) {
        id data = self.data_0[indexPath.row];
        [self goDetail:data];
    }else if (tableView == self.tableview2) {
        id data = self.data_1[indexPath.row];
        [self goDetail:data];
    }else{
        id data = self.data_2[indexPath.row];
        [self goDetail:data];
    }
}
-(void)goDetail:(id)data{
    EnvVar* env = [CGlobal sharedId].env;
    if ([data isKindOfClass:[OrderHisModel class]]) {
        OrderHisModel*model = data;
        UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
        OrderDetailViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
        dispatch_async(dispatch_get_main_queue(), ^{
            g_dateModel = model.dateModel;
            g_addressModel = model.addressModel;
            g_serviceModel = model.serviceModel;
            env.order_id = model.orderId;
            if (model.orderModel.product_type == g_CAMERA_OPTION) {
                g_ORDER_TYPE = g_CAMERA_OPTION;
                g_cameraOrderModel = model.orderModel;
            }else if (model.orderModel.product_type == g_ITEM_OPTION) {
                g_ORDER_TYPE = g_ITEM_OPTION;
                g_itemOrderModel = model.orderModel;
            }else if (model.orderModel.product_type == g_PACKAGE_OPTION) {
                g_ORDER_TYPE = g_PACKAGE_OPTION;
                g_packageOrderModel = model.orderModel;
            }
            
            vc.type = self.type;
            self.title = @"";
            [self.navigationController pushViewController:vc animated:true];
        });
    }else if ([data isKindOfClass:[OrderCorporateHisModel class]]) {
        OrderCorporateHisModel*model = data;
        UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
        OrderDetailCorViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderDetailCorViewController"];
        dispatch_async(dispatch_get_main_queue(), ^{
            g_dateModel = model.dateModel;
            g_addressModel = model.addressModel;
            g_serviceModel = model.serviceModel;
            
            g_carrierModel = model.carrierModel;
            env.order_id = model.orderId;
                        
            vc.type = self.type;
            vc.mode = self.mode;
            self.title = @"";
            [self.navigationController pushViewController:vc animated:true];
        });
    }
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
