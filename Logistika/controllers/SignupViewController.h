//
//  SignupViewController.h
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIComboBox.h"
#import "BorderView.h"

@interface SignupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtPin;
@property (weak, nonatomic) IBOutlet UITextField *txtLandMark;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRePassword;
@property (weak, nonatomic) IBOutlet UITextField *txtAnswer;
@property (weak, nonatomic) IBOutlet UISwitch *swPolicy;
@property (weak, nonatomic) IBOutlet UIComboBox *cbAnswer;

@property (weak, nonatomic) IBOutlet BorderView *swTermView;
@property (weak, nonatomic) IBOutlet BorderView *swPolicyView;

@property (weak, nonatomic) IBOutlet UISwitch *swTerm;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;

@property (assign, nonatomic) NSInteger segIndex;

@property (strong, nonatomic) id inputData;
@end
