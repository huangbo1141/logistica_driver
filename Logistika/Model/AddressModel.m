//
//  AddressModel.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        [self initDefault];
        [BaseModel parseResponse:self Dict:dict];
    }
    return self;
}
-(void)initDefault{
    self.sourceLat = 0;
    self.sourceLng = 0;
    
    self.desLat = 0;
    self.desLng = 0;
    
    self.duration = @"";
    self.distance = @"";
}
@end
