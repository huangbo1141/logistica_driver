//
//  VisibleModel.h
//  Logistika
//
//  Created by BoHuang on 8/22/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BaseModel.h"

@interface VisibleModel : BaseModel

@property (nonatomic,copy) NSString* id;
@property (nonatomic,copy) NSString* employer_id;
@property (nonatomic,copy) NSString* type;
@property (nonatomic,copy) NSString* signatureVisible;
@property (nonatomic,copy) NSString* waverVisible;


-(instancetype)initWithDictionary:(NSDictionary*) dict;
-(void)initDefault;
@end
