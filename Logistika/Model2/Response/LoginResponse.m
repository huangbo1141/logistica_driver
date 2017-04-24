//
//  LoginResponse.m
//  Wordpress News App
//
//  Created by BoHuang on 5/25/16.
//  Copyright © 2016 Nikolay Yanev. All rights reserved.
//

#import "LoginResponse.h"
#import "BaseModel.h"
@implementation LoginResponse

-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        [BaseModel parseResponse:self Dict:dict];
        
        id obj = [dict objectForKey:@"row"];
        if (obj!=nil && obj!= [NSNull null]) {
            self.row = [[TblUser alloc] initWithDictionary:obj];
        }
        
    }
    return self;
}

@end
