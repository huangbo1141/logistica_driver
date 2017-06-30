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
#import "MyTextDelegate.h"
#import "TblArea.h"
#import "TermViewController.h"

@interface SignupViewController ()<UIComboBoxDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CAAutoFillDelegate>
@property(nonatomic,assign) BOOL isChange;
@property(nonatomic,assign) NSInteger selrow;
@property(nonatomic,strong) MyTextDelegate* textDelegate;
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_btnCreate addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    _btnCreate.tag = 200;
    //
    [_btnCreate setTitle:@"Create" forState:UIControlStateNormal];
    _btnCreate.tag = 200;
    
    [_btnTerms addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    _btnTerms.tag = 300;
    
    self.selrow = 0;
    self.lblPicker1.text = g_securityList[0];
    
    MyTextDelegate* textDelegate = [[MyTextDelegate alloc] init];
    textDelegate.mode = 1;
    textDelegate.length = 10;
    self.txtPhoneNumber.delegate = textDelegate;
    self.textDelegate = textDelegate;
    
    
    [self setAreaDatas];
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [manager ontemplateGeneralRequest2:data BasePath:BASE_DATA_URL Path:@"get_basic" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                if ([dict[@"result"] intValue] == 200) {
                    LoginResponse* data = [[LoginResponse alloc] initWithDictionary:dict];
                    if (data.area.count > 0) {
                        g_areaData = data;
                        [self setAreaDatas];
                    }
                    
                }else{
                    [CGlobal AlertMessage:@"Fail" Title:nil];
                }
            }
        }else{
            NSLog(@"Error");
        }
        
    } method:@"POST"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Create Profile";
}
-(void)setAreaDatas{
    
    if(true) { // if (g_areaData.area.count > 0) {
        
        self.txtArea.txtField.text = @"area";
        self.txtArea.hidden = true;
        
//        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//        for (int i = 0; i<g_areaData.area.count; i++) {
//            TblArea* item = g_areaData.area[i];
//            CAAutoCompleteObject *object = [[CAAutoCompleteObject alloc] initWithObjectName:item.title AndID:i];
//            [tempArray addObject:object];
//        }
//        [self.txtArea setDataSourceArray:tempArray];
//        [self.txtArea setDelegate:self];
//        
//        self.txtArea.viewParent = [self.txtArea superview];
//        self.txtArea.txtField.placeholder = @"Area,Locality";
//        self.txtArea.scrollParent = self.scrollParent;
    }
    
    if(true) { // if (g_areaData.city.count > 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<g_areaData.city.count; i++) {
            TblArea* item = g_areaData.city[i];
            CAAutoCompleteObject *object = [[CAAutoCompleteObject alloc] initWithObjectName:item.title AndID:i];
            [tempArray addObject:object];
        }
        [self.txtCity setDataSourceArray:tempArray];
        [self.txtCity setDelegate:self];
        
        self.txtCity.viewParent = [self.txtCity superview];
        self.txtCity.txtField.placeholder = @"City";
        self.txtCity.scrollParent = self.scrollParent;
    }
    
    if(true) { // if (g_areaData.pincode.count > 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<g_areaData.pincode.count; i++) {
            TblArea* item = g_areaData.pincode[i];
            CAAutoCompleteObject *object = [[CAAutoCompleteObject alloc] initWithObjectName:item.title AndID:i];
            [tempArray addObject:object];
        }
        [self.txtPin setDataSourceArray:tempArray];
        [self.txtPin setDelegate:self];
        
        self.txtPin.viewParent = [self.txtPin superview];
        self.txtPin.txtField.placeholder = @"Pincode";
        self.txtPin.scrollParent = self.scrollParent;
    }
    
    NSArray* fields = @[self.txtFirstName,self.txtLastName,self.txtPhoneNumber,self.txtAddress,self.txtState,self.txtLandMark,self.txtEmail,self.txtPassword,self.txtRePassword,self.txtAnswer,self.txtArea,self.txtCity,self.txtPin];
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectMake(0, 0, screenRect.size.width-40, 30);
    for (int i=0; i<fields.count; i++) {
        if ([fields[i] isKindOfClass:[BorderTextField class]]) {
            BorderTextField*field = fields[i];
            [field addBotomLayer:frame];
        }else if([fields[i] isKindOfClass:[CAAutoFillTextField class]]){
            CAAutoFillTextField* ca = fields[i];
            [ca.txtField addBotomLayer:frame];
            ca.txtField.delegate = ca;
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
    NSString* mCity = _txtCity.txtField.text;
    NSString* mState = _txtState.text;
    NSString* mPinCode = _txtPin.txtField.text;
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
        [CGlobal AlertMessage:@"Password doesn't match" Title:nil];
        return nil;
    }
    if (![CGlobal isPostCode:mPinCode]) {
        [CGlobal AlertMessage:@"Invalid Post Code" Title:nil];
        return nil;
    }
    
//    if ([self.txtPhoneNumber.text length] != 10) {
//        [CGlobal AlertMessage:@"Phone Number should be 10 characters" Title:nil];
//        return nil;
//    }
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
    NSString*question = g_securityList[self.selrow];
    
    NSDictionary* tdata = @{@"firstName":mFirst
                           ,@"lastName":mLast
                           ,@"email":mEmail
                           ,@"password":dp
                           ,@"phone":mPhone
                            ,@"question":question
                           ,@"answer":mAnswer
                           ,@"term":@"1"
                           ,@"policy":@"1"
                           ,@"user_type":usertype
                           ,@"authentication":self.authentication};
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
    
    data[@"device_type"] = [CGlobal getDeviceName];
    data[@"device_id"] = [CGlobal getDeviceID];
    
    return data;
}
-(void)clickView:(UIView*)sender{
    int tag = (int)sender.tag;
    switch (tag) {
        case 300:{
            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
            TermViewController* vc =  [ms instantiateViewControllerWithIdentifier:@"TermViewController"];
            [self.navigationController pushViewController:vc animated:true];
            break;
        }
        case 200:
        {
            NSMutableDictionary* data = [self checkInput];
            if (data != nil) {
                NetworkParser* manager = [NetworkParser sharedManager];
                [CGlobal showIndicator:self];
                [manager ontemplateGeneralRequest2:data BasePath:g_URL Path:@"register" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
                    if (error == nil) {
                        // succ
                        if ([dict[@"result"] isEqualToString:@"400"]) {
                            //
                            [CGlobal AlertMessage:@"Username already exists" Title:nil];
                            [CGlobal stopIndicator:self];
                            return;
                        }
                        
                        [CGlobal AlertMessage:@"Profile successfully created" Title:nil];
                        
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
                            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Cor" bundle:nil];
                            PersonalMainViewController*vc = [ms instantiateViewControllerWithIdentifier:@"CorMainViewController"] ;
                            MyNavViewController* nav = [[MyNavViewController alloc] initWithRootViewController:vc];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                delegate.window.rootViewController = nav;
                            });
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
        
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)donePicker:(UIView*)view{
    UIPickerView* pickerview = [self.viewPickerContainer1 viewWithTag:200];
    if (pickerview!= nil) {
        self.selrow  =[pickerview selectedRowInComponent:0];
        NSString*answer = g_securityList[self.selrow];
        self.lblPicker1.text = answer;
        [self.viewPickerContainer1 removeFromSuperview];
        self.isChange = true;
    }
}
-(void)tapPickerContainer:(UITapGestureRecognizer*)gesture{
    if (gesture.view!=nil) {
        int tag = (int)gesture.view.tag;
        switch (tag) {
            case 999:
            {
                [self showPicker1:nil];
                break;
            }
            default:
                break;
        }
    }
}
- (IBAction)showPicker1:(id)sender {
    UIView* superview = [self.viewPickerContainer1 superview];
    if (superview == nil) {
        CGRect main = [UIScreen mainScreen].bounds;
        CGRect rt = self.view.frame;
        CGFloat topPadding = [UIApplication sharedApplication].statusBarFrame.size.height;
        if (self.navigationController.navigationBar!=nil && self.navigationController.navigationBar.hidden == false) {
            topPadding = self.navigationController.navigationBar.frame.size.height + topPadding;
        }
        if ([self isKindOfClass:[MenuViewController class]]) {
            MenuViewController* vc = self;
            topPadding =  vc.topBarView.constraint_Height.constant + topPadding;
        }
        rt = CGRectMake(0, topPadding, rt.size.width, rt.size.height - topPadding);
        CGFloat height = 266;
        CGFloat h_toolbar = 44;
        CGFloat h_picker = height - h_toolbar;
        CGFloat top = rt.size.height - height;
        
        self.viewPickerContainer1 = [[UIView alloc]initWithFrame:CGRectMake(0, topPadding, rt.size.width, rt.size.height)];
        
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, top, rt.size.width, h_toolbar)];
        
        
        UIBarButtonItem *temp2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePicker:)];
        
        toolBar.barStyle = UIBarStyleDefault;
        toolBar.translucent = true;
        toolBar.tintColor = [UIColor darkGrayColor];
        [toolBar setItems:@[temp2,btn]];
        [self.viewPickerContainer1 addSubview:toolBar];
        
        
        UIPickerView* valuePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, top+h_toolbar, rt.size.width, h_picker)];
        valuePicker.delegate=self;
        valuePicker.dataSource=self;
        valuePicker.showsSelectionIndicator=YES;
        valuePicker.tag = 200;
        valuePicker.backgroundColor = [UIColor whiteColor];
        
        [self.viewPickerContainer1 addSubview:valuePicker];
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPickerContainer:)];
        [self.viewPickerContainer1 addGestureRecognizer:gesture];
        self.viewPickerContainer1.tag = 999;
        
        [self.view addSubview:self.viewPickerContainer1];
    }else{
        [self.viewPickerContainer1 removeFromSuperview];
    }
    
    
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return g_securityList.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return g_securityList[row];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) CAAutoTextFillBeginEditing:(CAAutoFillTextField *) textField {
    
}

- (void) CAAutoTextFillEndEditing:(CAAutoFillTextField *) textField {
    
}

- (BOOL) CAAutoTextFillWantsToEdit:(CAAutoFillTextField *) textField {
    return YES;
}
@end
