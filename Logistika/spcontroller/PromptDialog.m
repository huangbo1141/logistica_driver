//
//  PromptDialog.m
//  intuitive
//
//  Created by BoHuang on 7/8/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "PromptDialog.h"
#import "UIView+Property.h"
#import "MyPopupDialog.h"

@implementation PromptDialog

-(void)setData:(NSDictionary *)data{
    [super setData:data];
    
    self.lblTitle.text = data[@"title"];
}
- (IBAction)clickAction:(id)sender {
    if (self.aDelegate !=nil) {
        [self.aDelegate didSubmit:self.inputData View:self];
    }else{
        NSString* action = self.inputData[@"action"];
        if([action isKindOfClass:[NSString class]]){
            if ([action isEqualToString:@"exit"]) {
                if (self.vc!=nil) {
                    [self.vc.navigationController popViewControllerAnimated:true];
                }
            }
        }
        
        if ([self.xo isKindOfClass:[MyPopupDialog class]]) {
            MyPopupDialog* dialog = (MyPopupDialog*)self.xo;
            [dialog dismissPopup];
        }
    }
}

@end
