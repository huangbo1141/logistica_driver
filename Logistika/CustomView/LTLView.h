//
//  LTLView.h
//  Logistika
//
//  Created by BoHuang on 6/8/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColoredView.h"
#import "FontLabel.h"
#import "MyPopupDialog.h"
#import "TblTruck.h"

@interface LTLView : UIView

@property (weak, nonatomic) IBOutlet ColoredView *viewRoot;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (weak, nonatomic) IBOutlet FontLabel *lblContent;

-(void)firstProcess:(NSDictionary*)data;

@property (nonatomic,strong) id<ViewDialogDelegate> aDelegate;
@property (nonatomic,strong) TblTruck* truck;
@end
