//
//  ReviewOrderViewController.m
//  Logistika
//
//  Created by BoHuang on 4/24/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "ReviewOrderViewController.h"
#import "CGlobal.h"
#import "ReviewCameraTableViewCell.h"
#import "ReviewItemTableViewCell.h"
#import "ReviewPackageTableViewCell.h"
#import "CameraOrderViewController.h"
#import "SelectItemViewController.h"
#import "SelectPackageViewController.h"
#import "AddressDetailViewController.h"
#import "DateTimeViewController.h"
#import "PaymentViewController.h"

@interface ReviewOrderViewController ()
@property (nonatomic,strong) OrderModel* orderModel;
@property (nonatomic,assign) CGFloat cellHeight;
@end

@implementation ReviewOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    EnvVar* env = [CGlobal sharedId].env;
    if(env.mode!=c_CORPERATION){
        [self showItemLists];
    }else{
        // hgcneed
        self.viewHeader.hidden = true;
        
    }
    self.lblPickDate.text = [NSString stringWithFormat:@"Pick up on %@%@",g_dateModel.date,g_dateModel.time];
    self.lblServiceLevel.text = [NSString stringWithFormat:@"Service Level: %@, $%@, %@",g_serviceModel.name,g_serviceModel.price,g_serviceModel.time_in];
}
- (IBAction)clickContinue:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    PaymentViewController*vc = [ms instantiateViewControllerWithIdentifier:@"PaymentViewController"] ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:true];
    });
}
-(void)showAddressDetails{
    if (g_addressModel.desAddress!=nil) {
        _lblPickAddress.text = g_addressModel.sourceAddress;
        _lblPickCity.text = g_addressModel.sourceCity;
        _lblPickState.text = g_addressModel.sourceState;
        _lblPickPincode.text = g_addressModel.sourcePinCode;
        _lblPickPhone.text = g_addressModel.sourcePhonoe;
        _lblPickLandMark.text = g_addressModel.sourceLandMark;
        _lblPickInst.text = g_addressModel.sourceInstruction;
        
        _lblDestAddress.text = g_addressModel.desAddress;
        _lblDestCity.text = g_addressModel.desCity;
        _lblDestState.text = g_addressModel.desState;
        _lblDestPincode.text = g_addressModel.desPinCode;
//        _lblDestPhone.text = g_addressModel.des;
        _lblDestLandMark.text = g_addressModel.desLandMark;
        _lblDestInst.text = g_addressModel.desInstruction;
    }
    _lblDestPhone.hidden = true;
}
-(void)initView{
    EnvVar* env = [CGlobal sharedId].env;
    if (env.quote) {
        _btnEditProduct.hidden = true;
        _btnEditPickUpAddress.hidden = true;
    }
    
    [self.btnEditProduct addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnEditPickUpAddress addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnEditPickUpDate addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnEditServiceLevel addTarget:self action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnEditProduct.tag = 200;
    self.btnEditPickUpAddress.tag = 201;
    self.btnEditPickUpDate.tag = 202;
    self.btnEditServiceLevel.tag = 203;
}
-(void)clickView:(UIView*)sender{
    int tag = (int)sender.tag;
    switch (tag) {
        case 200:
        {
            // edit product
            UINavigationController* navc = self.navigationController;
            for (int i=0; i<navc.viewControllers.count; i++) {
                UIViewController*vc = navc.viewControllers[i];
                if ([vc isKindOfClass:[CameraOrderViewController class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [navc popToViewController:vc animated:true];
                    });
                    return;
                }
                if ([vc isKindOfClass:[SelectItemViewController class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [navc popToViewController:vc animated:true];
                    });
                    return;
                }
                if ([vc isKindOfClass:[SelectPackageViewController class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [navc popToViewController:vc animated:true];
                    });
                    return;
                }
            }
            break;
        }
        case 201:{
            // edit address
            UINavigationController* navc = self.navigationController;
            for (int i=0; i<navc.viewControllers.count; i++) {
                UIViewController*vc = navc.viewControllers[i];
                if ([vc isKindOfClass:[AddressDetailViewController class]]) {
                    AddressDetailViewController*tvc = vc;
//                    tvc.type = @"edit";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [navc popToViewController:vc animated:true];
                    });
                    return;
                }
            }
            break;
        }
        case 202:{
            // edit date
            UINavigationController* navc = self.navigationController;
            for (int i=0; i<navc.viewControllers.count; i++) {
                UIViewController*vc = navc.viewControllers[i];
                if ([vc isKindOfClass:[DateTimeViewController class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [navc popToViewController:vc animated:true];
                    });
                    return;
                }
            }
            break;
        }
        case 203:{
            // edit service
            UINavigationController* navc = self.navigationController;
            for (int i=0; i<navc.viewControllers.count; i++) {
                UIViewController*vc = navc.viewControllers[i];
                if ([vc isKindOfClass:[DateTimeViewController class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [navc popToViewController:vc animated:true];
                    });
                    return;
                }
            }
            break;
            
        }
            
        default:
            break;
    }
}
-(void)showItemLists{
    EnvVar* env = [CGlobal sharedId].env;
    if (g_ORDER_TYPE == g_CAMERA_OPTION) {
        self.orderModel = g_cameraOrderModel;
        self.viewHeader_CAMERA.hidden = false;
        self.viewHeader_ITEM.hidden = true;
        self.viewHeader_PACKAGE.hidden = true;
        
        UINib* nib = [UINib nibWithNibName:@"ReviewCameraTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
        self.cellHeight = 40;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }else if(g_ORDER_TYPE == g_ITEM_OPTION){
        self.orderModel = g_itemOrderModel;
        self.viewHeader_CAMERA.hidden = true;
        self.viewHeader_ITEM.hidden = false;
        self.viewHeader_PACKAGE.hidden = true;
        
        UINib* nib = [UINib nibWithNibName:@"ReviewItemTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
        self.cellHeight = 40;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }else if(g_ORDER_TYPE == g_PACKAGE_OPTION){
        self.orderModel = g_packageOrderModel;
        self.viewHeader_CAMERA.hidden = true;
        self.viewHeader_ITEM.hidden = true;
        self.viewHeader_PACKAGE.hidden = false;
        
        UINib* nib = [UINib nibWithNibName:@"ReviewPackageTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
        self.cellHeight = 40;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CGFloat height = self.cellHeight * self.orderModel.itemModels.count;
    self.constraint_TH.constant = height;
    [self.tableView setNeedsUpdateConstraints];
    [self.tableView layoutIfNeeded];
    return self.orderModel.itemModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (g_ORDER_TYPE == g_CAMERA_OPTION) {
        ReviewCameraTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        [cell initMe:self.orderModel.itemModels[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aDelegate = self;
        return cell;
    }else if(g_ORDER_TYPE == g_ITEM_OPTION){
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
