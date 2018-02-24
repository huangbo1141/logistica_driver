//
//  MenuViewController.m
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "MenuViewController.h"
#import "CGlobal.h"
#import "ProfileViewController.h"
#import "AboutUsViewController.h"
#import "ContactUsViewController.h"
#import "CorMainViewController.h"
#import "FeedBackViewController.h"
#import "MainViewController.h"
#import "PersonalMainViewController.h"
#import "PolicyViewController.h"
#import "ProfileViewController.h"
#import "SignupViewController.h"
#import "LeftView.h"
#import "UIView+Property.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CGlobal initMenu:self];
    [self.topBarView customLayout:self];
    
    LeftView* leftView = self.view.drawerView;
    if ([self isKindOfClass:[ProfileViewController class]]) {
        [leftView setCurrentMenu:c_menu_title[0]];
    }else if ([self isKindOfClass:[AboutUsViewController class]]) {
        [leftView setCurrentMenu:c_menu_title[1]];
    }else if ([self isKindOfClass:[ContactUsViewController class]]) {
        [leftView setCurrentMenu:c_menu_title[2]];
    }else if ([self isKindOfClass:[FeedBackViewController class]]) {
        [leftView setCurrentMenu:c_menu_title[3]];
    }else if ([self isKindOfClass:[PolicyViewController class]]) {
        [leftView setCurrentMenu:c_menu_title[4]];
    }else {
        [leftView setCurrentMenu:nil];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.topBarView updateCaption];
    self.navigationController.navigationBar.hidden = true;
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
