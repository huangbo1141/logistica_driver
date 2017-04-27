//
//  ForgotUserViewController.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "ForgotUserViewController.h"
#import "NetworkParser.h"
#import "CGlobal.h"
#import "AppDelegate.h"

@interface ForgotUserViewController ()

@end

@implementation ForgotUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lblMessage.hidden = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickAction:(id)sender {
    if ([self checkInput]) {
        NSString*mName = _txtPhone.text;
        NSString*mAnswer= _txtAnswer.text;
        
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        params[@"phone"] = mName;
        params[@"answer"] = mAnswer;
        
        NetworkParser* manager = [NetworkParser sharedManager];
        [CGlobal showIndicator:self];
        [manager ontemplateGeneralRequest2:params BasePath:BASE_URL Path:@"forgotUserNameCustomer" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            if (error == nil) {
                if (dict!=nil && dict[@"result"] != nil) {
                    //
                    if([dict[@"result"] intValue] == 200){
                        NSDictionary* data = dict[@"data"];
                        NSString* email = data[@"email"];
                        
                        [self showPassword:email];
                    }else {
                        self.lblMessage.hidden = false;
                        NSString*message = [[NSBundle mainBundle] localizedStringForKey:@"password_error" value:@"" table:nil];
                        [CGlobal AlertMessage:message Title:nil];
                    }
                }
            }else{
                NSLog(@"Error");
            }
            [CGlobal stopIndicator:self];
        } method:@"POST"];
    }
}
-(void)showPassword:(NSString*)password{
    NSString*message = [[NSBundle mainBundle] localizedStringForKey:@"recovery_email" value:@"" table:nil];
    NSString* de = [NSString stringWithFormat:@"Email : %@",password];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:message message:de delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    alert.tag = 200;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    int tag = (int)alertView.tag;
    if (tag == 200) {
        if (buttonIndex == 0) {
            g_page_type = @"";
            // go home
            AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate goHome:self];
        }
    }
}
-(BOOL)checkInput{
    NSString*mName = _txtPhone.text;
    NSString*mAnswer= _txtAnswer.text;
    if ([mName length ] == 0 || [mAnswer length] == 0) {
        return false;
    }
    return true;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
