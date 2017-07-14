//
//  LimitSpeedView.m
//  Logistika
//
//  Created by BoHuang on 7/12/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "LimitSpeedView.h"

@implementation LimitSpeedView

-(void)setBackMode:(NSInteger)backMode{
    _backMode = backMode;
    
}
-(void)setData:(NSDictionary *)data{
    [super setData:data];
    self.lblSpeed.text = data[@"speed"];
    self.lblSpeedLimit.text = data[@"speed_limit"];
    
    
}
- (IBAction)clickAction:(id)sender {
    [self removeFromSuperview];
}
@end
