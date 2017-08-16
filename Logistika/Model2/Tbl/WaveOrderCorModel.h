//
//  WaveOrderCorModel.h
//  Logistika
//
//  Created by BoHuang on 8/1/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BaseModel.h"
#import "CarrierModel.h"
#import "AddressModel.h"
#import "ServiceModel.h"
#import "DateModel.h"

@interface WaveOrderCorModel : BaseModel
@property (nonatomic,copy) NSString* wave_id;
@property (nonatomic,copy) NSString* order_id;
@property (nonatomic,copy) NSString* priority;

@property (nonatomic,copy) NSString* wave_name;

@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* email;
@property (nonatomic,copy) NSString* phone;
@property (nonatomic,copy) NSString* ddescription;
@property (nonatomic,copy) NSString* loadtype;

@property (nonatomic,copy) NSString* track;
@property (nonatomic,copy) NSString* state;
@property (nonatomic,copy) NSString* payment;
@property (nonatomic,copy) NSString* eta;
@property (nonatomic,copy) NSString* receiver_signature;

@property (nonatomic,strong) CarrierModel* carrierModel;
@property (nonatomic,strong) AddressModel* addressModel;
@property (nonatomic,strong) ServiceModel* serviceModel;
@property (nonatomic,strong) DateModel* dateModel;

-(instancetype)initWithDictionary:(NSDictionary*) dict;
@end
