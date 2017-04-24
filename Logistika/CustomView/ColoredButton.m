//
//  ColoredButton.m
//  intuitive
//
//  Created by BoHuang on 4/17/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "ColoredButton.h"
#import "CGlobal.h"
@implementation ColoredButton

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
        case 1:{
            // Sign in button
            self.backgroundColor = [CGlobal colorWithHexString:@"d3d3d3" Alpha:1.0f];
            [self setTitleColor:[CGlobal colorWithHexString:@"2f4f4f" Alpha:1.0f] forState:UIControlStateNormal];
            // set font
            UIFont* font = [UIFont fontWithName:@"Verdana" size:15];
            self.titleLabel.font = font;
            break;
        }
        case 2:{
            
            break;
        }
        default:
        {
            
            break;
        }
    }
    _backMode = backMode;
}
-(void)setCornerRadious:(CGFloat)cornerRadious{
    if (cornerRadious>0) {
        self.layer.cornerRadius = cornerRadious;
        self.layer.masksToBounds = true;
    }
    _cornerRadious = cornerRadious;
}
@end
