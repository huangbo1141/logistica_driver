//
//  WaveModel.h
//  Logistika
//
//  Created by BoHuang on 8/1/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BaseModel.h"

@interface WaveModel : BaseModel
@property (nonatomic,copy) NSString* id;
@property (nonatomic,copy) NSString* name;
-(instancetype)initWithDictionary:(NSDictionary*) dict;
@end
