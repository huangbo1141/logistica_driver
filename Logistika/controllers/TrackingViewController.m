//
//  TrackingViewController.m
//  Logistika
//
//  Created by BoHuang on 4/24/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "TrackingViewController.h"
#import "CGlobal.h"
#import "ReviewCameraTableViewCell.h"
#import "ReviewItemTableViewCell.h"
#import "ReviewPackageTableViewCell.h"
#import "CameraOrderViewController.h"
#import "SelectItemViewController.h"
#import "SelectPackageViewController.h"
#import "AddressDetailViewController.h"
#import "DateTimeViewController.h"
#import "PaymentViewController.h"
#import "NetworkParser.h"
#import "RescheduleViewController.h"
#import "CancelPickViewController.h"

@interface TrackingViewController ()
@property (nonatomic,assign) CGFloat cellHeight;
@end

@implementation TrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setModelData:self.inputData VC:self];
    
}
-(void)setModelData:(OrderHisModel*)model VC:(UIViewController*)vc{
    if (model==nil) {
        return;
    }
    if (model.addressModel.desAddress!=nil) {
        _lblPickAddress.text = model.addressModel.sourceAddress;
        _lblPickCity.text = model.addressModel.sourceCity;
        _lblPickState.text = model.addressModel.sourceState;
        _lblPickPincode.text = model.addressModel.sourcePinCode;
        _lblPickPhone.text = model.addressModel.sourcePhonoe;
        _lblPickLandMark.text = model.addressModel.sourceLandMark;
        _lblPickInst.text = model.addressModel.sourceInstruction;
        
        _lblDestAddress.text = model.addressModel.desAddress;
        _lblDestCity.text = model.addressModel.desCity;
        _lblDestState.text = model.addressModel.desState;
        _lblDestPincode.text = model.addressModel.desPinCode;
        //        _lblDestPhone.text = model.addressModel.des;
        _lblDestLandMark.text = model.addressModel.desLandMark;
        _lblDestInst.text = model.addressModel.desInstruction;
    }
    _lblDestPhone.hidden = true;
    
    self.lblServiceLevel.text = [NSString stringWithFormat:@"Service Level %@, $%@, %@",g_serviceModel.name,g_serviceModel.price,g_serviceModel.time_in];
    
    self.lblPaymentMethod.text = model.payment;
    
    self.lblPickDate.text = [NSString stringWithFormat:@"Pick up on:%@ %@",g_dateModel.date,g_dateModel.time];
    
    
    
    [self showItemLists:model];
    
    
    self.lblOrderNumber.text = model.orderId;
    
    int state = [model.state intValue];
    switch (state) {
        case 0:
        {
            _lblTracking.text = @"Cancel";
            break;
        }
        case 1:
        {
            _lblTracking.text = @"Progressing";
            break;
        }
        case 2:
        {
            _lblTracking.text = @"On the way for pickup";
            break;
        }
        case 3:
        {
            _lblTracking.text = @"On the way to destination";
            break;
        }
        case 4:
        {
            _lblTracking.text = @"Order Delivered";
            break;
        }
        case 5:
        {
            _lblTracking.text = @"Order on hold";
            break;
        }
        case 6:
        {
            _lblTracking.text = @"Returned Order";
            break;
        }
        default:
            break;
    }
}

-(void)showItemLists:(OrderHisModel*)model{
    self.orderModel = model.orderModel;
    if (model.orderModel.product_type == g_CAMERA_OPTION) {
        
        self.viewHeader_CAMERA.hidden = false;
        self.viewHeader_ITEM.hidden = true;
        self.viewHeader_PACKAGE.hidden = true;
        
        UINib* nib = [UINib nibWithNibName:@"ReviewCameraTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
        self.cellHeight = 40;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }else if(g_ORDER_TYPE == g_ITEM_OPTION){
        self.viewHeader_CAMERA.hidden = true;
        self.viewHeader_ITEM.hidden = false;
        self.viewHeader_PACKAGE.hidden = true;
        
        UINib* nib = [UINib nibWithNibName:@"ReviewItemTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
        self.cellHeight = 40;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }else if(g_ORDER_TYPE == g_PACKAGE_OPTION){
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
    if (self.orderModel.product_type == g_CAMERA_OPTION) {
        ReviewCameraTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        [cell initMe:self.orderModel.itemModels[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aDelegate = self;
        return cell;
    }else if(self.orderModel.product_type == g_ITEM_OPTION){
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
