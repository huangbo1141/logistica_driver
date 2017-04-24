//
//  PickAddressProfileViewController.m
//  Logistika
//
//  Created by BoHuang on 4/22/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "PickAddressProfileViewController.h"
#import "CGlobal.h"

@interface PickAddressProfileViewController ()

@end

@implementation PickAddressProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.swSelect setOn:false];
    
    EnvVar*env = [CGlobal sharedId].env;
    _txtPickAddress.text = env.address1;
    _txtPickCity.text = env.city;
    _txtPickState.text = env.state;
    _txtPickPincode.text = env.pincode;
    _txtPickLandMark.text = env.landmark;
    _txtPickPhone.text = env.phone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickContinue:(id)sender {
    if ([self.swSelect isOn]) {
        // pickup
        NSDictionary* data = @{@"type":self.type
                               ,@"address":_txtPickAddress.text
                               ,@"city":_txtPickCity.text
                               ,@"state":_txtPickState.text
                               ,@"pincode":_txtPickPincode.text
                               ,@"landmark":_txtPickLandMark.text
                               ,@"phone":_txtPickPhone.text};
        [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_ADDRESSPICKUP object:data];
        
    }else{
        // no pickup
    }
    [self.navigationController popViewControllerAnimated:true];
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
