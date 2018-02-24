//
//  InfoView3.h
//  Logistika
//
//  Created by BoHuang on 6/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "MyBaseView.h"
#import "OrderModel.h"

@interface InfoView3 : MyBaseView<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *viewHeader_CAMERA;
@property (weak, nonatomic) IBOutlet UIView *viewHeader_ITEM;
@property (weak, nonatomic) IBOutlet UIView *viewHeader_PACKAGE;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_TH;

@property (weak, nonatomic) IBOutlet UIView *viewItems;

@property (weak, nonatomic) IBOutlet UIView *viewDetail;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel* lblDeliver;
@property (weak, nonatomic) IBOutlet UILabel* lblLoadType;

@property (nonatomic,strong) OrderModel *orderModel;
@property (nonatomic,strong) NSMutableArray* itemModels;

-(CGFloat)getHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblSourceAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblSourceArea;
@property (weak, nonatomic) IBOutlet UILabel *lblSourceCity;
@property (weak, nonatomic) IBOutlet UILabel *lblSourceState;
@property (weak, nonatomic) IBOutlet UILabel *lblDesAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDesArea;
@property (weak, nonatomic) IBOutlet UILabel *lblDesCity;
@property (weak, nonatomic) IBOutlet UILabel *lblDesState;
@end

