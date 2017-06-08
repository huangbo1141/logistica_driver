//
//  MyTextDelegate.m
//  Logistika
//
//  Created by BoHuang on 5/16/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "MyTextDelegate.h"

@implementation MyTextDelegate

-(instancetype)init{
    self = [super init];
    self.mode =  0;
    return self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (self.mode) {
        case 1:{
            if (string.length + textField.text.length > self.length) {
                NSLog(@"%d",string.length + textField.text.length );
                return NO;
            }
        }
        case 0:
        {
            // allow backspace
            if (!string.length)
            {
                return YES;
            }
            
            // Prevent invalid character input, if keyboard is numberpad
            if (textField.keyboardType == UIKeyboardTypeNumberPad)
            {
                if ([string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet].location != NSNotFound)
                {
                    // BasicAlert(@"", @"This field accepts only numeric entries.");
                    return NO;
                }
            }
            
            // verify max length has not been exceeded
            //    NSString *proposedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
            //
            //    if (proposedText.length > 4) // 4 was chosen for SSN verification
            //    {
            //        // suppress the max length message only when the user is typing
            //        // easy: pasted data has a length greater than 1; who copy/pastes one character?
            //        if (string.length > 1)
            //        {
            //            // BasicAlert(@"", @"This field accepts a maximum of 4 characters.");
            //        }
            //
            //        return NO;
            //    }
            //    
            //    // only enable the OK/submit button if they have entered all numbers for the last four of their SSN (prevents early submissions/trips to authentication server)
            //    self.answerButton.enabled = (proposedText.length == 4);
            
            return YES;
            break;
        }
            
            
        default:{
            break;
        }
            
    }
    return YES;
}
@end
