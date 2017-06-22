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
#import "BorderTextField.h"

@interface ProfileViewController : BasicViewController

@property (weak, nonatomic) IBOutlet UILabel *lblPicker1;
@property (strong, nonatomic) UIView *viewPickerContainer1;

@property (weak, nonatomic) IBOutlet BorderTextField *txtFirstName;
@property (weak, nonatomic) IBOutlet BorderTextField *txtLastName;
@property (weak, nonatomic) IBOutlet BorderTextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet BorderTextField *txtAddress;
@property (weak, nonatomic) IBOutlet BorderTextField *txtState;

@property (weak, nonatomic) IBOutlet BorderTextField *txtLandMark;
@property (weak, nonatomic) IBOutlet BorderTextField *txtEmail;
@property (weak, nonatomic) IBOutlet BorderTextField *txtPassword;
@property (weak, nonatomic) IBOutlet BorderTextField *txtRePassword;
@property (weak, nonatomic) IBOutlet BorderTextField *txtAnswer;

@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (assign, nonatomic) NSInteger segIndex;
@property (strong, nonatomic) id inputData;

@property (weak, nonatomic) IBOutlet CAAutoFillTextField *txtArea;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollParent;
@property (weak, nonatomic) IBOutlet CAAutoFillTextField *txtCity;
@property (weak, nonatomic) IBOutlet CAAutoFillTextField *txtPin;
@end
