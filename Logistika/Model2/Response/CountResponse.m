//
//  CountResponse.m
//  Logistika
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "CountResponse.h"

@implementation CountResponse
-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        [BaseModel parseResponse:self Dict:dict];
                
    }
    return self;
}
@end
