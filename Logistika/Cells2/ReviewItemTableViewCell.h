//
//  ReviewItemTableViewCell.h
//  Logistika
//
//  Created by BoHuang on 4/26/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionDelegate.h"
#import "ItemModel.h"

@interface ReviewItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblItem;
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblWeight;

@property (strong,nonatomic) id<ActionDelegate> aDelegate;
@property (strong,nonatomic) ItemModel*data;
-(void)initMe:(ItemModel*)model;
@end
