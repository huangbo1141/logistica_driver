//
//  ReviewCameraTableViewCell.h
//  Logistika
//
//  Created by BoHuang on 4/26/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"
#import "ActionDelegate.h"
#import "MyPopupDialog.h"

@interface ReviewCameraTableViewCell : UITableViewCell<ViewDialogDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgContent;
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblWeight;

@property (strong,nonatomic) MyPopupDialog* dialog;

@property (strong,nonatomic) id<ActionDelegate> aDelegate;
@property (strong,nonatomic) ItemModel*data;
-(void)initMe:(ItemModel*)model;

@end
