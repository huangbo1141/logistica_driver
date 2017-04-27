//
//  OrderResponse.h
//  Logistika
//
//  Created by BoHuang on 4/27/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BaseModel.h"

@interface OrderResponse : BaseModel

@property (strong, nonatomic) NSMutableArray* orders;
-(instancetype)initWithDictionary:(NSDictionary*) dict;
-(instancetype)initWithDictionary_his:(NSDictionary*) dict;
@end
