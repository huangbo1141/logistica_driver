//
//  AddressDetailViewController.h
//  Logistika
//
//  Created by BoHuang on 4/22/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUnderlinedButton.h"
#import "OrderModel.h"

@interface AddressDetailViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtPickAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtPickCity;
@property (weak, nonatomic) IBOutlet UITextField *txtPickState;
@property (weak, nonatomic) IBOutlet UITextField *txtPickPincode;
@property (weak, nonatomic) IBOutlet UITextField *txtPickPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPickLandMark;
@property (weak, nonatomic) IBOutlet UITextField *txtPickInstruction;

@property (weak, nonatomic) IBOutlet UIView *viewChooseFromProfile;
@property (weak, nonatomic) IBOutlet UIUnderlinedButton *btnChoose;

@property (weak, nonatomic) IBOutlet UIView *viewChooseFromProfile2;
@property (weak, nonatomic) IBOutlet UIUnderlinedButton *btnChoose2;

@property (weak, nonatomic) IBOutlet UITextField *txtDesAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtDesCity;
@property (weak, nonatomic) IBOutlet UITextField *txtDesState;
@property (weak, nonatomic) IBOutlet UITextField *txtDesPincode;
@property (weak, nonatomic) IBOutlet UITextField *txtDesPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtDesLandMark;
@property (weak, nonatomic) IBOutlet UITextField *txtDesInstruction;

@property (copy, nonatomic) NSString* type;
@property (weak, nonatomic) IBOutlet UISwitch *swQuote;
@property (weak, nonatomic) IBOutlet UIView *viewQuote;

@end
