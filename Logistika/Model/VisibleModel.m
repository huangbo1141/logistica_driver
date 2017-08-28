//
//  VisibleModel.m
//  Logistika
//
//  Created by BoHuang on 8/22/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "VisibleModel.h"

@implementation VisibleModel
-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        [self initDefault];
        if (dict!=nil) {
            NSDictionary*abcDict = @{@"id":@"id",@"signatureVisible":@"signature_visible" ,
                                     @"waverVisible":@"waver_visible",
                                     @"type":@"type",
                                     @"employer_id":@"employer_id"};
            
            [BaseModel parseResponseABC:self Dict:dict ABC:abcDict];
        }
        //        [BaseModel parseResponse:self Dict:dict];
    }
    return self;
}
-(void)initDefault{
    self.signatureVisible = @"0";
    self.waverVisible = @"0";
    self.type = @"0";
    self.employer_id = @"0";
}
@end
