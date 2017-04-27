//
//  MainViewController.m
//  Logistika
//
//  Created by BoHuang on 4/18/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "MainViewController.h"
#import "LeftView.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "CGlobal.h"
#import "UIView+Property.h"
#import "PersonalMainViewController.h"
#import "AppDelegate.h"
#import "MyNavViewController.h"
#import "NetworkParser.h"
#import "OrderResponse.h"
#import "TrackingViewController.h"

@interface MainViewController ()
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_segment addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
    
    [_btnSignIn addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnSignUp addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnGuest addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnTracking addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnCall addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnSignIn.tag = 200;
    _btnSignUp.tag = 201;
    _btnGuest.tag = 202;
    _btnTracking.tag = 203;
    _btnCall.tag = 204;
}
-(void)clickView:(UIView*)sender{
    int tag = (int)sender.tag;
    switch (tag) {
        case 200:
        {
            // sign in
            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController*vc = [ms instantiateViewControllerWithIdentifier:@"LoginViewController"] ;
            vc.segIndex = self.segment.selectedSegmentIndex;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBar.hidden = false;
                [self.navigationController pushViewController:vc animated:true];
            });
            break;
        }
        case 201:
        {
            // sign up
            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SignupViewController*vc = [ms instantiateViewControllerWithIdentifier:@"SignupViewController"] ;
            vc.segIndex = self.segment.selectedSegmentIndex;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBar.hidden = false;
                [self.navigationController pushViewController:vc animated:true];
            });
            break;
        }
        case 202:
        {
            EnvVar*env = [CGlobal sharedId].env;
            env.lastLogin = 0;
            g_mode = c_GUEST;
            env.mode = c_GUEST;
            
            
            
            // LoginProcess
            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
            PersonalMainViewController*vc = [ms instantiateViewControllerWithIdentifier:@"PersonalMainViewController"] ;
            MyNavViewController* nav = [[MyNavViewController alloc] initWithRootViewController:vc];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                delegate.window.rootViewController = nav;
            });
            break;
        }
        case 203:
        {
            // tracking
            // hgcneed
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                      message: @"Input Tracking Number"
                                                                               preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Tracking Number";
                textField.textColor = [UIColor blueColor];
                textField.borderStyle = UITextBorderStyleLine;
            }];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSArray * textfields = alertController.textFields;
                UITextField * namefield = textfields[0];
                NSString* number = namefield.text;
                if ([number length]>0) {
                    [self tracking:number];
                }
                
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
        case 204:
        {
            // call
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:12125551212"]];
            break;
        }
        default:
            break;
    }
}
-(void)tracking:(NSString*)number{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"id"] = number;
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:BASE_URL_ORDER Path:@"tracking" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil) {
                OrderResponse* response = [[OrderResponse alloc] initWithDictionary_his:dict];
                UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
                
                TrackingViewController*vc = [ms instantiateViewControllerWithIdentifier:@"TrackingViewController"] ;
                vc.response = response;
                vc.inputData = response.orders[0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.navigationController.navigationBar.hidden = true;
                    self.navigationController.viewControllers = @[vc];
                });
                
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}
-(void)onChange:(UISegmentedControl*)seg{
    NSInteger index = seg.selectedSegmentIndex;
    if (index == 0) {
        _btnGuest.hidden = false;
    }else{
        _btnGuest.hidden = true;
    }
}
-(void)onLeftItemTouched:(UIBarButtonItem*)sender{
    if (self.view.drawerLayout!=nil) {
        self.view.drawerLayout.openFromRight = NO;
        [self.view.drawerLayout openDrawer];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
