//
//  PersonalMainViewController.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "PersonalMainViewController.h"
#import "CGlobal.h"
#import "PhotoUploadViewController.h"
#import "SelectItemViewController.h"

@interface PersonalMainViewController ()

@end

@implementation PersonalMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    EnvVar* env = [CGlobal sharedId].env;
    env.quote = false;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menu1:(id)sender {
    UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    PhotoUploadViewController* vc = [ms instantiateViewControllerWithIdentifier:@"PhotoUploadViewController"];
    dispatch_async(dispatch_get_main_queue(), ^{
        vc.limit =  3;
        g_ORDER_TYPE = g_CAMERA_OPTION;
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu2:(id)sender {
    UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    SelectItemViewController* vc = [ms instantiateViewControllerWithIdentifier:@"SelectItemViewController"];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        g_ORDER_TYPE = g_CAMERA_OPTION;
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu3:(id)sender {
    UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    SelectItemViewController* vc = [ms instantiateViewControllerWithIdentifier:@"SelectItemViewController"];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        g_ORDER_TYPE = g_PACKAGE_OPTION;
        [self.navigationController pushViewController:vc animated:true];
    });
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
