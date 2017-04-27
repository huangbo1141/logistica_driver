//
//  OrderHistoryViewController.m
//  Logistika
//
//  Created by BoHuang on 4/27/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "CGlobal.h"
#import "NetworkParser.h"
#import "OrderResponse.h"
#import "OrderHisModel.h"
#import "ViewScrollContainer.h"
#import "OrderItemView.h"

@interface OrderHistoryViewController ()
@property(nonatomic,strong) OrderResponse*response;

@property(nonatomic,strong) NSMutableArray*data_0;
@property(nonatomic,strong) NSMutableArray*data_1;
@property(nonatomic,strong) NSMutableArray*data_2;;
@end

@implementation OrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)filterData{
    int type_none = 0;
    int type_complete = 4;
    int type_pending = 2;
    int type_returned = 6;
    self.data_0 = [[NSMutableArray alloc] init];
    self.data_1 = [[NSMutableArray alloc] init];
    self.data_2 = [[NSMutableArray alloc] init];
    for (int i=0; i<_response.orders.count; i++) {
        OrderHisModel*model = self.response.orders[i];
        int state = [model.state intValue];
        if (state == 2 || state == 3 || state == 5 ) {
            [self.data_1 addObject:model];
        }
        else if (state == 4 || state == 0) {
            [self.data_0 addObject:model];
        }else{
            if (state == 6){
                [self.data_2 addObject:model];
            }
        }
    }
    [self addViews:self.data_0 Parent:self.viewRoot1];
    [self addViews:self.data_1 Parent:self.viewRoot2];
    [self addViews:self.data_2 Parent:self.viewRoot3];
    
}
-(void)addViews:(NSMutableArray*)data Parent:(UIView*)view{
    if (data.count == 0) {
        return;
    }
    // determine area
    CGRect bound = [[UIScreen mainScreen] bounds];
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat headerHeight = self.topBarView.constraint_Height.constant;
    CGFloat topSpace = statusHeight+headerHeight+50;
    CGRect rect = CGRectMake(0, topSpace, bound.size.width, bound.size.height - topSpace);
    
    CGFloat dx = 8;
    CGFloat dy = 8;
    CGRect newRect = CGRectInset(rect, dx, dy);
    
    for (UIView *subview in view.subviews)
    {
        [subview removeFromSuperview];
    }
    
    ViewScrollContainer* scrollContainer = (ViewScrollContainer*)[[NSBundle mainBundle] loadNibNamed:@"ViewScrollContainer" owner:self options:nil][0];
    for (int i=0; i<data.count; i++) {
        OrderHisModel*model = data[i];
        OrderItemView* itemView = (OrderItemView*)[[NSBundle mainBundle] loadNibNamed:@"OrderItemView" owner:self options:nil][0];
        [itemView firstProcess:0];
        
        [scrollContainer addOneView:itemView];
        [itemView setData:model];
    }
    
    if (self.response.orders.count>0) {
        [view addSubview:scrollContainer];
        scrollContainer.frame = CGRectMake(dx, dy, newRect.size.width, newRect.size.height);
        
    }
}
- (IBAction)segChanged:(id)sender {
    NSInteger index= self.segControl.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            break;
        }
        case 1:
        {
            break;
        }
        case 2:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}
-(void)loadData{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    EnvVar* env = [CGlobal sharedId].env;
    if (env.mode == c_PERSONAL) {
        params[@"user_id"] = env.user_id;
    }else if(env.mode == c_CORPERATION){
        params[@"user_id"] = env.corporate_user_id;
    }
    NetworkParser* manager = [NetworkParser sharedManager];
    [CGlobal showIndicator:self];
    [manager ontemplateGeneralRequest2:params BasePath:BASE_URL Path:@"get_orders_his" withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            // succ
            if (dict[@"result" ]!=nil) {
                if ([dict[@"result"] intValue] == 200) {
                    [self clearReschedule];
                    
                    // parse
                    OrderResponse* response = [[OrderResponse alloc] initWithDictionary_his:dict];
                    self.response = response;
                    [self filterData];
                    
                    [CGlobal stopIndicator:self];
                    return;
                }
            }
            
        }else{
            // error
            NSLog(@"Error");
        }
        
        [CGlobal stopIndicator:self];
    } method:@"POST"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clearReschedule{
    g_orderHisModels = [[NSMutableArray alloc] init];
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
