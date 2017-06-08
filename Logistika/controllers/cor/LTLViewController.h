//
//  LTLViewController.h
//  Logistika
//
//  Created by BoHuang on 5/6/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BasicViewController.h"
#import "MyPopupDialog.h"
@interface LTLViewController : BasicViewController<ViewDialogDelegate>

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (nonatomic,assign) int type;
@end
