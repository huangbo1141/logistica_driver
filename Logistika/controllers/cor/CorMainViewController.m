//
//  CorMainViewController.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "CorMainViewController.h"
#import "CGlobal.h"
#import "LTLViewController.h"
#import "AppDelegate.h"
#import "NetworkParser.h"
#import "OrderResponse.h"
#import "OrderHisModel.h"
#import "WaveViewController.h"

@interface CorMainViewController ()

@end

@implementation CorMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self trackCorporateOrders];
    // Do any additional setup after loading the view.
    
//    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
//    [userd setBool:true forKey:@"service_status_preference"];
//    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    delegate.trackingController = nil;
//    [delegate startOrStopTraccar];
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate startTrackTimer];
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
}
- (IBAction)clickWave:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    WaveViewController* vc = [ms instantiateViewControllerWithIdentifier:@"WaveViewController"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu1:(id)sender {
    UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Cor" bundle:nil];
    LTLViewController* vc = [ms instantiateViewControllerWithIdentifier:@"LTLViewController"];
    dispatch_async(dispatch_get_main_queue(), ^{
        vc.type = g_ORDER;
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu2:(id)sender {
    UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Cor" bundle:nil];
    LTLViewController* vc = [ms instantiateViewControllerWithIdentifier:@"LTLViewController"];
    dispatch_async(dispatch_get_main_queue(), ^{
        vc.type = g_PICKUP;
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu3:(id)sender {
    UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Cor" bundle:nil];
    LTLViewController* vc = [ms instantiateViewControllerWithIdentifier:@"LTLViewController"];
    dispatch_async(dispatch_get_main_queue(), ^{
        vc.type = g_COMPLETE;
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu4:(id)sender {
    UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Cor" bundle:nil];
    LTLViewController* vc = [ms instantiateViewControllerWithIdentifier:@"LTLViewController"];
    dispatch_async(dispatch_get_main_queue(), ^{
        vc.type = g_ONHOLD;
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu5:(id)sender {
    
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
