//
//  OrderCorporateHisModel.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "OrderCorporateHisModel.h"

@implementation OrderCorporateHisModel
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
    self.carrierModel = [[CarrierModel alloc] initWithDictionary:nil];
    
}
@end
