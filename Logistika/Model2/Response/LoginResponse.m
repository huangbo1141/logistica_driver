//
//  LoginResponse.m
//  Wordpress News App
//
//  Created by BoHuang on 5/25/16.
//  Copyright © 2016 Nikolay Yanev. All rights reserved.
//

#import "LoginResponse.h"
#import "BaseModel.h"
#import "TblArea.h"
#import "TblTruck.h"

@implementation LoginResponse

-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        [BaseModel parseResponse:self Dict:dict];
        
        id obj = [dict objectForKey:@"row"];
        if (obj!=nil && obj!= [NSNull null]) {
            self.row = [[TblUser alloc] initWithDictionary:obj];
        }
        
        obj = [dict objectForKey:@"area"];
        if (obj!=nil && obj!= [NSNull null]) {
            NSArray* list = (NSArray*)obj;
            self.area = [[NSMutableArray alloc] init];
            for (int i=0; i<list.count; i++) {
                TblArea* area = [[TblArea alloc] initWithDictionary:list[i]];
                [self.area addObject:area];
            }
        }
        
        obj = [dict objectForKey:@"city"];
        if (obj!=nil && obj!= [NSNull null]) {
            NSArray* list = (NSArray*)obj;
            self.city = [[NSMutableArray alloc] init];
            for (int i=0; i<list.count; i++) {
                TblArea* area = [[TblArea alloc] initWithDictionary:list[i]];
                [self.city addObject:area];
            }
        }
        
        obj = [dict objectForKey:@"pincode"];
        if (obj!=nil && obj!= [NSNull null]) {
            NSArray* list = (NSArray*)obj;
            self.pincode = [[NSMutableArray alloc] init];
            for (int i=0; i<list.count; i++) {
                TblArea* area = [[TblArea alloc] initWithDictionary:list[i]];
                [self.pincode addObject:area];
            }
        }
        obj = [dict objectForKey:@"truck"];
        if (obj!=nil && obj!= [NSNull null]) {
            NSArray* list = (NSArray*)obj;
            self.truck = [[NSMutableArray alloc] init];
            for (int i=0; i<list.count; i++) {
                TblTruck* area = [[TblTruck alloc] initWithDictionary:list[i]];
                [self.truck addObject:area];
            }
        }
    }
    return self;
}

@end
