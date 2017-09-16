//
//  CountResponse.h
//  Logistika
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BaseModel.h"

@interface CountResponse : BaseModel
@property(copy,nonatomic) NSString* wave_count;
@property(copy,nonatomic) NSString* wave_order_count;
@property(copy,nonatomic) NSString* order_for_pickup;
@property(copy,nonatomic) NSString* pickedup;
@property(copy,nonatomic) NSString* completed;
@property(copy,nonatomic) NSString* onhold;
@property(copy,nonatomic) NSString* returned;


-(instancetype)initWithDictionary:(NSDictionary*) dict;
@end
