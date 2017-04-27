//
//  CorMainViewController.h
//  Logistika
//
//  Created by BoHuang on 4/27/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "MenuViewController.h"
#import "ColoredButton.h"

@interface CorMainViewController : MenuViewController

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtBrief;
@property (weak, nonatomic) IBOutlet ColoredButton *btnAction;

@end
