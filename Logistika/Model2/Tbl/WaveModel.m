//
//  WaveModel.m
//  Logistika
//
//  Created by BoHuang on 8/1/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "WaveModel.h"

@implementation WaveModel
-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        [BaseModel parseResponse:self Dict:dict];
        
    }
    return self;
}
@end
