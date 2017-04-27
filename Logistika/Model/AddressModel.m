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
        if (dict!=nil) {
            [BaseModel parseResponse:self Dict:dict];
            self.sourceAddress = dict[@"s_address"];
            self.sourceCity = dict[@"s_city"];
            self.sourceState = dict[@"s_state"];
            self.sourcePinCode = dict[@"s_pincode"];
            self.sourcePhonoe = dict[@"s_phone"];
            self.sourceLandMark = dict[@"s_landmark"];
            self.sourceInstruction = dict[@"s_instruction"];
            
            self.desAddress = dict[@"d_address"];
            self.desCity = dict[@"d_city"];
            self.desState = dict[@"d_state"];
            
            self.desPinCode = dict[@"d_pincode"];
            self.desLandMark = dict[@"d_landmark"];
            self.desInstruction = dict[@"d_instruction"];
            
            
        }
        
        
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
