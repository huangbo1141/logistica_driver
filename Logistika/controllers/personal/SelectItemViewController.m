//
//  SelectItemViewController.m
//  Logistika
//
//  Created by BoHuang on 4/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "SelectItemViewController.h"
#import "ItemModel.h"
#import "ProductCellCamera.h"
#import "PhotoUploadViewController.h"
#import "SelectItemTableViewCell.h"
#import "AddressDetailViewController.h"
#import "CGlobal.h"

@interface SelectItemViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign,nonatomic) CGFloat cellHeight;
@end

@implementation SelectItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeight = 90;
    if (self.cameraOrderModel == nil) {
        self.cameraOrderModel = [[OrderModel alloc] initWithDictionary:nil];
        ItemModel* itemModel = [[ItemModel alloc] initWithDictionary:nil];
        
        [self.cameraOrderModel.itemModels addObject:itemModel];
    }
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib* nib = [UINib nibWithNibName:@"SelectItemTableViewCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"cell"];
    
    
    
}
-(id)checkInput{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (int k=0; k<self.cameraOrderModel.itemModels.count; k++) {
        ItemModel* imodel = self.cameraOrderModel.itemModels[k];
        NSString* title = imodel.title;
        NSString* d1 = imodel.dimension1;
        NSString* d2 = imodel.dimension2;
        NSString* d3 = imodel.dimension3;
        if ([title isEqualToString:@""] ||
            [d1 isEqualToString:@""] ||
            [d2 isEqualToString:@""] ||
            [d3 isEqualToString:@""] ) {
            return nil;
        }
    }
    return ret;
}
- (IBAction)clickContinue:(id)sender {
    id data = [self checkInput];
    if (data!=nil) {
        g_itemOrderModel = self.cameraOrderModel;
        UIStoryboard *ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
        AddressDetailViewController* vc = [ms instantiateViewControllerWithIdentifier:@"AddressDetailViewController"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController pushViewController:vc animated:true];
        });
    }else{
        [CGlobal AlertMessage:@"Please enter all info" Title:nil];
    }
}

-(void)didSubmit:(id)obj View:(UIView *)view{
    if ([view isKindOfClass:[SelectItemTableViewCell class]]) {
        NSDictionary* dict = obj;
        SelectItemTableViewCell*cell = view;
        if ([dict[@"action"] isEqualToString:@"remove"]) {
            // remove view
            NSInteger found = [self.cameraOrderModel.itemModels indexOfObject:cell.data];
            if (found!=NSNotFound) {
                [self.cameraOrderModel.itemModels removeObjectAtIndex:found];
                _btnUploadMore.hidden = false;
                [self.tableview reloadData];
            }
        }else if ([dict[@"action"] isEqualToString:@"select"]) {
            
        }
    }
}
- (IBAction)addMore:(id)sender {
    if (self.cameraOrderModel.itemModels.count < 3) {
        ItemModel* itemModel = [[ItemModel alloc] initWithDictionary:nil];
        
        [self.cameraOrderModel.itemModels addObject:itemModel];
        [self.tableview reloadData];
    }else{
        [CGlobal AlertMessage:@"Can not upload more" Title:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableview reloadData];
    if (self.cameraOrderModel.itemModels.count >=3) {
        self.btnUploadMore.hidden = true;
    }else{
        self.btnUploadMore.hidden = false;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CGFloat height = self.cellHeight * self.cameraOrderModel.itemModels.count;
    self.constraint_TH.constant = height;
    [_tableview setNeedsUpdateConstraints];
    [_tableview layoutIfNeeded];
    return self.cameraOrderModel.itemModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell initMe:self.cameraOrderModel.itemModels[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.aDelegate = self;
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
