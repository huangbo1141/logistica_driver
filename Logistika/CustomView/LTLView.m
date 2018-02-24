//
//  LTLView.m
//  Logistika
//
//  Created by BoHuang on 6/8/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "LTLView.h"

@implementation LTLView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)clickAction:(id)sender {
    if (self.aDelegate !=nil) {
        [self.aDelegate didSubmit:@{@"truck":self.truck} View:self];
    }
}
-(void)firstProcess:(NSDictionary*)data{
    if (data[@"truck"]!=nil) {
        TblTruck* truck = data[@"truck"];
        self.truck = truck;
        self.lblContent.text = truck.name;
        
        if (data[@"aDelegate"]!=nil) {
            self.aDelegate = data[@"aDelegate"];
        }
    }
}
@end
