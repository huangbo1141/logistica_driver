//
//  PickAddressProfileViewController.h
//  Logistika
//
//  Created by BoHuang on 4/22/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickAddressProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtPickAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtPickCity;
@property (weak, nonatomic) IBOutlet UITextField *txtPickState;
@property (weak, nonatomic) IBOutlet UITextField *txtPickPincode;
@property (weak, nonatomic) IBOutlet UITextField *txtPickPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPickLandMark;

@property (weak, nonatomic) IBOutlet UISwitch *swSelect;

@property (copy, nonatomic) NSString* type;
@end
