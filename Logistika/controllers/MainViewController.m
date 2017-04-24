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


@interface MainViewController ()
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
            UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SignupViewController*vc = [ms instantiateViewControllerWithIdentifier:@"SignupViewController"] ;
            vc.segIndex = self.segment.selectedSegmentIndex;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBar.hidden = false;
                [self.navigationController pushViewController:vc animated:true];
            });
            break;
        }
        case 202:
        {
            // guest
            // hgcneed
            EnvVar*env = [CGlobal sharedId].env;
            env.lastLogin = 1;
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
            // hgcneed
            break;
        }
        case 204:
        {
            // call
            // hgcneed
            break;
        }
        default:
            break;
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
