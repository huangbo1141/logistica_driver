//
//  BreakView.m
//  Logistika
//
//  Created by BoHuang on 7/14/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BreakView.h"
#import "UIView+Property.h"
#import "CGlobal.h"

@implementation BreakView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setData:(NSDictionary *)data{
    [super setData:data];
    
}
- (IBAction)clickAction:(UIView*)sender {
    
    if ([self.xo isKindOfClass:[MyPopupDialog class]]) {
        MyPopupDialog* dialog = (MyPopupDialog*)self.xo;
        [dialog dismissPopup];
    }
    [_breakSound stop];
    g_breakShowing = false;
}
@end
