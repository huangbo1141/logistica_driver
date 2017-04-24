//
//  SignupViewController.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "SignupViewController.h"
#import "CGlobal.h"
#import "NSArray+BVJSONString.h"
#import "NSDictionary+BVJSONString.h"
#import "NetworkParser.h"
#import "TblAddress.h"
#import "TblUser.h"
#import "PersonalMainViewController.h"
#import "MyNavViewController.h"
#import "AppDelegate.h"

@interface SignupViewController ()<UIComboBoxDelegate>
@property(nonatomic,assign) BOOL isChange;
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_btnCreate addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    _btnCreate.tag = 200;
    //
    self.cbAnswer.delegate = self;
    self.cbAnswer.entries = g_securityList;
    if(self.inputData == nil){
        // sign up
        [_btnCreate setTitle:@"Create" forState:UIControlStateNormal];
        _btnCreate.tag = 200;
    }else{
        // edit profile
        [_btnCreate setTitle:@"Save Changes" forState:UIControlStateNormal];
        _btnCreate.tag = 201;
        _swTermView.hidden = true;
        _swPolicy.hidden = true;
        [self initData:self.inputData];
        _isChange = false;
    }
    
    
    
}
-(void)initData:(NSMutableDictionary*)data{
    if (data!=nil) {
        EnvVar*env = [CGlobal sharedId].env;
        NSUInteger found = [g_securityList indexOfObject:env.question];
        if (found!=NSNotFound) {
            self.cbAnswer.selectedItem = found;
        }
        self.txtAnswer.text = env.answer;
        self.txtFirstName.text = env.first_name;
        self.txtLastName.text = env.last_name;
        self.txtPhoneNumber.text = env.phone;
        self.txtAddress.text = env.address1;
        self.txtCity.text = env.city;
        self.txtState.text = env.state;
        self.txtPin.text = env.pincode;
        self.txtLandMark.text = env.landmark;
        if (env.mode == c_CORPERATION) {
            self.txtEmail.text = env.cor_email;
            self.txtPassword.text = env.cor_password;
            self.txtRePassword.text = env.cor_password;
        }else{
            self.txtEmail.text = env.email;
            self.txtPassword.text = env.password;
            self.txtRePassword.text = env.password;
        }
        
        NSArray* controls = @[self.txtFirstName,self.txtLastName,self.txtPhoneNumber,self.txtAddress,self.txtCity,self.txtState,self.txtPin,self.txtLandMark,self.txtEmail,self.txtPassword,self.txtRePassword,self.txtAnswer];
        for (UITextField*text in controls) {
            [text addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventValueChanged];
        }
        
    }
}
-(void)textChange:(UITextField*)field{
    self.isChange = true;
}
-(NSMutableDictionary*)checkInput{
    NSString* mFirst = _txtFirstName.text;
    NSString* mLast = _txtLastName.text;
    NSString* mPhone = _txtPhoneNumber.text;
    NSString* mAddress1 = _txtAddress.text;
//    NSString* mAddress2 = _txtad.text;
    NSString* mCity = _txtCity.text;
    NSString* mState = _txtState.text;
    NSString* mPinCode = _txtPin.text;
    NSString* mLandMark = _txtLandMark.text;
    NSString* mEmail = _txtEmail.text;
    NSString* mPassword = _txtPassword.text;
    NSString* mConfirmPassword = _txtRePassword.text;
    NSString* mAnswer = _txtAnswer.text;
    
    NSArray* labels = @[mFirst,mLast,mPhone,mAddress1,mCity,mState,mPinCode,mLandMark,mEmail,mPassword,mConfirmPassword,mAnswer];
    for (NSString*label in labels) {
        if ([label isEqualToString:@""]) {
            [CGlobal AlertMessage:@"Please enter all info" Title:nil];
            return nil;
        }
    }
    
    // check special
    if (![CGlobal validatePassword:mPassword]) {
        [CGlobal AlertMessage:@"Password must be minium 8 characters with a combo of alphanumeric characters" Title:nil];
        return nil;
    }
    if (![mPassword isEqualToString:mConfirmPassword]) {
        [CGlobal AlertMessage:@"Not Match Password" Title:nil];
        return nil;
    }
    if (![CGlobal isPostCode:mPinCode]) {
        [CGlobal AlertMessage:@"Invalid Post Code" Title:nil];
        return nil;
    }
    if (![self.swTerm isOn]) {
        _swTermView.borderWidth = 1;
        return nil;
    }else{
        _swTermView.borderWidth = 0;
    }
    if (![self.swPolicy isOn]) {
        _swPolicyView.borderWidth = 1;
        return nil;
    }else{
        _swPolicyView.borderWidth = 0;
    }
    if (![CGlobal isValidEmail:mEmail]) {
        [CGlobal AlertMessage:@"Invalid Email" Title:nil];
        return nil;
    }
    NSString*dp = [CGlobal encrypt:mPassword];
    NSString*usertype = @"0";
    if (self.segIndex == 0) {
        usertype = [NSString stringWithFormat:@"%d",c_PERSONAL];
    }else{
        usertype = [NSString stringWithFormat:@"%d",c_CORPERATION];
    }
    NSString*question = g_securityList[self.cbAnswer.selectedItem];
    
    NSDictionary* tdata = @{@"firstName":mFirst
                           ,@"lastName":mLast
                           ,@"email":mEmail
                           ,@"password":dp
                           ,@"phone":mPhone
                            ,@"question":question
                           ,@"answer":mAnswer
                           ,@"term":@"1"
                           ,@"policy":@"1"
                           ,@"user_type":usertype};
    NSMutableDictionary * data = [[NSMutableDictionary alloc] initWithDictionary:tdata];
    if (self.inputData == nil) {
        NSDictionary*jsonMap = @{@"address1":mAddress1
                                 ,@"address2":@""
                                 ,@"city":mCity
                                 ,@"state":mState
                                 ,@"pincode":mPinCode
                                 ,@"landmark":mLandMark};
        NSArray*addressArray = @[jsonMap];
        data[@"address"] = [addressArray bv_jsonStringWithPrettyPrint:true];
    }else{
        EnvVar* env = [CGlobal sharedId].env;
        NSDictionary*jsonMap = @{@"address1":mAddress1
                                 ,@"address2":@""
                                 ,@"city":mCity
                                 ,@"state":mState
                                 ,@"pincode":mPinCode
                                 ,@"landmark":mLandMark
                                 ,@"id":env.address_id};
        NSArray*addressArray = @[jsonMap];
        data[@"address"] = [addressArray bv_jsonStringWithPrettyPrint:true];
    }
    
    
    
    
    return data;
}
-(void)clickView:(UIView*)sender{
    int tag = (int)sender.tag;
    switch (tag) {
        case 200:
        {
            NSMutableDictionary* data = [self checkInput];
            if (data != nil) {
                NetworkParser* manager = [NetworkParser sharedManager];
                [CGlobal showIndicator:self];
                [manager ontemplateGeneralRequest2:data BasePath:BASE_URL Path:@"register" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
                    if (error == nil) {
                        // succ
                        if ([dict[@"result"] isEqualToString:@"400"]) {
                            //
                            [CGlobal AlertMessage:@"Username already exists" Title:nil];
                            [CGlobal stopIndicator:self];
                            return;
                        }
                        
                        TblUser* user = [[TblUser alloc] initWithDictionary:dict];
                        [user saveResponse:_segIndex Password:_txtPassword.text];
                        
                        if (_segIndex == 0) {
                            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
                            PersonalMainViewController*vc = [ms instantiateViewControllerWithIdentifier:@"PersonalMainViewController"] ;
                            MyNavViewController* nav = [[MyNavViewController alloc] initWithRootViewController:vc];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                delegate.window.rootViewController = nav;
                            });
                        }else{
                            // hgcneed
                        }
                        
                    }else{
                        // error
                        [CGlobal AlertMessage:@"Register Fail" Title:nil];
                    }
                    
                    [CGlobal stopIndicator:self];
                } method:@"POST"];
            }
            break;
        }
        case 201:{
            NSMutableDictionary* data = [self checkInput];
            if (data != nil && _isChange) {
                EnvVar* env = [CGlobal sharedId].env;
                if (env.mode == c_PERSONAL) {
                    data[@"id"] = env.user_id;
                }else{
                    data[@"id"] = env.corporate_user_id;
                }
                
                
                NetworkParser* manager = [NetworkParser sharedManager];
                [CGlobal showIndicator:self];
                [manager ontemplateGeneralRequest2:data BasePath:BASE_URL Path:@"update" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
                    if (error == nil) {
                        // succ
                        if ([dict[@"result"] isEqualToString:@"400"]) {
                            //
                            [CGlobal AlertMessage:@"Fail" Title:nil];
                            [CGlobal stopIndicator:self];
                            return;
                        }
                        
                        TblUser* user = [[TblUser alloc] initWithDictionary:dict];
                        [user saveResponse:_segIndex Password:_txtPassword.text];
                        
                        [CGlobal AlertMessage:@"Changes updated successfully" Title:nil];
                    }else{
                        // error
                        [CGlobal AlertMessage:@"Fail" Title:nil];
                    }
                    
                    [CGlobal stopIndicator:self];
                } method:@"POST"];
            }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
