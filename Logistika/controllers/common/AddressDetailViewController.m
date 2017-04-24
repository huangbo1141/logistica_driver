//
//  AddressDetailViewController.m
//  Logistika
//
//  Created by BoHuang on 4/22/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "PickAddressProfileViewController.h"
#import "CGlobal.h"
#import "NSArray+BVJSONString.h"
#import "NetworkParser.h"
#import "AppDelegate.h"
#import "PersonalMainViewController.h"
#import "DateTimeViewController.h"

@interface AddressDetailViewController ()
@property (nonatomic,assign) int distance_apicalls;
@end

@implementation AddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNoti:) name:GLOBALNOTIFICATION_ADDRESSPICKUP object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.type isEqualToString:@"exceed"]) {
        self.viewQuote.hidden = false;
    }else{
        self.viewQuote.hidden = true;
    }
    
    self.navigationController.navigationBar.hidden = false;
}
-(void)recvNoti:(NSNotification*)noti{
    if(noti.object!=nil && [noti.object isKindOfClass:[NSDictionary class]]){
        NSDictionary* dict = (NSDictionary*)noti.object;
        if ([dict[@"type"] isEqualToString:@"1"]) {
            _txtPickAddress.text = dict[@"address"];
            _txtPickCity.text = dict[@"city"];
            _txtPickState.text = dict[@"state"];
            _txtPickPincode.text = dict[@"pincode"];
            _txtPickLandMark.text = dict[@"landmark"];
            _txtPickPhone.text = dict[@"phone"];
            
            self.viewChooseFromProfile.hidden = true;
            self.viewChooseFromProfile2.hidden = true;
        }else{
            _txtDesAddress.text = dict[@"address"];
            _txtDesCity.text = dict[@"city"];
            _txtDesState.text = dict[@"state"];
            _txtDesPincode.text = dict[@"pincode"];
            _txtDesLandMark.text = dict[@"landmark"];
            _txtDesPhone.text = dict[@"phone"];
            
            self.viewChooseFromProfile.hidden = true;
            self.viewChooseFromProfile2.hidden = true;
        }
    }
}
- (IBAction)clickChoose:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    PickAddressProfileViewController* vc = [ms instantiateViewControllerWithIdentifier:@"PickAddressProfileViewController"];
    vc.type = @"1";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)clickChoose2:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    PickAddressProfileViewController* vc = [ms instantiateViewControllerWithIdentifier:@"PickAddressProfileViewController"];
    vc.type = @"2";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:true];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickContinue:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    DateTimeViewController* vc = [ms instantiateViewControllerWithIdentifier:@"DateTimeViewController"];
    [self.navigationController pushViewController:vc animated:true];
    [CGlobal stopIndicator:self];
    return;
    
