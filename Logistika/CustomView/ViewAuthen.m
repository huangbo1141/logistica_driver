//
//  ViewAuthen.m
//  Logistika
//
//  Created by BoHuang on 6/7/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "ViewAuthen.h"

@implementation ViewAuthen

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)firstProcess:(NSDictionary*)data{
    if (data!=nil) {
        if (data[@"aDelegate"]!=nil) {
            self.aDelegate = data[@"aDelegate"];
        }
    }
}
- (IBAction)clickOK:(id)sender {
    NSString* auth = _edtAuthentication.text;
    if ([_edtAuthentication.text length]>0) {
        if (self.aDelegate!=nil) {
            [self.aDelegate didSubmit:@{@"data":auth} View:self];
        }
    }
}

@end
