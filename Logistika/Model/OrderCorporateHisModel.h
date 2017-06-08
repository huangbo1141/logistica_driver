//
//  OrderCorporateHisModel.h
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BaseModel.h"
#import "AddressModel.h"
#import "ServiceModel.h"
#import "DateModel.h"
#import "CarrierModel.h"

@interface OrderCorporateHisModel : BaseModel
@property (nonatomic,copy) NSString* orderId;
@property (nonatomic,copy) NSString* trackId;
@property (nonatomic,copy) NSString* state;
@property (nonatomic,copy) NSString* freight;
@property (nonatomic,copy) NSString* payment;
@property (nonatomic,copy) NSString* receiver_signature;

@property (nonatomic,strong) AddressModel* addressModel;
@property (nonatomic,strong) ServiceModel* serviceModel;
@property (nonatomic,strong) DateModel* dateModel;
@property (nonatomic,strong) CarrierModel* carrierModel;
@end
