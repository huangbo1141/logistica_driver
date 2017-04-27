//
//  ReschedulePickUpTableViewCell.m
//  Logistika
//
//  Created by BoHuang on 4/26/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "ReschedulePickUpTableViewCell.h"
#import "CGlobal.h"
#import "ReviewCameraTableViewCell.h"
#import "ReviewItemTableViewCell.h"
#import "ReviewPackageTableViewCell.h"
#import "NetworkParser.h"
#import "TopBarView.h"
#import "AppDelegate.h"

@implementation ReschedulePickUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIDatePicker* date = [[UIDatePicker alloc] init];
    date.date = [NSDate date];
    date.datePickerMode = UIDatePickerModeDateAndTime;
    self.txtNewDate.inputView = date;
    self.datePicker = date;
    
    [date addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    date.tag = 200;
    
    self.dateModel = [[DateModel alloc] initWithDictionary:nil];
}
- (IBAction)clickAction:(id)sender {
    NSString* val = self.txtNewDate.text;
    if (val!=nil && [val length] > 0) {
        [CGlobal showIndicator:self.vc];
        NetworkParser* manager = [NetworkParser sharedManager];
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        params[@"id"] = self.data.orderId;
        params[@"date"] = self.dateModel.date;
        params[@"time"] = self.dateModel.time;
        
        [manager ontemplateGeneralRequest2:params BasePath:BASE_URL Path:@"order_corporate" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            if (error == nil) {
                if (dict!=nil && dict[@"result"] != nil) {
                    //
                    if([dict[@"result"] intValue] == 400){
                        NSString* message = @"Fail";
                        [CGlobal AlertMessage:message Title:nil];
                    }else if ([dict[@"result"] intValue] == 200){
                        NSString* message = @"Success";
                        [CGlobal AlertMessage:message Title:nil];
                        
                        // change page
                        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                        [delegate goHome:self.vc];
                    }
                }
            }else{
                NSLog(@"Error");
            }
            [CGlobal stopIndicator:self];
        } method:@"POST"];
    }else{
        [CGlobal AlertMessage:@"Choose Date" Title:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(OrderRescheduleModel*)model{
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
    
    self.txtCurrentDate.text = [NSString stringWithFormat:@"%@ %@",g_dateModel.date,g_dateModel.time];
    
    
    self.dateModel = [[DateModel alloc] initWithDictionary:nil];
    [self showItemLists:model];
    self.txtNewDate.text = @"";
    
}
-(void)timeChanged:(UIDatePicker*)picker{
    int tag = (int)picker.tag;
    switch (tag) {
        case 200:
        {
            NSDate* myDate = picker.date;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM-dd-yyyy hh:mm a"];
            NSString *prettyVersion = [dateFormat stringFromDate:myDate];
            _txtNewDate.text = prettyVersion;
            
            [dateFormat setDateFormat:@"MM-dd-yyyy"];
            prettyVersion = [dateFormat stringFromDate:myDate];
            self.dateModel.date = prettyVersion;
            
            [dateFormat setDateFormat:@"hh:mm a"];
            prettyVersion = [dateFormat stringFromDate:myDate];
            self.dateModel.time = prettyVersion;
            break;
        }
            
        default:
            break;
    }
}
-(void)showItemLists:(OrderRescheduleModel*)model{
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
@end
