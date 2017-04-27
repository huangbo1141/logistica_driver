//
//  DateTimeViewController.h
//  Logistika
//
//  Created by BoHuang on 4/22/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderView.h"

@interface DateTimeViewController : UIViewController
@property (weak, nonatomic) IBOutlet BorderView *viewPrice1;
@property (weak, nonatomic) IBOutlet BorderView *viewPrice2;
@property (weak, nonatomic) IBOutlet BorderView *viewPrice3;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice1_1;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice1_2;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice1_3;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice2_1;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice2_2;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice2_3;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice3_1;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice3_2;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice3_3;

@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtTime;
@property (weak, nonatomic) IBOutlet UIButton *btnReview;

@property (weak, nonatomic) IBOutlet UIView *viewExpress;

@end



