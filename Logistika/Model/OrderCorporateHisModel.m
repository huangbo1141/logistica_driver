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
//        [BaseModel parseResponse:self Dict:dict];
        if (dict!=nil) {
            
            NSDictionary*abcDict = @{@"orderId":@"id" ,
                                     @"trackId":@"id",
                                     @"state":@"state",
                                     @"freight":@"freight"};
            
            [BaseModel parseResponseABC:self Dict:dict ABC:abcDict];
            
            self.dateModel.date = dict[@"date"] ;
            self.dateModel.time = dict[@"time"] ;
            
            
//            self.serviceModel.name = dict[@"service_name"] ;
//            self.serviceModel.price = dict[@"service_price"] ;
//            self.serviceModel.time_in = dict[@"service_timein"] ;
            self.serviceModel = [[ServiceModel alloc] initWithDictionary:dict];
            
            if (dict[@"addresses"]!=nil) {
                NSArray*obj = dict[@"addresses"];
                if ([obj isKindOfClass:[NSArray class]]) {
                    for (int i=0; i<obj.count; i++) {
                        NSMutableDictionary*idict = obj[i];
                        self.addressModel = [[AddressModel alloc] initWithDictionary:idict];
                    }
                }
            }
            
            id obj = dict[@"carrier"];
            if (obj!=nil && obj!= [NSNull null]) {
                NSArray*array = obj;
                if ([obj isKindOfClass:[NSArray class]]) {
                    for (int i=0; i<array.count; i++) {
                        NSMutableDictionary*idict = array[i];
                        self.carrierModel = [[CarrierModel alloc] initWithDictionary:idict];
                        
                    }
                }
                
            }
        }
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
