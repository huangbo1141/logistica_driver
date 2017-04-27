//
//  DateTimeViewController.m
//  Logistika
//
//  Created by BoHuang on 4/22/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "DateTimeViewController.h"
#import "CGlobal.h"
#import "NSArray+BVJSONString.h"
#import "NetworkParser.h"
#import "AppDelegate.h"
#import "ReviewOrderViewController.h"

@interface DateTimeViewController ()
@property (assign,nonatomic) int index;
@property (assign,nonatomic) BOOL chooseService;
@end

@implementation DateTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chooseService = false;
    self.index = -1;
    // Do any additional setup after loading the view.
    UIDatePicker* date = [[UIDatePicker alloc] init];
    date.date = [NSDate date];
    date.datePickerMode = UIDatePickerModeDate;
    self.txtDate.inputView = date;
    
    UIDatePicker*time = [[UIDatePicker alloc] init];
    time.date = [NSDate date];
    time.datePickerMode = UIDatePickerModeTime;
    self.txtTime.inputView = time;
    
    [date addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    date.tag = 200;
    
    [time addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    time.tag = 201;
    
    UITapGestureRecognizer* gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [_viewPrice1 addGestureRecognizer:gesture1];
    _viewPrice1.tag = 200;
    _viewPrice1.userInteractionEnabled = true;
    
    UITapGestureRecognizer* gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [_viewPrice2 addGestureRecognizer:gesture2];
    _viewPrice2.tag = 201;
    _viewPrice2.userInteractionEnabled = true;
    
    UITapGestureRecognizer* gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [_viewPrice3 addGestureRecognizer:gesture3];
    _viewPrice3.tag = 202;
    _viewPrice3.userInteractionEnabled = true;
    
    NSDate* myDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    _txtDate.text = prettyVersion;
    
    [dateFormat setDateFormat:@"hh:mm a"];
    NSString *prettyVersion2 = [dateFormat stringFromDate:myDate];
    _txtTime.text = prettyVersion2;
    
    if (g_dateModel!=nil && g_dateModel.time!=nil) {
        _txtTime.text = g_dateModel.time;
    }else{
        if (g_dateModel == nil) {
            g_dateModel = [[DateModel alloc] initWithDictionary:nil];
        }
        g_dateModel.time = _txtTime.text;
    }
    if (g_dateModel!=nil && g_dateModel.date!=nil) {
        _txtDate.text = g_dateModel.date;
    }else{
        if (g_dateModel == nil) {
            g_dateModel = [[DateModel alloc] initWithDictionary:nil];
        }
        g_dateModel.date = _txtDate.text;
    }
    
    EnvVar* env = [CGlobal sharedId].env;
    if (env.mode != c_CORPERATION) {
        [self addService];
    }else{
        if(env.quote ){
            [self addService];
            [self.btnReview setTitle:@"Continue" forState:UIControlStateNormal];
        }else{
            self.viewExpress.hidden = true;
            [self.btnReview setTitle:@"Send Email" forState:UIControlStateNormal];
        }
    }
}
-(void)addService{
    if (g_isii) {
        return;
    }
    self.lblPrice1_2.text = g_priceType.expeditied_price;
    self.lblPrice1_3.text = g_priceType.expedited_duration;
    
    self.lblPrice2_2.text = g_priceType.express_price;
    self.lblPrice2_3.text = g_priceType.express_duration;
    
    self.lblPrice3_2.text = g_priceType.economy_price;
    self.lblPrice3_3.text = g_priceType.economy_duraiton;
    
    if (g_serviceModel!=nil && g_serviceModel.name!=nil) {
        if([g_serviceModel.name isEqualToString:@"Expedited"]){
            [self chooseService:0];
        }else if([g_serviceModel.name isEqualToString:@"Express"]){
            [self chooseService:1];
        }else if([g_serviceModel.name isEqualToString:@"Economy"]){
            [self chooseService:2];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Date & Time";
}
-(void)tapView:(UITapGestureRecognizer*)gesture{
    if (gesture.view!=nil) {
        int tag = (int)gesture.view.tag;
        int index = tag - 200;
        [self chooseService:index];
    }
}
-(void)chooseService:(int)index{
    self.chooseService = true;
    NSArray* array = @[self.viewPrice1,self.viewPrice2,self.viewPrice3];
    for (int i=0; i< array.count; i++) {
        UIView* view = array[i];
        view.backgroundColor = [UIColor clearColor];
    }
    UIView* view = array[index];
    view.backgroundColor = COLOR_PRIMARY;
    self.index = index;
}
-(void)timeChanged:(UIDatePicker*)picker{
    int tag = (int)picker.tag;
    switch (tag) {
        case 200:
        {
            NSDate* myDate = picker.date;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM-dd-yyyy"];
            NSString *prettyVersion = [dateFormat stringFromDate:myDate];
            _txtDate.text = prettyVersion;
            
            g_dateModel.date = prettyVersion;
            break;
        }
        case 201:{
            NSDate* myDate = picker.date;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"hh:mm a"];
            NSString *prettyVersion = [dateFormat stringFromDate:myDate];
            _txtTime.text = prettyVersion;
            
            g_dateModel.time = prettyVersion;
            break;
        }
            
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickContinue:(id)sender {
    
    EnvVar* env = [CGlobal sharedId].env;
    if (env.mode != c_CORPERATION || env.quote ) {
        if (self.index>=0) {
            UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
            ReviewOrderViewController* vc = [ms instantiateViewControllerWithIdentifier:@"ReviewOrderViewController"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:vc animated:true];
            });
        }else{
            [CGlobal AlertMessage:@"Choose Service" Title:nil];
        }
    }else{
        [self order_corporate];
    }
}
-(void)order_corporate{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"id"] = env.cor_order_id;
    params[@"user_id"] = env.corporate_user_id;
    params[@"name"] = g_corporateModel.name;
    params[@"address"] = g_corporateModel.address;
    params[@"phone"] = g_corporateModel.phone;
    params[@"description"] = g_corporateModel.details;
    params[@"date"] = g_dateModel.date;
    params[@"time"] = g_dateModel.time;
    
    NSDictionary*jsonMap = @{@"s_address":g_addressModel.sourceAddress
                             ,@"s_city":g_addressModel.sourceCity
                             ,@"s_state":g_addressModel.sourceState
                             ,@"s_pincode":g_addressModel.sourcePinCode
                             ,@"s_phone":g_addressModel.sourcePhonoe
                             ,@"s_landmark":g_addressModel.sourceLandMark
                             ,@"s_instruction":g_addressModel.sourceInstruction
                             ,@"d_address":g_addressModel.desAddress
                             ,@"d_city":g_addressModel.desCity
                             ,@"d_state":g_addressModel.desState
                             ,@"d_pincode":g_addressModel.desPinCode
                             ,@"d_landmark":g_addressModel.desLandMark
                             ,@"d_instruction":g_addressModel.desInstruction};
    
    NSArray*addressArray = @[jsonMap];
    params[@"orderaddress"] = [addressArray bv_jsonStringWithPrettyPrint:true];
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:BASE_URL Path:@"order_corporate" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 400){
                    NSString* message = [[NSBundle mainBundle] localizedStringForKey:@"quote_message" value:@"" table:nil];
                    [CGlobal AlertMessage:message Title:nil];
                }else if ([dict[@"result"] intValue] == 200){
                    NSString* order_id = dict[@"order_id"];
                    NSString* content = [[NSBundle mainBundle] localizedStringForKey:@"email_corporation" value:@"" table:nil];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"I Agree", nil];
                    alert.tag = 200;
                    [alert show];
                    g_page_type = @"";
                }
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
