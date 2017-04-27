//
//  CorMainViewController.m
//  Logistika
//
//  Created by BoHuang on 4/27/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "CorMainViewController.h"
#import "CGlobal.h"
#import "AddressDetailViewController.h"

@interface CorMainViewController ()

@end

@implementation CorMainViewController


- (IBAction)btnAction:(id)sender {
    if ([self checkInput]) {
        NSString*name = _txtName.text;
        NSString*email = _txtEmail.text;
        NSString*phone = _txtPhone.text;
        NSString*brief = _txtBrief.text;
        
        if ([CGlobal isValidEmail:email]) {
            if (g_corporateModel == nil) {
                g_corporateModel = [[CorporateModel alloc] init];
            }
            
            g_corporateModel.name = name;
            g_corporateModel.address = email;
            g_corporateModel.phone = phone;
            g_corporateModel.details = brief;
            
            UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
            AddressDetailViewController* vc = [ms instantiateViewControllerWithIdentifier:@"AddressDetailViewController"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController pushViewController:vc animated:true];
            });
        }else{
            [CGlobal AlertMessage:@"Invalid Email" Title:nil];
        }
    }else{
        [CGlobal AlertMessage:@"Please enter all info" Title:nil];
    }
}
-(id)checkInput{
    NSString*name = _txtName.text;
    NSString*email = _txtEmail.text;
    NSString*phone = _txtPhone.text;
    NSString*brief = _txtBrief.text;
    if ([name length] == 0 || [email length] == 0 || [phone length] == 0 || [brief length] == 0) {
        return nil;
    }
    return [NSNumber numberWithInt:1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
