//
//  WaveTableViewCell.m
//  Logistika
//
//  Created by BoHuang on 8/1/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "WaveTableViewCell.h"
#import "WaveOrderModel.h"
#import "WaveOrderCorModel.h"
#import "CGlobal.h"
#import "OrderDetailViewController.h"
#import "OrderDetailCorViewController.h"
#import "TblTruck.h"
#import "OrderMapViewController.h"

@implementation WaveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)data{
    [super setData:data];
    
    if ([self.model isKindOfClass:[WaveOrderModel class]]) {
        WaveOrderModel* model = self.model;
        self.lblOrderID.text = model.order_id;
        self.lblDate.text = [NSString stringWithFormat:@"Date: %@ %@",model.dateModel.date,model.dateModel.time];
        self.lblService.text = model.serviceModel.name;
        self.lblPriority.text = model.priority;
    }else{
        WaveOrderCorModel* model = self.model;
        self.lblOrderID.text = model.order_id;
        self.lblDate.text = [NSString stringWithFormat:@"Date: %@ %@",model.dateModel.date,model.dateModel.time];
        self.lblService.text = model.serviceModel.name;
        self.lblPriority.text = model.priority;
    }
}
- (IBAction)clickMap:(id)sender {
    if (self.vc!=nil) {
        if ([self.model isKindOfClass:[WaveOrderModel class]]) {
            WaveOrderModel* model = self.model;
            g_dateModel = model.dateModel;
            g_addressModel = model.addressModel;
            g_serviceModel = model.serviceModel;
            g_track_id = model.trackId;
            EnvVar* env = [CGlobal sharedId].env;
            env.order_id = model.order_id;
            if (model.orderModel.product_type == g_CAMERA_OPTION) {
                g_ORDER_TYPE = g_CAMERA_OPTION;
                g_cameraOrderModel = model.orderModel;
            }else if(model.orderModel.product_type == g_ITEM_OPTION) {
                g_ORDER_TYPE = g_ITEM_OPTION;
                g_itemOrderModel = model.orderModel;
            }else if(model.orderModel.product_type == g_PACKAGE_OPTION) {
                g_ORDER_TYPE = g_PACKAGE_OPTION;
                g_packageOrderModel = model.orderModel;
            }
            //
            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
            OrderMapViewController* ovc = [ms instantiateViewControllerWithIdentifier:@"OrderMapViewController"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.vc.navigationController pushViewController:ovc animated:true];
            });
            
            
        }else if ([self.model isKindOfClass:[WaveOrderCorModel class]]) {
            WaveOrderCorModel* model = self.model;
            g_dateModel = model.dateModel;
            g_addressModel = model.addressModel;
            g_serviceModel = model.serviceModel;
            g_track_id = model.track;
            EnvVar* env = [CGlobal sharedId].env;
            env.order_id = model.order_id;
            
            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
            OrderMapViewController* ovc = [ms instantiateViewControllerWithIdentifier:@"OrderMapViewController"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.vc.navigationController pushViewController:ovc animated:true];
            });
        }
    }
    
//    if (self.aDelegate!=nil) {
//        NSMutableDictionary*data = [[NSMutableDictionary alloc] init];
//        data[@"inputData"] = self.inputData;
//        
//        [self.aDelegate didSubmit:data View:self];
//    }
}
- (IBAction)clickNav:(id)sender {
    if (self.vc!=nil &&self.indexPath!=nil) {
        if ([self.model isKindOfClass:[WaveOrderModel class]]) {
            WaveOrderModel* model = self.model;
            g_dateModel = model.dateModel;
            g_addressModel = model.addressModel;
            g_serviceModel = model.serviceModel;
            g_track_id = model.trackId;
            EnvVar* env = [CGlobal sharedId].env;
            env.order_id = model.order_id;
            if (model.orderModel.product_type == g_CAMERA_OPTION) {
                g_ORDER_TYPE = g_CAMERA_OPTION;
                g_cameraOrderModel = model.orderModel;
            }else if(model.orderModel.product_type == g_ITEM_OPTION) {
                g_ORDER_TYPE = g_ITEM_OPTION;
                g_itemOrderModel = model.orderModel;
            }else if(model.orderModel.product_type == g_PACKAGE_OPTION) {
                g_ORDER_TYPE = g_PACKAGE_OPTION;
                g_packageOrderModel = model.orderModel;
            }
            //
            
            UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
            OrderDetailViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
            vc.type = [model.state intValue] - 2;
            [self.vc.navigationController pushViewController:vc animated:true];
            
            
        }else if ([self.model isKindOfClass:[WaveOrderCorModel class]]) {
            WaveOrderCorModel* model = self.model;
            g_dateModel = model.dateModel;
            g_addressModel = model.addressModel;
            g_serviceModel = model.serviceModel;
            g_track_id = model.track;
            EnvVar* env = [CGlobal sharedId].env;
            env.order_id = model.order_id;
            
            g_carrierModel = model.carrierModel;
            UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
            OrderDetailCorViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderDetailCorViewController"];
            vc.type = [model.state intValue] - 2;
            vc.mode = [self getMode:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                
//                self.title = @"";
                [self.vc.navigationController pushViewController:vc animated:true];
            });
        }
    }
}
-(NSString*)getMode:(WaveOrderCorModel*)model{
    for (int k=0; k<g_truckModels.truck.count; k++) {
        TblTruck*truck =  g_truckModels.truck[k];
        if ([truck.code isEqualToString:model.loadtype]) {
            return truck.code;
        }
    }
    return @"";
}


@end
