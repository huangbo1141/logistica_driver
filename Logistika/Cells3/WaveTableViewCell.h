//
//  WaveTableViewCell.h
//  Logistika
//
//  Created by BoHuang on 8/1/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface WaveTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOrderID;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblService;
@property (weak, nonatomic) IBOutlet UILabel *lblPriority;

-(void)setData:(NSDictionary *)data;

@end
