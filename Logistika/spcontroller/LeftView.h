//
//  LeftView.h
//  Logistika
//
//  Created by BoHuang on 4/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ECDrawerLayout.h>

#import "FontLabel.h"

@interface LeftView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnQuotes;
@property (weak, nonatomic) IBOutlet UIButton *btnOrderHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnReschedule;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnAbout;
@property (weak, nonatomic) IBOutlet UIButton *btnContact;
@property (weak, nonatomic) IBOutlet UIButton *btnFeedback;
@property (weak, nonatomic) IBOutlet UIButton *btnPrivacy;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;

@property (strong, nonatomic) UIViewController*vc;
@property (weak, nonatomic) IBOutlet FontLabel *lblSignIn;

-(void)initMe:(UIViewController*)vc;
@end
