//
//  OrderItemTableViewCell1.h
//  Logistika
//
//  Created by BoHuang on 5/3/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderView.h"

@interface OrderItemTableViewCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOrderID;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet BorderView *viewBorder;

@property (strong,nonatomic) id data;
-(void)setOrderData:(id)data;
@end
