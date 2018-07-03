//
//  MainViewController.m
//  Logistika
//
//  Created by BoHuang on 4/18/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "MainViewController.h"
#import "LeftView.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "CGlobal.h"
#import "UIView+Property.h"
#import "PersonalMainViewController.h"
#import "AppDelegate.h"
#import "MyNavViewController.h"
#import "NetworkParser.h"
#import "OrderResponse.h"
#import "MyPopupDialog.h"
#import "ViewAuthen.h"

@interface MainViewController ()
@property (nonatomic,strong) MyPopupDialog* dialog;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView.backgroundColor = COLOR_SECONDARY_THIRD;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [_segment addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];
    
    [_btnSignIn addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnSignUp addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnGuest addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnTracking addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnCall addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnSignIn.tag = 200;
    _btnSignUp.tag = 201;
    _btnGuest.tag = 202;
    _btnTracking.tag = 203;
    _btnCall.tag = 204;
    
    self.segment.tintColor = COLOR_PRIMARY;
    
//    EnvVar* env = [CGlobal sharedId].env;
//    if ([env.username length]>0 || [env.cor_email length]>0) {
//        NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
//        [userd setBool:true forKey:@"service_status_preference"];
//        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        [delegate startOrStopTraccar];
//    }
}
-(void)clickView:(UIView*)sender{
    int tag = (int)sender.tag;
    switch (tag) {
        case 200:
        {
            // sign in
            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController*vc = [ms instantiateViewControllerWithIdentifier:@"LoginViewController"] ;
            vc.segIndex = self.segment.selectedSegmentIndex;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBar.hidden = false;
                [self.navigationController pushViewController:vc animated:true];
            });
            break;
        }
        case 201:
        {
            // sign up
            self.dialog = [[MyPopupDialog alloc] init];
            UIViewController*vc = self;
            NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"ViewAuthen" owner:vc options:nil];
            ViewAuthen* view = array[0];
            [view firstProcess:@{@"aDelegate":self}];
            
            self.dialog = [[MyPopupDialog alloc] init];
            [self.dialog setup:view backgroundDismiss:true backgroundColor:[UIColor grayColor]];
            [self.dialog showPopup:vc.view];
            
//            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            SignupViewController*vc = [ms instantiateViewControllerWithIdentifier:@"SignupViewController"] ;
//            vc.segIndex = self.segment.selectedSegmentIndex;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.navigationController.navigationBar.hidden = false;
//                [self.navigationController pushViewController:vc animated:true];
//            });
//
            
            
            break;
        }
        case 202:
        {
            // guest
            EnvVar*env = [CGlobal sharedId].env;
            env.lastLogin = 0;
            g_mode = c_GUEST;
            env.mode = c_GUEST;
            
            // LoginProcess
            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
            PersonalMainViewController*vc = [ms instantiateViewControllerWithIdentifier:@"PersonalMainViewController"] ;
            MyNavViewController* nav = [[MyNavViewController alloc] initWithRootViewController:vc];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                delegate.window.rootViewController = nav;
            });
            break;
        }
        case 203:
        {
            // tracking
            
            [CGlobal AlertMessage:@"Please Sign In" Title:nil];
            break;
        }
        case 204:
        {
            // call
            NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
            
            data[@"employer_id"] = @"0";
            [CGlobal showIndicator:self];
            
            NetworkParser* manager = [NetworkParser sharedManager];
            [manager ontemplateGeneralRequest2:data BasePath:BASE_DATA_URL Path:@"get_Contact_Details" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
                @try {
                    NSArray* array = dict;
                    NSString*num = [NSString stringWithFormat:@"tel:%@",array[0][@"PhoneNumber"]];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
                } @catch (NSException *exception) {
                    NSLog(@"catch");
                }
                [CGlobal stopIndicator:self];
            } method:@"POST"];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:support_phone]];
            break;
        }
        default:
            break;
    }
}
-(void)tracking:(NSString*)number{

    
}
-(void)onChange:(UISegmentedControl*)seg{
    NSInteger index = seg.selectedSegmentIndex;
    if (index == 0) {
        _btnGuest.hidden = false;
        
    }else{
        _btnGuest.hidden = true;
    }
}
-(void)onLeftItemTouched:(UIBarButtonItem*)sender{
    if (self.view.drawerLayout!=nil) {
        self.view.drawerLayout.openFromRight = NO;
        [self.view.drawerLayout openDrawer];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didSubmit:(NSDictionary *)data View:(UIView *)view{
    if([view isKindOfClass:[ViewAuthen class]]){
        if (data[@"data"]!=nil) {
            // authencation
            NSString* auth = data[@"data"];
            NSMutableDictionary* req = [[NSMutableDictionary alloc] init];
            req[@"authentication"] = auth;
            
            NetworkParser* manager = [NetworkParser sharedManager];
            [CGlobal showIndicator:self];
            [manager ontemplateGeneralRequest2:req BasePath:g_URL Path:@"get_authentication" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
                if (error == nil) {
                    if (dict!=nil && [dict[@"result"] isKindOfClass:[NSString class]]) {
                        NSString* a = [dict[@"result"] lowercaseString];
                        NSString* b = [auth lowercaseString];
                        if ([a isEqualToString:b]) {
                            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            SignupViewController*vc = [ms instantiateViewControllerWithIdentifier:@"SignupViewController"] ;
                            vc.segIndex = self.segment.selectedSegmentIndex;
                            vc.authentication = auth;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.navigationController.navigationBar.hidden = false;
                                [self.navigationController pushViewController:vc animated:true];
                            });
                            [CGlobal stopIndicator:self];
                            return;
                        }
                    }
                }else{
                    NSLog(@"Error");
                }
                
//                [CGlobal AlertMessage:@"Tracking number not found in our records" Title:nil];
                [CGlobal stopIndicator:self];
                
            } method:@"post"];
        }
    }
    if (view.xo!=nil && [view.xo isKindOfClass:[MyPopupDialog class]]) {
        MyPopupDialog* dialog = (MyPopupDialog*)view.xo;
        [dialog dismissPopup];
    }
    
}
-(void)didCancel:(NSDictionary *)data View:(UIView *)view{
    if (view.xo!=nil && [view.xo isKindOfClass:[MyPopupDialog class]]) {
        MyPopupDialog* dialog = (MyPopupDialog*)view.xo;
        [dialog dismissPopup];
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
