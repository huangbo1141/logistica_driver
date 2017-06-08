//
//  LTLViewController.m
//  Logistika
//
//  Created by BoHuang on 5/6/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "LTLViewController.h"
#import "OrderPickUpViewController.h"
#import "NetworkParser.h"
#import "TblTruck.h"
#import "LTLView.h"

@interface LTLViewController ()
@property (nonatomic,strong) LoginResponse* truckResponse;

@end

@implementation LTLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self get_truck];
}
-(void)viewWillAppear:(BOOL)animated{
    switch (self.type) {
        case 0:
        {
            self.title = @"Orders for Pick up";
            break;
        }
        case 1:
        {
            // init pickup
            self.title = @"Picked Up Orders";
            break;
        }
        case 2:
        {
            // initcompleted view
            self.title = @"Completed Orders";
            break;
        }
        case 3:
        {
            self.title = @"On Hold Orders";
            break;
        }
        case 4:
        {
            self.title = @"Returned";
            break;
        }
            
        default:
            break;
    }
    self.navigationController.navigationBar.hidden = false;
}
-(void)addViews:(NSMutableArray*)data Parent:(UIView*)view{
    if (data.count == 0) {
        return;
    }
    for (int i=0; i<data.count; i++) {
        TblTruck*model = data[i];
        LTLView* itemView = (LTLView*)[[NSBundle mainBundle] loadNibNamed:@"LTLView" owner:self options:nil][0];
        [itemView firstProcess:@{@"truck":model,@"aDelegate":self}];
        [self.stackView addArrangedSubview:itemView];
    }
}
-(void)get_truck{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    
    NetworkParser* manager = [NetworkParser sharedManager];
    [manager ontemplateGeneralRequest2:data BasePath:BASE_DATA_URL Path:@"get_truck" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            if (dict!=nil && dict[@"result"] != nil) {
                if ([dict[@"result"] intValue] == 200) {
                    LoginResponse* data = [[LoginResponse alloc] initWithDictionary:dict];
                    if (data.truck.count > 0) {
                        self.truckResponse = data;
                        [self addViews:data.truck Parent:nil];
                    }
                    
                }else{
//                    [CGlobal AlertMessage:@"Fail" Title:nil];
                }
            }
        }else{
            NSLog(@"Error");
        }
        
    } method:@"POST"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menu1:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    OrderPickUpViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderPickUpViewController"];
    vc.type = self.type;
    vc.mode = @"tl";
    vc.hideMode = 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.title = @"";
        [self.navigationController pushViewController:vc animated:true];
    });
}
- (IBAction)menu2:(id)sender {
    UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    OrderPickUpViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderPickUpViewController"];
    vc.type = self.type;
    vc.mode = @"ltl";
    vc.hideMode = 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.title = @"";
        [self.navigationController pushViewController:vc animated:true];
    });
}
-(void)didSubmit:(NSDictionary *)data View:(UIView *)view{
    if ([view isKindOfClass:[LTLView class]] && data[@"truck"]!=nil)   {
        TblTruck* truck = data[@"truck"];
        UIStoryboard* ms = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
        OrderPickUpViewController* vc = [ms instantiateViewControllerWithIdentifier:@"OrderPickUpViewController"];
        vc.type = self.type;
        vc.mode = truck.code;
        vc.hideMode = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = @"";
            [self.navigationController pushViewController:vc animated:true];
        });
    }
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
