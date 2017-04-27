//
//  SelectItemViewController.h
//  Logistika
//
//  Created by BoHuang on 4/26/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "UIUnderlinedButton.h"


@interface SelectItemViewController : UIViewController
@property (strong,nonatomic) OrderModel* cameraOrderModel;

@property (strong, nonatomic) NSMutableArray* views;
@property (weak, nonatomic) IBOutlet UIUnderlinedButton *btnUploadMore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_TH;


@end
