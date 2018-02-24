//
//  TblAddress.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "TblAddress.h"

@implementation TblAddress
-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        [BaseModel parseResponse:self Dict:dict];
        
        if (self.address2 == nil) {
            self.address2 = dict[@"area"];
        }
        
    }
    return self;
}
@end
