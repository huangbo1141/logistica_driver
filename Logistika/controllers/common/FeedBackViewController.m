//
//  FeedBackViewController.m
//  Logistika
//
//  Created by BoHuang on 4/20/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "FeedBackViewController.h"
#import "CGlobal.h"
#import "NetworkParser.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_btnSubmit addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    _btnSubmit.tag = 200;
    EnvVar*env = [CGlobal sharedId].env;
    
    // Do any additional setup after loading the view.
}
-(NSMutableDictionary*)checkInput{
    NSString* mFirst = _txtFirst.text;
    NSString* mEmail = _txtLast.text;
    NSString* feed = _txtFeedback.text;
    NSArray* labels = @[mFirst,mEmail,feed];
    for (NSString*label in labels) {
        if ([label isEqualToString:@""]) {
            [CGlobal AlertMessage:@"Please enter all info" Title:nil];
            return nil;
        }
    }
    
    if (![CGlobal isValidEmail:mEmail]) {
        [CGlobal AlertMessage:@"Invalid Email" Title:nil];
        return nil;
    }
    EnvVar*env = [CGlobal sharedId].env;
    NSDictionary* tdata = @{@"user_mode":@"0"
                            ,@"name":mFirst
                            ,@"email":mEmail
                            ,@"feedback":feed
                            ,@"user_id":env.user_id
                            ,@"id":env.feedback_id};
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc] initWithDictionary:tdata];
    return data;
}
-(void)feedback:(NSMutableDictionary*)data{
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:data BasePath:BASE_URL Path:@"feedback" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                int ret = [dict[@"result"] intValue] ;
                if ([dict[@"result"] intValue] == 400) {
                    [CGlobal AlertMessage:@"Failed" Title:nil];
                    [CGlobal stopIndicator:self];
                    return;
                }
                EnvVar*env = [CGlobal sharedId].env;
                env.feedback_id = [NSString stringWithFormat:@"%d",ret];
                [CGlobal AlertMessage:@"Success" Title:nil];
            }
            
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}
-(void)clickView:(UIView*)sender{
    int tag = (int)sender.tag;
    NSMutableDictionary*data = [self checkInput];
    if (data!=nil) {
        UIAlertController* ac = [[UIAlertController alloc] init];
        UIAlertAction* ac1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // feedback
            [self feedback:data];
        }];
        UIAlertAction* ac2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:ac1];
        [ac addAction:ac2];
        [self presentViewController:ac animated:true completion:^{
            
        }];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
