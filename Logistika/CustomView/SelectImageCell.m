//
//  SelectImageCell.m
//  Logistika
//
//  Created by BoHuang on 4/20/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "SelectImageCell.h"
#import "CGlobal.h"

@implementation SelectImageCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setStyleWithData:(NSMutableDictionary*)data Mode:(int)mode{
    _mode = [NSNumber numberWithInt:mode];
    
    self.hidden = false;
    self.filePath = data[@"path"];

    self.imgContent.image = data[@"image"];
    self.image =  data[@"image"];
//    [CGlobal getImageFromPath:self.filePath CallBack:^(UIImage *image) {
//        if (image!=nil) {
//            self.imgContent.image = image;
//        }else{
//            [CGlobal AlertMessage:@"Error" Title:nil];
//        }
//    }];
    
}

- (IBAction)onClose:(id)sender {
    if (_aDelegate!=nil) {
        [_aDelegate didSubmit:@{@"mode":_mode} View:self];
        self.filePath = nil;
    }
}
@end
