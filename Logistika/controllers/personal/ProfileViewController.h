//
//  ProfileViewController.h
//  Logistika
//
//  Created by BoHuang on 4/22/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BasicViewController.h"
#import "UIComboBox.h"
#import "BorderView.h"
#import "CAAutoCompleteObject.h"
#import "CAAutoFillTextField.h"

@interface ProfileViewController : BasicViewController

@property (weak, nonatomic) IBOutlet UILabel *lblPicker1;
@property (strong, nonatomic) UIView *viewPickerContainer1;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtState;

@property (weak, nonatomic) IBOutlet UITextField *txtLandMark;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRePassword;
@property (weak, nonatomic) IBOutlet UITextField *txtAnswer;

@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (assign, nonatomic) NSInteger segIndex;
@property (strong, nonatomic) id inputData;

@property (weak, nonatomic) IBOutlet CAAutoFillTextField *txtArea;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollParent;
@property (weak, nonatomic) IBOutlet CAAutoFillTextField *txtCity;
@property (weak, nonatomic) IBOutlet CAAutoFillTextField *txtPin;
@end
