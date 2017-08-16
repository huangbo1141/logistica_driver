//
//  ShipperDocTableViewCell.m
//  Logistika
//
//  Created by BoHuang on 8/2/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "ShipperDocTableViewCell.h"
#import "SelectImageCell.h"
#import "ItemModel.h"

@implementation ShipperDocTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickRemove:(id)sender {
    if (self.aDelegate!=nil) {
        [self.aDelegate didSubmit:@{@"action":@"delete",@"inputData":self.inputData} View:self];
    }
}

-(void)setData:(NSDictionary *)data{
    [super setData:data];
    if ([self.model isKindOfClass:[ItemModel class]]) {
        ItemModel* model = self.model;
        self.imgPhoto.image = model.image_data;
        
    }
}
@end
