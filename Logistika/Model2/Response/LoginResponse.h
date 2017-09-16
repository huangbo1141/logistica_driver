//
//  LoginResponse.h
//  Wordpress News App
//
//  Created by BoHuang on 5/25/16.
//  Copyright © 2016 Nikolay Yanev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TblUser.h"
#import "Route.h"

@interface LoginResponse : NSObject

@property (strong, nonatomic) TblUser* row ;


@property (strong, nonatomic) NSMutableArray* area ;
@property (strong, nonatomic) NSMutableArray* city ;
@property (strong, nonatomic) NSMutableArray* pincode ;
@property (strong, nonatomic) NSMutableArray* truck ;
@property (strong, nonatomic) NSMutableArray* wave ;

@property (strong, nonatomic) Route* route ;


@property (copy, nonatomic) NSString* action ;

-(instancetype)initWithDictionary:(NSDictionary*) dict;
-(instancetype)initWithDictionaryForWaveOrderModel:(NSDictionary*) dict;
-(instancetype)initWithDictionaryForCorWaveOrderModel:(NSDictionary*) dict;
-(instancetype)initWithDictionaryForRoute:(NSDictionary*) dict;
-(instancetype)initWithDictionaryForWavePersonalOrders:(NSDictionary*) dict;
-(instancetype)initWithDictionaryForWaveCorporateOrders:(NSDictionary*) dict;
@end
