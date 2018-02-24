//
//  ViewPhotoFull.m
//  Logistika
//
//  Created by BoHuang on 6/7/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "ViewPhotoFull.h"

@implementation ViewPhotoFull

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)clickCancel:(id)sender {
    if (self.aDelegate!=nil) {
        [self.aDelegate didSubmit:nil View:self];
    }
}

-(void)firstProcess:(NSDictionary*)data{
    self.backgroundColor = [UIColor clearColor];
    if (data!=nil) {
        if (data[@"aDelegate"] != nil) {
            self.aDelegate = data[@"aDelegate"];
        }
        if (data[@"image"] != nil) {
            UIImage* image = data[@"image"];
            self.imgContent.image = image;
        }
        
    }
    
}
@end
