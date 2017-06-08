//
//  TblArea.m
//  Logistika
//
//  Created by BoHuang on 6/6/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "TblArea.h"

@implementation TblArea
-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        [BaseModel parseResponse:self Dict:dict];
    }
    return self;
}
@end
