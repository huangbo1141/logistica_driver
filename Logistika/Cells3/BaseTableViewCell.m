//
//  BaseTableViewCell.m
//  Logistika
//
//  Created by BoHuang on 6/10/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(NSDictionary*)data{
    self.vc = data[@"vc"];
    self.aDelegate = data[@"aDelegate"];
    self.indexPath = data[@"indexPath"];
    self.tableView = data[@"tableView"];
    self.model = data[@"model"];
    
    self.inputData = data;
    
}
- (IBAction)clickEntireCell:(id)sender {
    if (self.aDelegate!=nil) {
        NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
        data[@"indexPath"] = self.indexPath;
        data[@"inputData"] = self.inputData;
        data[@"model"] = self.model;
        
        [self.aDelegate didSubmit:data View:self.tableView];
    }
}
@end