//    AddressModel*data = [self checkInput];
//    if (data!=nil) {
//        g_addressModel = data;
//        EnvVar* env = [CGlobal sharedId].env;
//        if (env.mode == c_CORPERATION) {
//            // hgcneed navigate to datetime activity
//        }else if([self.type isEqualToString:@"exceed"] && env.mode == c_PERSONAL){
//            if ([CGlobal isPostCode:data.sourcePinCode] && [CGlobal isPostCode:data.desPinCode]) {
//                if ([_swQuote isOn]) {
//                    [self order_quote];
//                }else{
//                    [CGlobal AlertMessage:@"Enable Switch" Title:nil];
//                }
//            }else{
//                [CGlobal AlertMessage:@"Invalid Post Code" Title:nil];
//            }
//        }else{
//            if ([CGlobal isPostCode:data.sourcePinCode] && [CGlobal isPostCode:data.desPinCode]) {
//                _distance_apicalls = 0;
//                [self getDistanceWebService];
//            }else{
//                [CGlobal AlertMessage:@"Invalid Post Code" Title:nil];
//            }
//        }
//    }
}
-(void)getDistanceWebService{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"org"] = g_addressModel.sourcePinCode;
    params[@"des"] = g_addressModel.desPinCode;
    params[@"weight"] = [NSString stringWithFormat:@"%d", [CGlobal getTotalWeight]];
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:BASE_URL Path:@"getDistance" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 200){
                    g_priceType.expeditied_price = dict[@"expedited"];
                    g_priceType.express_price = dict[@"express"];
                    g_priceType.economy_price = dict[@"economy"];
                }
                if (g_priceType.expeditied_price!=nil && [g_priceType.expeditied_price length]>0) {
                    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
                    DateTimeViewController* vc = [ms instantiateViewControllerWithIdentifier:@"DateTimeViewController"];
                    [self.navigationController pushViewController:vc animated:true];
                    [CGlobal stopIndicator:self];
                    return;
                }
            }
        }
        // error
        if (_distance_apicalls<2) {
            [self getDistanceWebService];
            return;
        }else{
            [CGlobal AlertMessage:@"Google api call failed. Retry" Title:nil];
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}
-(void)order_quote{
    EnvVar* env = [CGlobal sharedId].env;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"user_id"] = env.user_id;
    params[@"weight"] = [NSString stringWithFormat:@"%d", [CGlobal getTotalWeight]];
    params[@"distance"] = @"";
    params[@"quote_type"] = @"1";
    params[@"device_id"] = [CGlobal getDeviceID];
    params[@"device_type"] = [CGlobal getDeviceName];
    
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
    
    NSMutableArray* productsArrays = [[NSMutableArray alloc] init];
    if (g_ORDER_TYPE == g_CAMERA_OPTION) {
        for (int i=0; i<g_cameraOrderModel.itemModels.count; i++) {
            NSMutableDictionary* cameraMap = [[NSMutableDictionary alloc] init];
            ItemModel* model = g_cameraOrderModel.itemModels[i];
            cameraMap[@"image"] = model.image;
            cameraMap[@"quantity"] = model.quantity;
            cameraMap[@"weight"] = model.weight;
            cameraMap[@"weight_value"] = [NSString stringWithFormat:@"%d",model.weight_value];
            cameraMap[@"product_type"] = [NSString stringWithFormat:@"%d", g_CAMERA_OPTION];
            [productsArrays addObject:cameraMap];
        }
    }else if(g_ORDER_TYPE == g_ITEM_OPTION){
        for (int i=0; i<g_itemOrderModel.itemModels.count; i++) {
            NSMutableDictionary* cameraMap = [[NSMutableDictionary alloc] init];
            ItemModel* model = g_itemOrderModel.itemModels[i];
            cameraMap[@"title"] = model.title;
            cameraMap[@"dimension"] = [NSString stringWithFormat:@"%@X%@X%@",model.dimension1,model.dimension2,model.dimension3];
            cameraMap[@"quantity"] = model.quantity;
            cameraMap[@"weight"] = model.weight;
            cameraMap[@"product_type"] = [NSString stringWithFormat:@"%d", g_ITEM_OPTION];
            [productsArrays addObject:cameraMap];
        }
    }else if(g_ORDER_TYPE == g_PACKAGE_OPTION){
        for (int i=0; i<g_packageOrderModel.itemModels.count; i++) {
            NSMutableDictionary* cameraMap = [[NSMutableDictionary alloc] init];
            ItemModel* model = g_packageOrderModel.itemModels[i];
            cameraMap[@"title"] = model.title;
            cameraMap[@"quantity"] = model.quantity;
            cameraMap[@"weight"] = model.weight;
            cameraMap[@"product_type"] = [NSString stringWithFormat:@"%d", g_PACKAGE_OPTION];
            [productsArrays addObject:cameraMap];
        }
    }
    NSArray* temp = [NSArray arrayWithArray:productsArrays];
    params[@"product"] = [temp bv_jsonStringWithPrettyPrint:true];
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:BASE_URL Path:@"order_quote" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                //
                if([dict[@"result"] intValue] == 400){
                    [CGlobal AlertMessage:@"Thank you. A quote will be sent to your registered email address in 30 minutes" Title:nil];
                }else if ([dict[@"result"] intValue] == 200){
                    NSString* order_id = dict[@"order_id"];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Thank you. A quote will be sent to your registered email address in 30 minutes" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    alert.tag = 200;
                    [alert show];
                }
            }
        }else{
            NSLog(@"Error");
        }
        [CGlobal stopIndicator:self];
    } method:@"POST"];
    
}
-(AddressModel*)checkInput{
    NSString* mPickAddress = _txtPickAddress.text;
    NSString* mPickCity = _txtPickCity.text;
    NSString* mPickState = _txtPickState.text;
    NSString* mPickPincode = _txtPickPincode.text;
    NSString* mPickPhone = _txtPickPhone.text;
    NSString* mPickLandMark = _txtPickLandMark.text;
    NSString* mPickInstruction = _txtPickInstruction.text;
    
    NSString* mDesAddress = _txtDesAddress.text;
    NSString* mDesCity = _txtDesCity.text;
    NSString* mDesState = _txtDesState.text;
    NSString* mDesPincode = _txtDesPincode.text;
    NSString* mDesPhone = _txtDesPhone.text;
    NSString* mDesLandMark = _txtDesLandMark.text;
    NSString* mDesInstruction = _txtDesInstruction.text;
    
    NSArray* labels = @[mPickAddress,mPickCity,mPickState,mPickPincode,mPickPhone,mPickLandMark,mPickInstruction,
                        mDesAddress,mDesCity,mDesState,mDesPincode,mDesPhone,mDesLandMark,mDesInstruction];
    for (NSString*label in labels) {
        if ([label isEqualToString:@""]) {
            [CGlobal AlertMessage:@"Please enter all info" Title:nil];
            return nil;
        }
    }
    
    AddressModel* model = [[AddressModel alloc] initWithDictionary:nil];
    model.sourceAddress = mPickAddress;
    model.sourceCity = mPickCity;
    model.sourceState = mPickState;
    model.sourcePinCode = mPickPincode;
    model.sourcePhonoe = mPickPhone;
    model.sourceLandMark = mPickLandMark;
    model.sourceInstruction = mPickInstruction;
    model.desAddress = mDesAddress;
    model.desCity = mDesCity;
    model.desState = mDesState;
    model.desPinCode = mDesPincode;
    model.desLandMark = mDesLandMark;
    model.desInstruction = mDesInstruction;
    
    return model;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
@end
