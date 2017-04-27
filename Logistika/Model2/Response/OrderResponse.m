//
//  OrderResponse.m
//  Logistika
//
//  Created by BoHuang on 4/27/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "OrderResponse.h"
#import "OrderRescheduleModel.h"
#import "OrderHisModel.h"

@implementation OrderResponse
-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        [BaseModel parseResponse:self Dict:dict];
        
        id obj = [dict objectForKey:@"orders"];
        if (obj!=nil && obj!= [NSNull null]) {
            NSArray*array = obj;
            if ([obj isKindOfClass:[NSArray class]]) {
                self.orders = [[NSMutableArray alloc] init];
                for (int i=0; i< [array count]; i++) {
                    OrderRescheduleModel *ach = [[OrderRescheduleModel alloc] initWithDictionary:array[i]];
                    [self.orders addObject:ach];
                }
            }
        }
        
    }
    return self;
}
-(instancetype)initWithDictionary_his:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        [BaseModel parseResponse:self Dict:dict];
        
        id obj = [dict objectForKey:@"orders"];
        if (obj!=nil && obj!= [NSNull null]) {
            NSArray*array = obj;
            if ([obj isKindOfClass:[NSArray class]]) {
                self.orders = [[NSMutableArray alloc] init];
                for (int i=0; i< [array count]; i++) {
                    OrderHisModel *ach = [[OrderHisModel alloc] initWithDictionary:array[i]];
                    [self.orders addObject:ach];
                }
            }
        }
        
    }
    return self;
}
@end
