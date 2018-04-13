//
//  ReviewPackageTableViewCell.h
//  Logistika
//
//  Created by BoHuang on 4/26/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionDelegate.h"
#import "ItemModel.h"

@interface ReviewPackageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblItem;
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblWeight;

@property (weak, nonatomic) IBOutlet UIStackView *stackRoot;

@property (strong,nonatomic) id<ActionDelegate> aDelegate;
@property (strong,nonatomic) ItemModel*data;
-(void)initMe:(ItemModel*)model;
-(void)setFontSizeForReviewOrder:(CGFloat)fontsize;
-(CGFloat)getHeight:(CGFloat)padding Width:(CGFloat)width;
@end
