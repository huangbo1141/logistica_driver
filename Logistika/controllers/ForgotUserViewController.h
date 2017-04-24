//
//  ForgotUserViewController.h
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotUserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtAnswer;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (assign, nonatomic) NSInteger segIndex;
@end
