//
//  WaveViewController.h
//  Logistika
//
//  Created by BoHuang on 8/1/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveTableViewCell.h"
#import "MyPopupDialog.h"
#import "ColoredButton.h"
#import "BasicViewController.h"

@interface WaveViewController : BasicViewController<UITableViewDelegate,UITableViewDataSource,ViewDialogDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_SegWidth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ColoredButton *btnSegment;

@property (assign, nonatomic) int pageIndex;

@end
