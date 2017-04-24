//
//  LeftView.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "LeftView.h"
#import "AboutUsViewController.h"
#import "ContactUsViewController.h"
#import "PolicyViewController.h"
#import "CGlobal.h"
#import "UIView+Property.h"
#import "AppDelegate.h"
#import "SignupViewController.h"
#import "ProfileViewController.h"

@implementation LeftView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)clickView:(UIView*)sender{
    int tag = (int)sender.tag;
    EnvVar* env = [CGlobal sharedId].env;
    switch (tag) {
        case 200:
        {
            //btnProfile
            if (env.lastLogin>0) {
                // profile
                if(_vc.navigationController!= nil){
                    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
                    ProfileViewController*vc = [ms instantiateViewControllerWithIdentifier:@"ProfileViewController"] ;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _vc.navigationController.navigationBar.hidden = true;
                        _vc.navigationController.viewControllers = @[vc];
                    });
                }
            }else{
                [CGlobal AlertMessage:@"Please Sign in" Title:nil];
            }
            break;
        }
        case 201:
        {
            //btnQuotes
            if (env.lastLogin>0) {
                
            }else{
                [CGlobal AlertMessage:@"Please Sign in" Title:nil];
            }
            break;
        }
        case 202:
        {
            //btnOrderHistory
            if (env.lastLogin>0) {
                
            }else{
                [CGlobal AlertMessage:@"Please Sign in" Title:nil];
            }
            break;
        }
        case 203:
        {
            //btnReschedule
            if (env.lastLogin>0) {
                
            }else{
                [CGlobal AlertMessage:@"Please Sign in" Title:nil];
            }
            break;
        }
        case 204:
        {
            //btnCancel
            if (env.lastLogin>0) {
                
            }else{
                [CGlobal AlertMessage:@"Please Sign in" Title:nil];
            }
            break;
        }
        case 205:
        {
            //btnAbout
            if (env.lastLogin>0) {
                if(_vc.navigationController!= nil){
                    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
                    AboutUsViewController*vc = [ms instantiateViewControllerWithIdentifier:@"AboutUsViewController"] ;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _vc.navigationController.navigationBar.hidden = true;
                        _vc.navigationController.viewControllers = @[vc];
                    });
                }
            }else{
                [CGlobal AlertMessage:@"Please Sign in" Title:nil];
            }
            
            
            break;
        }
        case 206:
        {
            //btnContact
            if (env.lastLogin>0) {
                if(_vc.navigationController!= nil){
                    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
                    ContactUsViewController*vc = [ms instantiateViewControllerWithIdentifier:@"ContactUsViewController"] ;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _vc.navigationController.navigationBar.hidden = true;
                        _vc.navigationController.viewControllers = @[vc];
                    });
                }
            }else{
                [CGlobal AlertMessage:@"Please Sign in" Title:nil];
            }
            break;
        }
        case 207:
        {
            //btnFeedback
            if (env.lastLogin>0) {
                
            }else{
                [CGlobal AlertMessage:@"Please Sign in" Title:nil];
            }
            break;
        }
        case 208:
        {
            //btnPrivacy
            if (env.lastLogin>0) {
                if(_vc.navigationController!= nil){
                    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
                    PolicyViewController*vc = [ms instantiateViewControllerWithIdentifier:@"PolicyViewController"] ;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _vc.navigationController.navigationBar.hidden = true;
                        _vc.navigationController.viewControllers = @[vc];
                    });
                }
            }else{
                [CGlobal AlertMessage:@"Please Sign in" Title:nil];
            }
            break;
        }
        case 209:
        {
            //btnSignIn
            if (env.lastLogin>0) {
                
            }else{
                [CGlobal AlertMessage:@"Please Sign in" Title:nil];
            }
            break;
        }
        case 210:{
            // sign out
            [env logOut];
            [CGlobal clearData];
            AppDelegate* delegate = [UIApplication sharedApplication].delegate;
            [delegate defaultLogin];
            break;
        }
        default:
            break;
    }
    // close drawer
    if (_vc.view.drawerLayout!=nil) {
        ECDrawerLayout *drawerLayout = _vc.view.drawerLayout;
        drawerLayout.openFromRight = NO;
        [drawerLayout closeDrawer];
    }
}
-(void)initMenu{
    [self.btnProfile addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnQuotes addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnOrderHistory addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnReschedule addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCancel addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAbout addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnContact addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnFeedback addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPrivacy addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSignIn addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnProfile.tag = 200;
    self.btnQuotes.tag = 201;
    self.btnOrderHistory.tag = 202;
    self.btnReschedule.tag = 203;
    self.btnCancel.tag = 204;
    self.btnAbout.tag = 205;
    self.btnContact.tag = 206;
    self.btnFeedback.tag = 207;
    self.btnPrivacy.tag = 208;
    self.btnSignIn.tag = 209;
    
    EnvVar* env = [CGlobal sharedId].env;
    if (env.lastLogin > 0) {
        self.lblSignIn.text = @"Sign Out";
        self.btnSignIn.tag = 210;
    }else{
        self.btnSignIn.tag = 209;
        self.lblSignIn.text = @"Sign In";
    }
}
-(void)initMe:(UIViewController*)vc{
    _vc = vc;
    [self initMenu];
}
@end
