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

@interface CorMainViewController ()

@end

@implementation CorMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:false forKey:@"service_status_preference"];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate startOrStopTraccar];
    
    [self getOrderAndStartService];
    // Do any additional setup after loading the view.
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
