//
//  BaseTableViewCell.h
//  Logistika
//
//  Created by BoHuang on 6/10/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPopupDialog.h"

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,strong) id model;

@property (nonatomic,strong) UIViewController* vc;
@property (nonatomic,strong) NSDictionary* inputData;
@property (nonatomic,strong) id<ViewDialogDelegate> aDelegate;

@property (strong,nonatomic) MyPopupDialog* dialog;
-(void)setData:(NSDictionary*)data;

@end
