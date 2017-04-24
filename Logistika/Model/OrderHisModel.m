//
//  OrderHisModel.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "OrderHisModel.h"

@implementation OrderHisModel
-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        [self initDefault];
        [BaseModel parseResponse:self Dict:dict];
    }
    return self;
}
-(void)initDefault{    
    self.addressModel = [[AddressModel alloc] initWithDictionary:nil];
    self.serviceModel = [[ServiceModel alloc] initWithDictionary:nil];
    self.dateModel = [[DateModel alloc] initWithDictionary:nil];
    self.orderModel = [[OrderModel alloc] initWithDictionary:nil];
}
@end
