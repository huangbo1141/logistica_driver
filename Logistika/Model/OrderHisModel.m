//
//  OrderHisModel.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "OrderHisModel.h"
#import "CGlobal.h"
#import "ItemModel.h"

@implementation OrderHisModel
-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        [self initDefault];
        if (dict!=nil) {
            
            NSDictionary*abcDict = @{@"orderId":@"id" ,
                                     @"trackId":@"id",
                                     @"state":@"state",
                                     @"payment":@"payment",
                                     @"receiver_signature":@"receiver_signature"};
            
            [BaseModel parseResponseABC:self Dict:dict ABC:abcDict];
            
            
            self.dateModel.date = dict[@"date"] ;
            self.dateModel.time = dict[@"time"] ;
            
            self.serviceModel.name = dict[@"service_name"] ;
            self.serviceModel.price = dict[@"service_price"] ;
            self.serviceModel.time_in = dict[@"service_timein"] ;
            
            
            if (dict[@"address"]!=nil) {
                NSArray*obj = dict[@"address"];
                for (int i=0; i<obj.count; i++) {
                    NSMutableDictionary*idict = obj[i];
                    self.addressModel = [[AddressModel alloc] initWithDictionary:idict];
                }
            }
            
            id obj = dict[@"products"];
            if (obj!=nil && obj!= [NSNull null]) {
                NSArray*array = obj;
                if ([obj isKindOfClass:[NSArray class]]) {
                    for (int i=0; i<array.count; i++) {
                        NSMutableDictionary*idict = array[i];
                        int product_type = [idict[@"product_type"] intValue];
                        ItemModel* model = [[ItemModel alloc] initWithDictionary:idict];
                        [self.orderModel.itemModels addObject:model];
                        self.orderModel.product_type = product_type;
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
    self.orderModel = [[OrderModel alloc] initWithDictionary:nil];
}
@end
