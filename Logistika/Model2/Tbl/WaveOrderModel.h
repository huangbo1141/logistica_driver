//
//  WaveOrderModel.h
//  Logistika
//
//  Created by BoHuang on 8/1/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BaseModel.h"
#import "AddressModel.h"
#import "ServiceModel.h"
#import "DateModel.h"
#import "OrderModel.h"

@interface WaveOrderModel : BaseModel
@property (nonatomic,copy) NSString* wave_id;
@property (nonatomic,copy) NSString* order_id;
@property (nonatomic,copy) NSString* priority;
@property (nonatomic,copy) NSString* name;

@property (nonatomic,copy) NSString* trackId;
@property (nonatomic,copy) NSString* state;

@property (nonatomic,strong) AddressModel* addressModel;
@property (nonatomic,strong) ServiceModel* serviceModel;
@property (nonatomic,strong) DateModel* dateModel;
@property (nonatomic,strong) OrderModel* orderModel;

-(instancetype)initWithDictionary:(NSDictionary*) dict;
@end
