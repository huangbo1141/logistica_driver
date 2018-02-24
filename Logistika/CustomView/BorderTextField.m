//
//  BorderTextField.m
//  Logistika
//
//  Created by BoHuang on 6/22/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BorderTextField.h"
#import "CGlobal.h"

@implementation BorderTextField

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
            // only bottom border
            if (_bottomLine==nil) {
                CALayer *border = [CALayer layer];
                CGFloat borderWidth = 0.8;
                border.borderColor = [UIColor darkGrayColor].CGColor;
                CGRect frame =CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
                border.frame = frame;
                border.borderWidth = borderWidth;
                [self.layer addSublayer:border];
                self.layer.masksToBounds = YES;
                
                UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
                self.leftView = paddingView;
                self.leftViewMode = UITextFieldViewModeAlways;
                
                _bottomLine = border;
                self.delegate = self;
            }
            
            break;
        }
        default:
        {
            break;
        }
    }
    _backMode = backMode;
}

-(void)addBotomLayer:(CGRect)param{
    if (_bottomLine!=nil) {
        [_bottomLine removeFromSuperlayer];
        _bottomLine = nil;
    }
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 0.8;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    CGRect frame =CGRectMake(0, param.size.height - borderWidth, param.size.width, param.size.height);
    border.frame = frame;
    border.borderWidth = borderWidth;
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    _bottomLine = border;
    
    self.delegate = self;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_bottomLine != nil) {
        CALayer *border = _bottomLine;
        border.borderColor = COLOR_PRIMARY.CGColor;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_bottomLine != nil) {
        CALayer *border = _bottomLine;
        border.borderColor = [UIColor darkGrayColor].CGColor;
    }
}
@end
