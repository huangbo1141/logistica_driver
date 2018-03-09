//
//  PersonalMainViewController.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "PersonalMainViewController.h"
#import "CGlobal.h"
#import "OrderPickUpViewController.h"
#import "AppDelegate.h"
#import "WaveViewController.h"
#import "NetworkParser.h"
#import "CountResponse.h"
#import "MapsViewController.h"
#import "WaveOrderModel.h"
#import "WaveOrderCorModel.h"

@interface PersonalMainViewController ()

@end

@implementation PersonalMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = COLOR_SECONDARY_THIRD;
    // Do any additional setup after loading the view.
    
//    [self trackOrders:1];
    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    [userd setBool:true forKey:@"service_status_preference"];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.trackingController = nil;
    [delegate startOrStopTraccar];
    
//    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [delegate startTrackTimer];
    
    NSArray* array = @[_lblWaveCnt,_lblOrderCnt,_lblPickupCnt,_lblPickedCnt,_lblCompletedCnt,_lblHoldCnt,_lblReturnedCnt];
    for (int i=0; i< array.count; i++) {
        FontLabel* lbl = array[i];
        lbl.msize = 22;
    }
    [self get_truck];
}
-(void)get_truck{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [manager ontemplateGeneralRequest2:data BasePath:BASE_DATA_URL Path:@"get_truck" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                if ([dict[@"result"] intValue] == 200) {
                    LoginResponse* data = [[LoginResponse alloc] initWithDictionary:dict];
                    
                    g_truckModels = data;
                    
                }else{
                    //                    [CGlobal AlertMessage:@"Fail" Title:nil];
                }
            }
        }else{
            NSLog(@"Error");
        }
        
    } method:@"POST"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CGlobal clearData];
    
    [self.topBarView updateCaption];
    
    EnvVar* env = [CGlobal sharedId].env;
    env.quote = false;
    
    if ([g_visibleModel.waverVisible isEqualToString:@"0"]) {
        self.viewWave.hidden = true;
    }else{
        self.viewWave.hidden = false;
    }
    
    [self get_count_info];
    if ([g_visibleModel.waverVisible isEqualToString:@"0"]) {
        _viewWave.hidden = true;
        _viewRoute.hidden = true;
    }else{
        _viewWave.hidden = false;
        _viewRoute.hidden = false;
    }
}
-(void)get_count_info{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"order_type"] = @"0";
    params[@"employer_id"] = env.user_id;
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:g_URL Path:@"get_count_info" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 200){
                    CountResponse* resp = [[CountResponse alloc] initWithDictionary:dict];
                    _lblWaveCnt.text = resp.wave_count;
                    _lblOrderCnt.text = resp.wave_order_count;
                    _lblPickupCnt.text = resp.order_for_pickup;
                    _lblPickedCnt.text = resp.pickedup;
                    _lblCompletedCnt.text = resp.completed;
                    _lblHoldCnt.text = resp.onhold;
                    _lblReturnedCnt.text = resp.returned;
                }
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}
- (IBAction)clickWave:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    WaveViewController* vc = [ms instantiateViewControllerWithIdentifier:@"WaveViewController"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:true];
    });
}

- (IBAction)menu1:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    OrderPickUpViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderPickUpViewController"];
    vc.type = g_ORDER;
    vc.mode = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu2:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    OrderPickUpViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderPickUpViewController"];
    vc.type = g_PICKUP;
    vc.mode = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu3:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    OrderPickUpViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderPickUpViewController"];
    vc.type = g_COMPLETE;
    vc.mode = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu4:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    OrderPickUpViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderPickUpViewController"];
    vc.type = g_ONHOLD;
    vc.mode = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu5:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    OrderPickUpViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderPickUpViewController"];
    vc.type = g_RETURN;
    vc.mode = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)callHub:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:12125551212"]];
}
- (IBAction)clickRoute:(id)sender {
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"employer_id"] = env.user_id;
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:g_URL Path:@"get_wave_personal_orders" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 200){
                    LoginResponse* resp = [[LoginResponse alloc] initWithDictionaryForWavePersonalOrders:dict];
                    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Cor" bundle:nil];
                    MapsViewController* vc = (MapsViewController*)[ms instantiateViewControllerWithIdentifier:@"MapsViewController"];
                    [CGlobal sortWaveList:resp.wave];
                    vc.list_data = resp.wave;
                    vc.type = 0;
                    [self.navigationController pushViewController:vc animated:true];
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
