//
//  FontLabel.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "FontLabel.h"
#import "CGlobal.h"

@implementation FontLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        //[self customInit];
    }
    return self;
}
-(void)setBackMode:(NSInteger)backMode{
    switch (backMode) {
        default:
        {
            
            break;
        }
    }
    _backMode = backMode;
}
-(void)setMsize:(CGFloat)msize{
    if (msize > 0) {
        UIFont* font = [UIFont fontWithName:@"Verdana" size:msize];
        self.font = font;
    }
}
@end
