//
//  InfoView3.m
//  Logistika
//
//  Created by BoHuang on 6/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "InfoView3.h"
#import "CGlobal.h"
#import "ReviewCameraTableViewCell.h"
#import "ReviewItemTableViewCell.h"
#import "ReviewPackageTableViewCell.h"
#import "WaveOrderModel.h"
#import "WaveOrderCorModel.h"
@implementation InfoView3

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)setData:(NSDictionary*)data{
    [super setData:data];
    int index = [self.inputData[@"index"] intValue];
    self.lblTitle.text = [NSString stringWithFormat:@"Wave %d",index+1];
    int state = 0;
    if (g_mode == c_PERSONAL) {
        WaveOrderModel* model = self.inputData[@"wave_model"];
        state = [model.state intValue];
    }else{
        WaveOrderCorModel* model = self.inputData[@"wave_model"];
        state = [model.state intValue];
    }
    switch (state) {
        case 0:
        {
            _lblStatus.text = @"Status: Cancel";
            break;
        }
        case 1:
        {
            _lblStatus.text = @"Status: Processing";
            break;
        }
        case 2:
        {
            _lblStatus.text = @"Status: On the way for pickup";
            break;
        }
        case 3:
        {
            _lblStatus.text = @"Status: On the way to destination";
            break;
        }
        case 4:
        {
            _lblStatus.text = @"Status: Order Delivered";
            break;
        }
        case 5:
        {
            _lblStatus.text = @"Status: Order on hold";
            break;
        }
        case 6:
        {
            _lblStatus.text = @"Status: Returned Order";
            break;
        }
        default:
            break;
    }
    if (g_mode == c_PERSONAL) {
        WaveOrderModel* model = self.inputData[@"wave_model"];
        _lblDateTime.text = [NSString stringWithFormat:@"Date: %@ Time:%@",model.dateModel.date,model.dateModel.time];
        _lblSourceAddress.text = [NSString stringWithFormat:@"Address :%@",model.addressModel.sourceAddress];
        _lblSourceArea.text = [NSString stringWithFormat:@"Area :%@",model.addressModel.sourceArea];
        _lblSourceCity.text = [NSString stringWithFormat:@"City :%@",model.addressModel.sourceCity];
        _lblSourceState.text = [NSString stringWithFormat:@"State :%@",model.addressModel.sourceState];
        
        _lblDesAddress.text = [NSString stringWithFormat:@"Address :%@",model.addressModel.desAddress];
        _lblDesArea.text = [NSString stringWithFormat:@"Area :%@",model.addressModel.desArea];
        _lblDesCity.text = [NSString stringWithFormat:@"City :%@",model.addressModel.desCity];
        _lblDesState.text = [NSString stringWithFormat:@"State :%@",model.addressModel.desState];
        
    }else{
        WaveOrderCorModel* model = self.inputData[@"wave_model"];
        _lblDateTime.text = [NSString stringWithFormat:@"Date: %@ Time:%@",model.dateModel.date,model.dateModel.time];
        _lblSourceAddress.text = [NSString stringWithFormat:@"Address :%@",model.addressModel.sourceAddress];
        _lblSourceArea.text = [NSString stringWithFormat:@"Area :%@",model.addressModel.sourceArea];
        _lblSourceCity.text = [NSString stringWithFormat:@"City :%@",model.addressModel.sourceCity];
        _lblSourceState.text = [NSString stringWithFormat:@"State :%@",model.addressModel.sourceState];
        
        _lblDesAddress.text = [NSString stringWithFormat:@"Address :%@",model.addressModel.desAddress];
        _lblDesArea.text = [NSString stringWithFormat:@"Area :%@",model.addressModel.desArea];
        _lblDesCity.text = [NSString stringWithFormat:@"City :%@",model.addressModel.desCity];
        _lblDesState.text = [NSString stringWithFormat:@"State :%@",model.addressModel.desState];
    }
    self.viewItems.hidden = true;
    self.viewDetail.hidden = true;
    if (g_mode == c_PERSONAL) {
        
        self.viewDetail.hidden = true;
        WaveOrderModel* model = self.inputData[@"wave_model"];
        if (model.orderModel.product_type == g_CAMERA_OPTION) {
            self.orderModel = model.orderModel;
            self.viewHeader_CAMERA.hidden = false;
            self.viewHeader_ITEM.hidden = true;
            self.viewHeader_PACKAGE.hidden = true;
            
            UINib* nib = [UINib nibWithNibName:@"ReviewCameraTableViewCell" bundle:nil];
            [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
            self.cellHeight = 40;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
        }else if(model.orderModel.product_type == g_ITEM_OPTION){
            self.orderModel = model.orderModel;
            self.viewHeader_CAMERA.hidden = true;
            self.viewHeader_ITEM.hidden = false;
            self.viewHeader_PACKAGE.hidden = true;
            
            UINib* nib = [UINib nibWithNibName:@"ReviewItemTableViewCell" bundle:nil];
            [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
            self.cellHeight = 40;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
        }else if(model.orderModel.product_type == g_PACKAGE_OPTION){
            self.orderModel = model.orderModel;
            self.viewHeader_CAMERA.hidden = true;
            self.viewHeader_ITEM.hidden = true;
            self.viewHeader_PACKAGE.hidden = false;
            
            UINib* nib = [UINib nibWithNibName:@"ReviewPackageTableViewCell" bundle:nil];
            [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
            self.cellHeight = 40;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
        }
        if (model.orderModel.itemModels.count>0) {
            self.viewItems.hidden = false;
        }
        
        [self calculateRowHeight];
        [self.tableView reloadData];
        
    }else{
        WaveOrderCorModel* model = self.inputData[@"wave_model"];
        self.viewItems.hidden = true;
        self.viewDetail.hidden = false;
        self.lblDeliver.text = model.ddescription;
        self.lblLoadType.text = [CGlobal getTruck:model.loadtype];
        // hgcneed
        //        self.lblLoadType.text = [CGlobal getTruck:g_corporateModel.truck];
    }
}
-(CGFloat)getHeight{
    CGRect scRect = [[UIScreen mainScreen] bounds];
    scRect.size.width = MIN(scRect.size.width -32 - 16,388);
    scRect.size.height = 20;
    
    CGSize size = [self.stackRoot systemLayoutSizeFittingSize:scRect.size withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityDefaultLow];
    
    //        NSLog(@"widthwidth %f height %f",size.width,size.height);
    
    NSLog(@"height estimated %f",size.height);
    return size.height;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.constraint_TH.constant = self.totalHeight;
    [self.tableView setNeedsUpdateConstraints];
    [self.tableView layoutIfNeeded];
    return self.orderModel.itemModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.orderModel.product_type == g_CAMERA_OPTION) {
        ReviewCameraTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        NSMutableDictionary* inputData = [[NSMutableDictionary alloc] init];
        inputData[@"vc"] = self.vc;
        inputData[@"indexPath"] = indexPath;
        inputData[@"aDelegate"] = self;
        inputData[@"tableView"] = tableView;
        inputData[@"model"] = self.orderModel.itemModels[indexPath.row];
        
        
        [cell setData:inputData];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(self.orderModel.product_type == g_ITEM_OPTION){
        ReviewItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        [cell initMe:self.orderModel.itemModels[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aDelegate = self;
        return cell;
    }else{
        ReviewPackageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        [cell initMe:self.orderModel.itemModels[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aDelegate = self;
        return cell;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* key = [NSString stringWithFormat:@"%d",indexPath.row];
    if(self.height_dict[key]!=nil){
        NSString* value = self.height_dict[key];
        return [value floatValue];
    }
    return self.cellHeight;
}
-(void)calculateRowHeight{
    self.height_dict = [[NSMutableDictionary alloc] init];
    self.totalHeight = 0;
    
    CGRect scRect = [[UIScreen mainScreen] bounds];
    scRect.size.width = MIN(scRect.size.width -32 - 16,388);
    
    for (int i=0; i<self.orderModel.itemModels.count; i++) {
        NSIndexPath*path = [NSIndexPath indexPathForRow:i inSection:0];
        CGFloat height = [CGlobal tableView1:self.tableView tableView2:self.tableView tableView3:self.tableView heightForRowAtIndexPath:path DefaultHeight:self.cellHeight Data:self.orderModel OrderType:g_mode Padding:0 Width:scRect.size.width];
        NSString*key = [NSString stringWithFormat:@"%d",i];
        NSString*value = [NSString stringWithFormat:@"%f",height];
        self.height_dict[key] = value;
        self.totalHeight = self.totalHeight + height;
    }
    self.constraint_TH.constant = self.totalHeight;
}
@end

