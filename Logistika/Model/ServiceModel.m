//
//  ServiceModel.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "ServiceModel.h"

@implementation ServiceModel
-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        [self initDefault];
        if (dict!=nil) {
            NSDictionary*abcDict = @{@"name":@"service_name" ,
                                     @"price":@"service_price",
                                     @"time_in":@"service_timein"};
            
            [BaseModel parseResponseABC:self Dict:dict ABC:abcDict];   
        }
//        [BaseModel parseResponse:self Dict:dict];
    }
    return self;
}
-(void)initDefault{
    self.time_in = @"In 8 hours";
}
@end