//
//  OrderItemTableViewCell1.m
//  Logistika
//
//  Created by BoHuang on 5/3/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "OrderItemTableViewCell1.h"
#import "OrderHisModel.h"
#import "OrderCorporateHisModel.h"


@implementation OrderItemTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderData:(id)data{
    self.data = data;
    if ([data isKindOfClass:[OrderHisModel class]]) {
        OrderHisModel*model = data;
        self.lblOrderID.text = [NSString stringWithFormat:@"Order Id:%@", model.orderId];
        self.lblDate.text = [NSString stringWithFormat:@"Date: %@ %@", model.dateModel.date,model.dateModel.time];
    }else if ([data isKindOfClass:[OrderCorporateHisModel class]]) {
        OrderCorporateHisModel*model = data;
        self.lblOrderID.text = [NSString stringWithFormat:@"Order Id:%@", model.orderId];
        self.lblDate.text = [NSString stringWithFormat:@"Date: %@ %@", model.dateModel.date,model.dateModel.time];
    }
}





@end
