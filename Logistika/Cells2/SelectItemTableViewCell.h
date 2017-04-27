//
//  SelectItemTableViewCell.h
//  Logistika
//
//  Created by BoHuang on 4/26/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionDelegate.h"
#import "ItemModel.h"


@interface SelectItemTableViewCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *txtItem;
@property (weak, nonatomic) IBOutlet UITextField *txtL;
@property (weak, nonatomic) IBOutlet UITextField *txtB;
@property (weak, nonatomic) IBOutlet UITextField *txtH;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UITextField *txtWeight;

@property (strong,nonatomic) id<ActionDelegate> aDelegate;
@property (strong,nonatomic) ItemModel*data;
-(void)initMe:(ItemModel*)model;

@property (weak, nonatomic) IBOutlet UIButton *btnRemove;
@property (strong, nonatomic) UIPickerView*pkWeight;
@property (strong, nonatomic) UIPickerView*pkQuantity;

@end
