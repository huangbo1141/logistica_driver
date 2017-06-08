//
//  ColoredView.m
//  intuitive
//
//  Created by BoHuang on 4/17/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "ColoredView.h"
#import "CGlobal.h"

@implementation ColoredView

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
        case 4:{
            self.backgroundColor = [UIColor blueColor];
            break;
        }
        case 3:{
            // highlight menu view
            self.backgroundColor = [UIColor darkGrayColor];
            break;
        }
        case 2:{
            // white view
            self.backgroundColor = [CGlobal colorWithHexString:@"ffffff" Alpha:1.0f];
            break;
        }
        case 1:{
            // blue tone view
            self.backgroundColor = COLOR_PRIMARY;
            break;
        }
        default:
        {
            self.backgroundColor = [UIColor clearColor];
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