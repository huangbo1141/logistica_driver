//
//  FeedBackViewController.h
//  Logistika
//
//  Created by BoHuang on 4/20/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "MenuViewController.h"
#import "ColoredButton.h"

@interface FeedBackViewController : MenuViewController
@property (weak, nonatomic) IBOutlet UITextField *txtFirst;
@property (weak, nonatomic) IBOutlet UITextField *txtLast;
@property (weak, nonatomic) IBOutlet UITextField *txtFeedback;

@property (weak, nonatomic) IBOutlet ColoredButton *btnSubmit;
@end
