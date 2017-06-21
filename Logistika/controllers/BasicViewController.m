//
//  BasicViewController.m
//  Logistika
//
//  Created by BoHuang on 5/11/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BasicViewController.h"
#import <IQKeyboardManager.h>
#import <IQKeyboardReturnKeyHandler.h>
#import "EnvVar.h"
#import "CGlobal.h"
#import "NetworkParser.h"
#import "OrderResponse.h"
#import "OrderHisModel.h"

@interface BasicViewController ()
@property (nonatomic,strong) IQKeyboardReturnKeyHandler* returnKeyHandler;

@property (nonatomic,strong) NSMutableArray* trackOrderStrs;

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    self.returnKeyHandler = nil;
}

-(void)getOrderAndStartService{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    EnvVar* env = [CGlobal sharedId].env;
    if (env.mode == c_PERSONAL) {
        params[@"employer_id"] = env.user_id;
    }else if(env.mode == c_CORPERATION){
        params[@"employer_id"] = env.corporate_user_id;
    }
    
    params[@"state"] = @"3";
    NetworkParser* manager = [NetworkParser sharedManager];
//    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:ORDER_URL Path:@"get_orders_by_state" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            // succ
            if (dict[@"result" ]!=nil) {
                if ([dict[@"result"] intValue] == 200) {
                    
                    // parse
                    OrderResponse* response = [[OrderResponse alloc] initWithDictionary_his:dict];
                    NSMutableArray* array = [[NSMutableArray alloc] init];
                    for (int i=0; i<response.orders.count; i++) {
                        OrderHisModel* order = response.orders[i];
                        NSString* track_str = [NSString stringWithFormat:@"%@,%d",order.orderId,c_PERSONAL];
                        [array addObject:track_str];
                    }
                    
                    self.trackOrderStrs = array;
                    
                    [self getCorporateOrders];
                    return;
                }
            }
            
        }else{
            // error
            NSLog(@"Error");
        }
        
//        [CGlobal stopIndicator:self];
    } method:@"POST"];
}
-(void)getCorporateOrders{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    EnvVar* env = [CGlobal sharedId].env;
    if (env.mode == c_PERSONAL) {
        params[@"employer_id"] = env.user_id;
    }else if(env.mode == c_CORPERATION){
        params[@"employer_id"] = env.corporate_user_id;
    }
    
    params[@"state"] = @"3";
    NetworkParser* manager = [NetworkParser sharedManager];
//    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:ORDER_URL Path:@"get_corporate_orders_by_state" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            // succ
            if (dict[@"result" ]!=nil) {
                if ([dict[@"result"] intValue] == 200) {
                    OrderResponse* response = [[OrderResponse alloc] initWithDictionary_his:dict];
                    NSMutableArray* array = self.trackOrderStrs;
                    for (int i=0; i<response.orders.count; i++) {
                        OrderHisModel* order = response.orders[i];
                        NSString* track_str = [NSString stringWithFormat:@"%@,%d",order.orderId,c_CORPERATION];
                        [array addObject:track_str];
                    }
                    
                    [CGlobal setOrderForTrackOrder:array];
                    self.trackOrderStrs = array;
                }
            }
            
        }else{
            // error
            NSLog(@"Error");
        }
        
//        [CGlobal stopIndicator:self];
    } method:@"POST"];
}
@end
