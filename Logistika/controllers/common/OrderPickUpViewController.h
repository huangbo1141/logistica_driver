//
//  OrderPickUpViewController.h
//  Logistika
//
//  Created by BoHuang on 4/27/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BasicViewController.h"

@interface OrderPickUpViewController : BasicViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UIView *viewRoot;
@property (weak, nonatomic) IBOutlet UIView *viewRoot1;
@property (weak, nonatomic) IBOutlet UIView *viewRoot2;
@property (weak, nonatomic) IBOutlet UIView *viewRoot3;

@property (weak, nonatomic) IBOutlet UITableView *tableview1;
@property (weak, nonatomic) IBOutlet UITableView *tableview2;
@property (weak, nonatomic) IBOutlet UITableView *tableview3;

@property (assign, nonatomic) int type;
@property (copy, nonatomic) NSString* mode;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_ViewTop;


@property (assign,nonatomic) int hideMode;
@end
